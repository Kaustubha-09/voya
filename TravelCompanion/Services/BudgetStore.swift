import Foundation

final class BudgetStore: ObservableObject {
    static let shared = BudgetStore()

    @Published private(set) var budgets: [TravelBudget] = []

    private let key = "saved_budgets"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
    }

    func add(_ budget: TravelBudget) {
        budgets.insert(budget, at: 0)
        persist()
    }

    func update(_ budget: TravelBudget) {
        if let i = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[i] = budget
            persist()
        }
    }

    func delete(id: String) {
        budgets.removeAll { $0.id == id }
        persist()
    }

    private func persist() {
        if let data = try? encoder.encode(budgets) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? decoder.decode([TravelBudget].self, from: data) else { return }
        budgets = loaded
    }
}
