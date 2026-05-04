import SwiftUI

struct BiometricLockView: View {
    @EnvironmentObject private var appState: AppStateManager
    private let biometric = BiometricService.shared

    var body: some View {
        ZStack {
            Color.accentRed.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Image(systemName: biometric.systemImage)
                    .font(.system(size: 72))
                    .foregroundStyle(.white)

                VStack(spacing: 8) {
                    Text("Welcome back!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("Use \(biometric.displayName) to unlock")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }

                Button {
                    Task { await appState.unlockWithBiometric() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: biometric.systemImage)
                        Text("Unlock with \(biometric.displayName)")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(.white)
                    .foregroundStyle(Color.accentRed)
                    .clipShape(Capsule())
                }

                Button("Use Password Instead") {
                    appState.signOut()
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))

                Spacer()
            }
        }
        .task { await appState.unlockWithBiometric() }
    }
}

#Preview {
    BiometricLockView().environmentObject(AppStateManager())
}
