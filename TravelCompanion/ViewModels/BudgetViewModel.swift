import Foundation

@MainActor
final class BudgetViewModel: ObservableObject {
    @Published var destination = ""
    @Published var startDate = Date.now
    @Published var endDate = Calendar.current.date(byAdding: .day, value: 7, to: .now)!
    @Published var travelers = 2
    @Published var hasFriendStay = false
    @Published var categories: [BudgetCategory] = []
    @Published var showCreateSheet = false
    @Published var editingBudget: TravelBudget? = nil

    var nights: Int {
        max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1)
    }

    var subtotal: Double {
        categories.reduce(0) { $0 + $1.selectedAmount }
    }

    var friendStaySavings: Double {
        hasFriendStay ? (categories.first(where: { $0.type == .stay })?.selectedAmount ?? 0) * 0.9 : 0
    }

    var total: Double {
        max(0, subtotal - friendStaySavings)
    }

    var perPerson: Double {
        travelers > 0 ? total / Double(travelers) : total
    }

    var canCreate: Bool {
        !destination.trimmingCharacters(in: .whitespaces).isEmpty && endDate > startDate
    }

    func initCategories() {
        categories = BudgetCategory.defaults(for: destination, nights: nights, travelers: travelers)
    }

    func updateTier(for categoryID: String, tier: BudgetCategory.Tier) {
        if let i = categories.firstIndex(where: { $0.id == categoryID }) {
            categories[i].tier = tier
        }
    }

    func updateAmount(for categoryID: String, amount: Double, tier: BudgetCategory.Tier) {
        guard let i = categories.firstIndex(where: { $0.id == categoryID }) else { return }
        switch tier {
        case .budget:      categories[i].budgetAmount = amount
        case .comfortable: categories[i].comfortableAmount = amount
        case .splurge:     categories[i].splurgeAmount = amount
        }
    }

    func saveBudget() {
        if let existing = editingBudget {
            let updated = TravelBudget(
                id: existing.id,
                destination: destination,
                startDate: startDate,
                endDate: endDate,
                travelers: travelers,
                hasFriendStay: hasFriendStay,
                categories: categories,
                createdAt: existing.createdAt
            )
            BudgetStore.shared.update(updated)
        } else {
            let budget = TravelBudget(
                id: UUID().uuidString,
                destination: destination,
                startDate: startDate,
                endDate: endDate,
                travelers: travelers,
                hasFriendStay: hasFriendStay,
                categories: categories,
                createdAt: .now
            )
            BudgetStore.shared.add(budget)
        }
        reset()
    }

    func loadForEditing(_ budget: TravelBudget) {
        editingBudget = budget
        destination = budget.destination
        startDate = budget.startDate
        endDate = budget.endDate
        travelers = budget.travelers
        hasFriendStay = budget.hasFriendStay
        categories = budget.categories
    }

    func reset() {
        destination = ""
        startDate = .now
        endDate = Calendar.current.date(byAdding: .day, value: 7, to: .now)!
        travelers = 2
        hasFriendStay = false
        categories = []
        editingBudget = nil
        showCreateSheet = false
    }
}
