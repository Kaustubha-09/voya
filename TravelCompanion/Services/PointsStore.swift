import Foundation

@MainActor
final class PointsStore: ObservableObject {
    static let shared = PointsStore()

    @Published private(set) var transactions: [PointsTransaction] = []
    @Published private(set) var totalPoints: Int = 0

    private let key = "voya_points_history"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        load()
        if transactions.isEmpty {
            seed()
        }
        recalculate()
    }

    var currentTier: RewardTier {
        RewardTier.tier(for: totalPoints)
    }

    var nextTier: RewardTier? {
        RewardTier.nextTier(for: totalPoints)
    }

    var progressToNextTier: Double {
        guard let next = nextTier else { return 1.0 }
        let current = currentTier
        let range = Double(next.minPoints - current.minPoints)
        guard range > 0 else { return 1.0 }
        let earned = Double(totalPoints - current.minPoints)
        return min(max(earned / range, 0.0), 1.0)
    }

    func earn(_ type: PointsTransaction.TransactionType, points: Int, description: String) {
        let tx = PointsTransaction.earn(type, points: points, description: description)
        transactions.insert(tx, at: 0)
        recalculate()
        save()
    }

    func redeem(_ option: RedemptionOption) {
        guard canRedeem(option) else { return }
        let tx = PointsTransaction.redeem(points: option.cost, description: option.title)
        transactions.insert(tx, at: 0)
        recalculate()
        save()
    }

    func canRedeem(_ option: RedemptionOption) -> Bool {
        totalPoints >= option.cost
    }

    private func recalculate() {
        totalPoints = transactions.reduce(0) { $0 + $1.points }
    }

    private func save() {
        if let data = try? encoder.encode(transactions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? decoder.decode([PointsTransaction].self, from: data) else { return }
        transactions = loaded
    }

    private func seed() {
        let cal = Calendar.current
        let now = Date()

        func daysAgo(_ n: Int) -> Date {
            cal.date(byAdding: .day, value: -n, to: now) ?? now
        }

        transactions = [
            PointsTransaction(id: UUID().uuidString, date: daysAgo(2),  type: .review,       points: 50,  description: "Reviewed Ocean Bungalow stay",          icon: PointsTransaction.TransactionType.review.defaultIcon),
            PointsTransaction(id: UUID().uuidString, date: daysAgo(7),  type: .storyPost,    points: 30,  description: "Posted story from Kyoto",                icon: PointsTransaction.TransactionType.storyPost.defaultIcon),
            PointsTransaction(id: UUID().uuidString, date: daysAgo(14), type: .squadJoin,    points: 75,  description: "Joined Tokyo Adventure Squad",           icon: PointsTransaction.TransactionType.squadJoin.defaultIcon),
            PointsTransaction(id: UUID().uuidString, date: daysAgo(21), type: .booking,      points: 250, description: "Booked Mountain Retreat, Banff",         icon: PointsTransaction.TransactionType.booking.defaultIcon),
            PointsTransaction(id: UUID().uuidString, date: daysAgo(35), type: .referral,     points: 200, description: "Friend joined via your referral link",   icon: PointsTransaction.TransactionType.referral.defaultIcon),
            PointsTransaction(id: UUID().uuidString, date: daysAgo(50), type: .playbookFork, points: 40,  description: "Your Bali playbook was forked",          icon: PointsTransaction.TransactionType.playbookFork.defaultIcon),
            PointsTransaction(id: UUID().uuidString, date: daysAgo(65), type: .tripComplete, points: 300, description: "Completed Lisbon trip",                  icon: PointsTransaction.TransactionType.tripComplete.defaultIcon),
            PointsTransaction(id: UUID().uuidString, date: daysAgo(80), type: .bonus,        points: 500, description: "Welcome bonus — thanks for joining Voya", icon: PointsTransaction.TransactionType.bonus.defaultIcon),
        ]

        save()
    }
}
