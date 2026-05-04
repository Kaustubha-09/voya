import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppStateManager()

    var body: some View {
        Group {
            switch appState.route {
            case .splash:
                SplashView()
            case .onboarding:
                OnboardingView()
                    .environmentObject(appState)
            case .biometricLock:
                BiometricLockView()
                    .environmentObject(appState)
            case .auth:
                LoginView()
                    .environmentObject(appState)
            case .main:
                MainTabView()
                    .environmentObject(appState)
            }
        }
        .task { await appState.bootstrap() }
    }
}

#Preview {
    RootView()
}
