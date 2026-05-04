import LocalAuthentication

final class BiometricService {
    static let shared = BiometricService()

    var biometricType: LABiometryType {
        let ctx = LAContext()
        _ = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return ctx.biometryType
    }

    var isAvailable: Bool {
        var error: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                            error: &error)
    }

    var displayName: String {
        switch biometricType {
        case .faceID:  return "Face ID"
        case .touchID: return "Touch ID"
        default:       return "Biometrics"
        }
    }

    var systemImage: String {
        switch biometricType {
        case .faceID:  return "faceid"
        case .touchID: return "touchid"
        default:       return "lock.shield"
        }
    }

    func authenticate(reason: String) async -> Bool {
        guard isAvailable else { return false }
        do {
            return try await LAContext()
                .evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                localizedReason: reason)
        } catch {
            return false
        }
    }
}
