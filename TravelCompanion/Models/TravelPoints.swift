import Foundation
import SwiftUI

struct PointsTransaction: Identifiable, Codable {
    let id: String
    let date: Date
    let type: TransactionType
    let points: Int
    let description: String
    let icon: String

    enum TransactionType: String, Codable {
        case booking      = "Booking"
        case review       = "Review"
        case referral     = "Referral"
        case squadJoin    = "Squad Join"
        case playbookFork = "Playbook Fork"
        case storyPost    = "Story Post"
        case bonus        = "Bonus"
        case redemption   = "Redemption"
        case tripComplete  = "Trip Completed"
    }

    static func earn(_ type: TransactionType, points: Int, description: String) -> PointsTransaction {
        PointsTransaction(id: UUID().uuidString, date: Date(), type: type, points: points, description: description, icon: type.defaultIcon)
    }

    static func redeem(points: Int, description: String) -> PointsTransaction {
        PointsTransaction(id: UUID().uuidString, date: Date(), type: .redemption, points: -points, description: description, icon: "gift.fill")
    }
}

extension PointsTransaction.TransactionType {
    var defaultIcon: String {
        switch self {
        case .booking:       return "bed.double.fill"
        case .review:        return "star.bubble.fill"
        case .referral:      return "person.badge.plus.fill"
        case .squadJoin:     return "person.3.fill"
        case .playbookFork:  return "map.fill"
        case .storyPost:     return "camera.fill"
        case .bonus:         return "gift.fill"
        case .redemption:    return "tag.fill"
        case .tripComplete:  return "airplane.arrival"
        }
    }
}

struct RewardTier: Identifiable {
    let id = UUID()
    let name: String
    let minPoints: Int
    let color: Color
    let icon: String
    let perks: [String]
    let multiplier: Double

    static let tiers: [RewardTier] = [
        RewardTier(
            name: "Explorer",
            minPoints: 0,
            color: .gray,
            icon: "figure.walk",
            perks: ["1× points on all bookings", "Access to member deals"],
            multiplier: 1.0
        ),
        RewardTier(
            name: "Adventurer",
            minPoints: 1000,
            color: .blue,
            icon: "figure.hiking",
            perks: ["1.25× points multiplier", "Priority squad matching", "10% off playbook upgrades"],
            multiplier: 1.25
        ),
        RewardTier(
            name: "Voyager",
            minPoints: 5000,
            color: Color(red: 0.8, green: 0.5, blue: 0.1),
            icon: "airplane",
            perks: ["1.5× points multiplier", "Free story highlights", "Exclusive destination drops", "Early access to flash squads"],
            multiplier: 1.5
        ),
        RewardTier(
            name: "Globetrotter",
            minPoints: 15000,
            color: Color(red: 0.91, green: 0.19, blue: 0.31),
            icon: "globe.americas.fill",
            perks: ["2× points multiplier", "Concierge support", "VIP squad events", "Free playbook creations", "Partner hotel upgrades"],
            multiplier: 2.0
        ),
    ]

    static func tier(for points: Int) -> RewardTier {
        tiers.filter { points >= $0.minPoints }.last ?? tiers[0]
    }

    static func nextTier(for points: Int) -> RewardTier? {
        tiers.first { points < $0.minPoints }
    }
}

struct RedemptionOption: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let cost: Int
    let icon: String
    let category: Category

    enum Category: String {
        case discount  = "Discount"
        case upgrade   = "Upgrade"
        case exclusive = "Exclusive"
    }

    static let options: [RedemptionOption] = [
        RedemptionOption(title: "$10 Booking Credit",    description: "Off your next stay booking",              cost: 500,   icon: "creditcard.fill",         category: .discount),
        RedemptionOption(title: "$25 Booking Credit",    description: "Off any stay booking",                   cost: 1200,  icon: "creditcard.fill",         category: .discount),
        RedemptionOption(title: "Squad Invite Boost",    description: "Skip the waitlist on any squad",         cost: 300,   icon: "person.3.fill",           category: .upgrade),
        RedemptionOption(title: "Playbook Feature Slot", description: "Get your playbook featured for 24h",     cost: 800,   icon: "map.fill",                category: .upgrade),
        RedemptionOption(title: "Airport Lounge Pass",   description: "Single-use priority lounge access",      cost: 2500,  icon: "cup.and.heat.waves.fill", category: .exclusive),
        RedemptionOption(title: "Voya Premium 1 Month",  description: "Full premium features for 30 days",      cost: 4000,  icon: "star.fill",               category: .exclusive),
    ]
}
