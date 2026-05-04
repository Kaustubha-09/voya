import SwiftUI

// MARK: - Color palette

extension Color {
    static let accentRed = Color(red: 0.91, green: 0.19, blue: 0.31)   // Airbnb-ish coral-red
    static let subtleGray = Color(UIColor.systemGray5)
    static let cardShadow = Color.black.opacity(0.08)
}

// MARK: - View modifiers

extension View {
    func cardStyle() -> some View {
        self
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .cardShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Double helpers

extension Double {
    var starRating: String {
        String(format: "%.1f", self)
    }

    var budgetFormatted: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: self)) ?? "$\(Int(self))"
    }
}
