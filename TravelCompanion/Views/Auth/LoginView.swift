import SwiftUI

struct LoginView: View {
    @StateObject private var vm = AuthViewModel()
    @EnvironmentObject private var appState: AppStateManager
    @State private var showSignUp      = false
    @State private var showForgotPwd   = false
    @State private var showPassword    = false

    private let biometric = BiometricService.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    header
                        .padding(.top, 48)
                        .padding(.bottom, 40)

                    formSection
                    optionsRow
                    loginButton
                    divider
                    socialSection
                    signUpPrompt
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 28)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignUp) {
                SignUpView().environmentObject(appState)
            }
            .sheet(isPresented: $showForgotPwd) {
                ForgotPasswordView()
            }
        }
        .task {
            // Offer biometric on load if enabled and returning user
            if appState.isBiometricEnabled && biometric.isAvailable {
                await appState.unlockWithBiometric()
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "airplane.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.accentRed)
            Text("Welcome back")
                .font(.system(size: 28, weight: .bold, design: .rounded))
            Text("Sign in to continue your journey")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Form

    private var formSection: some View {
        VStack(spacing: 14) {
            // Email
            VStack(alignment: .leading, spacing: 4) {
                TextField("Email address", text: $vm.loginEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding(14)
                    .background(Color.subtleGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                if let err = vm.loginEmailError {
                    Text(err).font(.caption).foregroundStyle(.red).padding(.leading, 4)
                }
            }

            // Password
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Group {
                        if showPassword {
                            TextField("Password", text: $vm.loginPassword)
                        } else {
                            SecureField("Password", text: $vm.loginPassword)
                        }
                    }
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(14)
                .background(Color.subtleGray)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                if let err = vm.loginPasswordError {
                    Text(err).font(.caption).foregroundStyle(.red).padding(.leading, 4)
                }
            }
        }
    }

    // MARK: - Options row

    private var optionsRow: some View {
        HStack {
            Toggle(isOn: $vm.rememberMe) {
                Text("Remember me").font(.subheadline)
            }
            .toggleStyle(CheckboxToggleStyle())

            Spacer()

            Button("Forgot Password?") { showForgotPwd = true }
                .font(.subheadline)
                .foregroundStyle(Color.accentRed)
        }
        .padding(.vertical, 10)
    }

    // MARK: - Login button

    private var loginButton: some View {
        VStack(spacing: 12) {
            if let err = vm.errorMessage {
                Text(err)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task { await vm.login { token, user in appState.signIn(token: token, user: user) } }
            } label: {
                Group {
                    if vm.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Sign In")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(vm.canLogin ? Color.accentRed : Color.subtleGray)
                .foregroundStyle(vm.canLogin ? .white : .secondary)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .disabled(!vm.canLogin || vm.isLoading)

            // Biometric shortcut
            if biometric.isAvailable {
                Button {
                    Task { await appState.unlockWithBiometric() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: biometric.systemImage)
                        Text("Sign in with \(biometric.displayName)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.accentRed)
                }
            }
        }
        .padding(.bottom, 16)
    }

    // MARK: - Divider

    private var divider: some View {
        HStack {
            Rectangle().fill(Color(UIColor.separator)).frame(height: 1)
            Text("or").font(.caption).foregroundStyle(.secondary).padding(.horizontal, 12)
            Rectangle().fill(Color(UIColor.separator)).frame(height: 1)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Social

    private var socialSection: some View {
        VStack(spacing: 12) {
            SocialLoginButton(provider: .apple)  { Task { await vm.login { t, u in appState.signIn(token: t, user: u) } } }
            SocialLoginButton(provider: .google) { Task { await vm.login { t, u in appState.signIn(token: t, user: u) } } }
        }
        .padding(.bottom, 20)
    }

    // MARK: - Sign Up prompt

    private var signUpPrompt: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?").foregroundStyle(.secondary)
            Button("Sign Up") { showSignUp = true }
                .foregroundStyle(Color.accentRed)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
}

// MARK: - Custom checkbox style

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundStyle(configuration.isOn ? Color.accentRed : .secondary)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}

#Preview {
    LoginView().environmentObject(AppStateManager())
}
