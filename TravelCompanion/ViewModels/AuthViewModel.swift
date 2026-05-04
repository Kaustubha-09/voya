import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Login state
    @Published var loginEmail    = ""
    @Published var loginPassword = ""
    @Published var rememberMe    = true

    // MARK: - Sign-up state (multi-step)
    @Published var signUpStep     = 1        // 1: Name, 2: Email+Password, 3: Done
    @Published var firstName      = ""
    @Published var lastName       = ""
    @Published var signUpEmail    = ""
    @Published var signUpPassword = ""
    @Published var confirmPassword = ""

    // MARK: - Forgot password
    @Published var resetEmail = ""
    @Published var resetSent  = false

    // MARK: - Shared UI state
    @Published var isLoading       = false
    @Published var errorMessage: String? = nil
    @Published var showPassword    = false

    // MARK: - Validation

    var loginEmailError: String? {
        guard !loginEmail.isEmpty else { return nil }
        return loginEmail.contains("@") ? nil : "Enter a valid email address"
    }

    var loginPasswordError: String? {
        guard !loginPassword.isEmpty else { return nil }
        return loginPassword.count >= 8 ? nil : "Password must be at least 8 characters"
    }

    var canLogin: Bool {
        loginEmail.contains("@") && loginPassword.count >= 8
    }

    var signUpNameValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var signUpEmailError: String? {
        guard !signUpEmail.isEmpty else { return nil }
        return signUpEmail.contains("@") ? nil : "Enter a valid email address"
    }

    var passwordStrength: PasswordStrength {
        PasswordStrength.evaluate(signUpPassword)
    }

    var confirmPasswordError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        return confirmPassword == signUpPassword ? nil : "Passwords do not match"
    }

    var canSignUp: Bool {
        signUpEmail.contains("@") &&
        signUpPassword.count >= 8 &&
        signUpPassword == confirmPassword
    }

    // MARK: - Intents

    func login(onSuccess: @escaping (String, User) -> Void) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let result = try await AuthService.shared.signIn(email: loginEmail, password: loginPassword)
            onSuccess(result.token, result.user)
        } catch {
            errorMessage = error.localizedDescription
            HapticService.trigger(.error)
        }
    }

    func signUp(onSuccess: @escaping (String, User) -> Void) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let result = try await AuthService.shared.signUp(
                firstName: firstName, lastName: lastName,
                email: signUpEmail, password: signUpPassword
            )
            HapticService.trigger(.success)
            onSuccess(result.token, result.user)
        } catch {
            errorMessage = error.localizedDescription
            HapticService.trigger(.error)
        }
    }

    func sendPasswordReset() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await AuthService.shared.resetPassword(email: resetEmail)
            resetSent = true
            HapticService.trigger(.success)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resetSignUp() {
        signUpStep = 1
        firstName = ""; lastName = ""; signUpEmail = ""; signUpPassword = ""; confirmPassword = ""
        errorMessage = nil
    }
}

// MARK: - Password strength model

enum PasswordStrength {
    case weak, fair, good, strong

    static func evaluate(_ password: String) -> PasswordStrength {
        var score = 0
        if password.count >= 8                                            { score += 1 }
        if password.contains(where: { $0.isUppercase })                  { score += 1 }
        if password.contains(where: { $0.isNumber })                     { score += 1 }
        if password.contains(where: { "!@#$%^&*()-_=+".contains($0) })  { score += 1 }
        switch score {
        case 0...1: return .weak
        case 2:     return .fair
        case 3:     return .good
        default:    return .strong
        }
    }

    var score: Int {
        switch self { case .weak: 1; case .fair: 2; case .good: 3; case .strong: 4 }
    }

    var label: String {
        switch self { case .weak: "Weak"; case .fair: "Fair"; case .good: "Good"; case .strong: "Strong" }
    }

    var color: SwiftUI.Color {
        switch self {
        case .weak:   return .red
        case .fair:   return .orange
        case .good:   return .yellow
        case .strong: return .green
        }
    }
}
