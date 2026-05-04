import SwiftUI

struct SignUpView: View {
    @StateObject private var vm = AuthViewModel()
    @EnvironmentObject private var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    @State private var showPassword = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    progressBar
                        .padding(.top, 8)

                    stepContent
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal:   .move(edge: .leading).combined(with: .opacity)
                        ))
                        .id(vm.signUpStep)

                    if let err = vm.errorMessage {
                        Text(err)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    nextButton
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
                .animation(.easeInOut(duration: 0.3), value: vm.signUpStep)
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    // MARK: - Progress bar

    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(1...3, id: \.self) { step in
                RoundedRectangle(cornerRadius: 3)
                    .fill(step <= vm.signUpStep ? Color.accentRed : Color.subtleGray)
                    .frame(height: 6)
                    .animation(.easeInOut(duration: 0.3), value: vm.signUpStep)
            }
        }
    }

    // MARK: - Step content

    @ViewBuilder
    private var stepContent: some View {
        switch vm.signUpStep {
        case 1: step1
        case 2: step2
        default: step3
        }
    }

    private var step1: some View {
        VStack(alignment: .leading, spacing: 20) {
            stepHeader(title: "What's your name?",
                       subtitle: "We'd love to know who you are")

            VStack(spacing: 12) {
                inputField("First name", text: $vm.firstName)
                inputField("Last name", text: $vm.lastName)
            }
        }
    }

    private var step2: some View {
        VStack(alignment: .leading, spacing: 20) {
            stepHeader(title: "Account details",
                       subtitle: "Secure your account with a strong password")

            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    inputField("Email address", text: $vm.signUpEmail, keyboard: .emailAddress)
                    if let err = vm.signUpEmailError {
                        Text(err).font(.caption).foregroundStyle(.red).padding(.leading, 4)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password", text: $vm.signUpPassword)
                            } else {
                                SecureField("Password", text: $vm.signUpPassword)
                            }
                        }
                        .autocapitalization(.none)
                        Button { showPassword.toggle() } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(14)
                    .background(Color.subtleGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    // Password strength meter
                    if !vm.signUpPassword.isEmpty {
                        PasswordStrengthView(strength: vm.passwordStrength)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    SecureField("Confirm password", text: $vm.confirmPassword)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(Color.subtleGray)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    if let err = vm.confirmPasswordError {
                        Text(err).font(.caption).foregroundStyle(.red).padding(.leading, 4)
                    }
                }
            }

            Text("By creating an account, you agree to our Terms of Service and Privacy Policy.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var step3: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.accentRed)
                .padding(.top, 40)

            VStack(spacing: 8) {
                Text("Account Created!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Welcome to Travel Companion, \(vm.firstName)!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - CTA button

    private var nextButton: some View {
        Button {
            switch vm.signUpStep {
            case 1:
                withAnimation { vm.signUpStep = 2 }
                HapticService.trigger(.selection)
            case 2:
                Task { await vm.signUp { token, user in
                    withAnimation { vm.signUpStep = 3 }
                    // Brief delay so user sees confirmation before routing
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        appState.signIn(token: token, user: user)
                        dismiss()
                    }
                } }
            default:
                break
            }
        } label: {
            Group {
                if vm.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(vm.signUpStep == 1 ? "Continue" : vm.signUpStep == 2 ? "Create Account" : "Done")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(stepIsValid ? Color.accentRed : Color.subtleGray)
            .foregroundStyle(stepIsValid ? .white : .secondary)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .disabled(!stepIsValid || vm.isLoading)
    }

    private var stepIsValid: Bool {
        switch vm.signUpStep {
        case 1: return vm.signUpNameValid
        case 2: return vm.canSignUp
        default: return false
        }
    }

    // MARK: - Helpers

    private func stepHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func inputField(_ placeholder: String, text: Binding<String>,
                            keyboard: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboard)
            .autocapitalization(keyboard == .emailAddress ? .none : .words)
            .autocorrectionDisabled()
            .padding(14)
            .background(Color.subtleGray)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Password Strength View

struct PasswordStrengthView: View {
    let strength: PasswordStrength

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(i < strength.score ? strength.color : Color.subtleGray)
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.2), value: strength.score)
                }
            }
            Text(strength.label)
                .font(.caption)
                .foregroundStyle(strength.color)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    SignUpView().environmentObject(AppStateManager())
}
