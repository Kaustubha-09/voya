import SwiftUI

struct PriceBadge: View {
    let analysis: PriceAnalysis

    var body: some View {
        if analysis.showBadge {
            Text(analysis.badge.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(badgeColor.opacity(0.15))
                .foregroundStyle(badgeColor)
                .clipShape(Capsule())
        }
    }

    private var badgeColor: Color {
        switch analysis.badge {
        case .greatValue:  return .green
        case .belowAvg:    return Color(red: 0, green: 0.6, blue: 0.5) // mint
        case .average:     return .secondary
        case .premium:     return .orange
        case .luxury:      return Color.accentRed
        }
    }
}

#Preview {
    HStack {
        PriceBadge(analysis: PriceAnalysis(badge: .greatValue, percentDiff: -0.3))
        PriceBadge(analysis: PriceAnalysis(badge: .premium, percentDiff: 0.2))
        PriceBadge(analysis: PriceAnalysis(badge: .luxury, percentDiff: 0.5))
    }
    .padding()
}
