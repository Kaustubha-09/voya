import Foundation

// Owns the auth token lifecycle. Token stored in Keychain; user profile in UserDefaults.
final class SessionManager {
    static let shared = SessionManager()

    private let keychain = KeychainService.shared
    private let tokenKey  = "auth_token"
    private let userKey   = "current_user"
    private let encoder   = JSONEncoder()
    private let decoder   = JSONDecoder()

    var isAuthenticated: Bool {
        keychain.get(for: tokenKey) != nil
    }

    var currentUser: User? {
        get {
            guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
            return try? decoder.decode(User.self, from: data)
        }
        set {
            if let u = newValue, let data = try? encoder.encode(u) {
                UserDefaults.standard.set(data, forKey: userKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userKey)
            }
        }
    }

    func createSession(token: String, user: User) {
        keychain.save(token, for: tokenKey)
        currentUser = user
    }

    func updateUser(_ user: User) {
        currentUser = user
    }

    func clearSession() {
        keychain.delete(for: tokenKey)
        currentUser = nil
    }
}
