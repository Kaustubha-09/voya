import UIKit

enum HapticService {
    static func trigger(_ style: Style) {
        switch style {
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .soft:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .rigid:
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }

    enum Style {
        case selection, success, error, soft, rigid
    }
}
