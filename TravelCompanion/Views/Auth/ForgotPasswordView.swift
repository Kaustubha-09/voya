import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var vm = AuthViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()

                Image(systemName: "lock.rotation")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.accentRed)

                VStack(spacing: 8) {
                    Text(vm.resetSent ? "Check your inbox" : "Reset your password")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(vm.resetSent
                         ? "We've sent a reset link to \(vm.resetEmail)."
                         : "Enter the email you used to sign up and we'll send a reset link.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                if !vm.resetSent {
                    VStack(spacing: 12) {
                        TextField("Email address", text: $vm.resetEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding(14)
                            .background(Color.subtleGray)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        if let err = vm.errorMessage {
                            Text(err).font(.caption).foregroundStyle(.red)
                        }

                        Button {
                            Task { await vm.sendPasswordReset() }
                        } label: {
                            Group {
                                if vm.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Send Reset Link").font(.headline)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(vm.resetEmail.contains("@") ? Color.accentRed : Color.subtleGray)
                            .foregroundStyle(vm.resetEmail.contains("@") ? .white : .secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .disabled(!vm.resetEmail.contains("@") || vm.isLoading)
                    }
                    .padding(.horizontal, 28)
                } else {
                    Button("Back to Sign In") { dismiss() }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.accentRed)
                        .controlSize(.large)
                }

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview { ForgotPasswordView() }
