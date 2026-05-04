import SwiftUI

struct SecuritySettingsView: View {
    @EnvironmentObject private var appState: AppStateManager
    @State private var biometricEnabled: Bool = false
    @State private var twoFactorEnabled = false
    @State private var showChangePwd   = false

    private let biometric = BiometricService.shared

    var body: some View {
        List {
            // Biometrics
            if biometric.isAvailable {
                Section {
                    Toggle(isOn: $biometricEnabled) {
                        Label(biometric.displayName, systemImage: biometric.systemImage)
                    }
                    .tint(Color.accentRed)
                    .onChange(of: biometricEnabled) { _, newValue in
                        appState.isBiometricEnabled = newValue
                        HapticService.trigger(.selection)
                    }
                } header: {
                    Text("Biometric Authentication")
                } footer: {
                    Text("Use \(biometric.displayName) to unlock the app instead of your password.")
                }
            }

            // Two-Factor
            Section {
                Toggle(isOn: $twoFactorEnabled) {
                    Label("Two-Factor Authentication", systemImage: "lock.shield.fill")
                }
                .tint(Color.accentRed)
            } footer: {
                Text("Add an extra layer of security to your account.")
            }

            // Password
            Section("Password") {
                Button {
                    showChangePwd = true
                } label: {
                    Label("Change Password", systemImage: "key.fill")
                        .foregroundStyle(.primary)
                }
            }

            // Active sessions (mock)
            Section("Active Sessions") {
                ForEach(mockSessions, id: \.0) { session in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(session.0).font(.subheadline).fontWeight(.medium)
                            Text(session.1).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if session.0 == "iPhone 16 Pro · This device" {
                            Text("Current").font(.caption).foregroundStyle(.green)
                        } else {
                            Button("Revoke") { }
                                .font(.caption)
                                .foregroundStyle(Color.accentRed)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { biometricEnabled = appState.isBiometricEnabled }
        .sheet(isPresented: $showChangePwd) {
            ChangePasswordSheet()
        }
    }

    private var mockSessions: [(String, String)] {[
        ("iPhone 16 Pro · This device", "Boston, MA · Active now"),
        ("MacBook Pro",                  "Cambridge, MA · 2 days ago"),
        ("iPad Air",                     "New York, NY · 5 days ago")
    ]}
}

// MARK: - Change Password Sheet

struct ChangePasswordSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var current  = ""
    @State private var newPwd   = ""
    @State private var confirm  = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Current Password") {
                    SecureField("Enter current password", text: $current)
                }
                Section("New Password") {
                    SecureField("New password", text: $newPwd)
                    SecureField("Confirm new password", text: $confirm)
                    if !newPwd.isEmpty {
                        PasswordStrengthView(strength: PasswordStrength.evaluate(newPwd))
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            HapticService.trigger(.success)
                            dismiss()
                        }
                    }
                    .disabled(current.isEmpty || newPwd.count < 8 || newPwd != confirm)
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack { SecuritySettingsView() }
        .environmentObject(AppStateManager())
}
