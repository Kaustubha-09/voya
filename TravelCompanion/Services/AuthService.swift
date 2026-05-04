import Foundation

// Mock auth service — simulates network roundtrip latency and validation.
// Swap the method bodies for real API calls in production.

enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Incorrect email or password."
        case .emailAlreadyInUse:  return "An account with this email already exists."
        case .weakPassword:       return "Password must be at least 8 characters."
        case .networkError:       return "Network error. Please try again."
        case .unknown:            return "Something went wrong. Please try again."
        }
    }
}

struct AuthService {
    static let shared = AuthService()

    // Simulated registered accounts (in-memory "database")
    private static var registeredEmails: Set<String> = [
        "demo@travel.com"
    ]

    func signIn(email: String, password: String) async throws -> (token: String, user: User) {
        try await Task.sleep(for: .milliseconds(1200))

        guard !email.isEmpty, !password.isEmpty else { throw AuthError.invalidCredentials }
        guard email.contains("@"), password.count >= 8 else { throw AuthError.invalidCredentials }

        // Mock: any valid-format credentials succeed
        let user = User(
            id: UUID().uuidString,
            firstName: String(email.prefix(upTo: email.firstIndex(of: "@") ?? email.endIndex)).capitalized,
            lastName: "User",
            email: email,
            phone: "",
            bio: "",
            profileImageURL: nil,
            dateOfBirth: nil,
            isEmailVerified: true,
            isIDVerified: false,
            isHost: false,
            memberSince: Date.now
        )
        let token = "tc_tok_\(UUID().uuidString.replacingOccurrences(of: "-", with: ""))"
        return (token, user)
    }

    func signUp(firstName: String, lastName: String,
                email: String, password: String) async throws -> (token: String, user: User) {
        try await Task.sleep(for: .milliseconds(1400))

        guard !email.isEmpty, email.contains("@") else { throw AuthError.invalidCredentials }
        guard password.count >= 8 else { throw AuthError.weakPassword }
        guard !Self.registeredEmails.contains(email.lowercased()) else { throw AuthError.emailAlreadyInUse }

        Self.registeredEmails.insert(email.lowercased())

        let user = User(
            id: UUID().uuidString,
            firstName: firstName.trimmingCharacters(in: .whitespaces).capitalized,
            lastName: lastName.trimmingCharacters(in: .whitespaces).capitalized,
            email: email.lowercased(),
            phone: "",
            bio: "",
            profileImageURL: nil,
            dateOfBirth: nil,
            isEmailVerified: false,
            isIDVerified: false,
            isHost: false,
            memberSince: Date.now
        )
        let token = "tc_tok_\(UUID().uuidString.replacingOccurrences(of: "-", with: ""))"
        return (token, user)
    }

    func resetPassword(email: String) async throws {
        try await Task.sleep(for: .milliseconds(1000))
        guard email.contains("@") else { throw AuthError.invalidCredentials }
        // No-op in mock — real impl sends reset email
    }
}
