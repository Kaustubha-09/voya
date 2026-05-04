import Foundation

// Price intelligence: classify a stay's price relative to the cohort mean.
struct PriceAnalysis {
    enum Badge: String {
        case greatValue  = "Great Value"
        case belowAvg    = "Below Avg"
        case average     = "Average"
        case premium     = "Premium"
        case luxury      = "Luxury"
    }

    let badge: Badge
    let percentDiff: Double // negative = cheaper than average

    var color: String { // SwiftUI Color name returned as a tag for use at call site
        switch badge {
        case .greatValue:  return "green"
        case .belowAvg:    return "mint"
        case .average:     return "secondary"
        case .premium:     return "orange"
        case .luxury:      return "red"
        }
    }

    var showBadge: Bool { badge != .average }
}

struct PriceAnalysisService {
    // Pre-compute analyses for all stays in one pass (O(n))
    func buildCache(stays: [Stay]) -> [String: PriceAnalysis] {
        guard !stays.isEmpty else { return [:] }
        let avg = stays.map(\.pricePerNight).reduce(0, +) / Double(stays.count)
        return Dictionary(uniqueKeysWithValues: stays.map { ($0.id, analyze($0, average: avg)) })
    }

    private func analyze(_ stay: Stay, average: Double) -> PriceAnalysis {
        let diff = (stay.pricePerNight - average) / average
        let badge: PriceAnalysis.Badge
        switch diff {
        case ..<(-0.25): badge = .greatValue
        case (-0.25)...(-0.08): badge = .belowAvg
        case (-0.08)...(0.08):  badge = .average
        case (0.08)...(0.30):   badge = .premium
        default: badge = .luxury
        }
        return PriceAnalysis(badge: badge, percentDiff: diff)
    }
}
