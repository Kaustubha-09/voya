import Foundation
import Security

// Thin wrapper around Security framework for storing sensitive strings
final class KeychainService {
    static let shared = KeychainService()

    private let service = "com.kaustubha.TravelCompanion"

    @discardableResult
    func save(_ value: String, for key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        // Delete existing item first to avoid duplicates
        delete(for: key)

        let query: [CFString: Any] = [
            kSecClass:           kSecClassGenericPassword,
            kSecAttrService:     service,
            kSecAttrAccount:     key,
            kSecValueData:       data,
            kSecAttrAccessible:  kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    func get(for key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecReturnData:  true,
            kSecMatchLimit:  kSecMatchLimitOne
        ]
        var result: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    func delete(for key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
