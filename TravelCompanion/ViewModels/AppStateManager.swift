import SwiftUI

// Root state machine — drives which top-level view is shown.
@MainActor
final class AppStateManager: ObservableObject {

    enum Route: Equatable {
        case splash
        case onboarding
        case biometricLock
        case auth
        case main
    }

    @Published private(set) var route: Route = .splash
    @Published private(set) var currentUser: User? = SessionManager.shared.currentUser

    private let session   = SessionManager.shared
    private let biometric = BiometricService.shared
    private let onboardingKey = "has_seen_onboarding"
    private let biometricKey  = "biometric_enabled"

    // Called once on app launch from TravelCompanionApp
    func bootstrap() async {
        try? await Task.sleep(for: .milliseconds(1600)) // splash display time

        if !UserDefaults.standard.bool(forKey: onboardingKey) {
            route = .onboarding
            return
        }
        guard session.isAuthenticated else {
            route = .auth
            return
        }

        // Returning user: offer biometric unlock if enabled
        if UserDefaults.standard.bool(forKey: biometricKey) && biometric.isAvailable {
            route = .biometricLock
        } else {
            currentUser = session.currentUser
            route = .main
        }
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
        route = .auth
    }

    func signIn(token: String, user: User) {
        session.createSession(token: token, user: user)
        currentUser = user
        withAnimation(.easeInOut(duration: 0.35)) { route = .main }
    }

    func updateUser(_ user: User) {
        session.updateUser(user)
        currentUser = user
    }

    func signOut() {
        session.clearSession()
        currentUser = nil
        withAnimation(.easeInOut(duration: 0.35)) { route = .auth }
    }

    func unlockWithBiometric() async {
        let ok = await biometric.authenticate(reason: "Unlock Travel Companion")
        if ok {
            currentUser = session.currentUser
            withAnimation(.easeInOut(duration: 0.35)) { route = .main }
        }
    }

    var isBiometricEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: biometricKey) }
        set { UserDefaults.standard.set(newValue, forKey: biometricKey) }
    }
}
