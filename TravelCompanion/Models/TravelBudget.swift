import Foundation

struct TravelBudget: Identifiable, Codable {
    var id: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var travelers: Int
    var hasFriendStay: Bool
    var categories: [BudgetCategory]
    var createdAt: Date

    var nights: Int { max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1) }
    var subtotal: Double { categories.reduce(0) { $0 + $1.selectedAmount } }
    var friendStaySavings: Double { hasFriendStay ? (categories.first(where: { $0.type == .stay })?.selectedAmount ?? 0) * 0.9 : 0 }
    var total: Double { max(0, subtotal - friendStaySavings) }
    var perPerson: Double { travelers > 0 ? total / Double(travelers) : total }
}

struct BudgetCategory: Identifiable, Codable {
    var id: String
    var type: CategoryType
    var budgetAmount: Double
    var comfortableAmount: Double
    var splurgeAmount: Double
    var tier: Tier

    var selectedAmount: Double {
        switch tier {
        case .budget: return budgetAmount
        case .comfortable: return comfortableAmount
        case .splurge: return splurgeAmount
        }
    }

    enum CategoryType: String, Codable, CaseIterable, Identifiable {
        case flights, stay, food, transport, activities, visa, insurance, shopping, emergency
        var id: String { rawValue }
        var label: String {
            switch self {
            case .flights: return "Flights"
            case .stay: return "Accommodation"
            case .food: return "Food & Dining"
            case .transport: return "Local Transport"
            case .activities: return "Activities"
            case .visa: return "Visa & Fees"
            case .insurance: return "Travel Insurance"
            case .shopping: return "Shopping"
            case .emergency: return "Emergency Buffer"
            }
        }
        var icon: String {
            switch self {
            case .flights: return "airplane"
            case .stay: return "house.fill"
            case .food: return "fork.knife"
            case .transport: return "car.fill"
            case .activities: return "ticket.fill"
            case .visa: return "doc.text.fill"
            case .insurance: return "shield.fill"
            case .shopping: return "bag.fill"
            case .emergency: return "cross.circle.fill"
            }
        }
    }

    enum Tier: String, Codable, CaseIterable, Identifiable {
        case budget, comfortable, splurge
        var id: String { rawValue }
        var label: String {
            switch self {
            case .budget: return "Budget"
            case .comfortable: return "Comfortable"
            case .splurge: return "Splurge"
            }
        }
    }

    static func defaults(for destination: String, nights: Int, travelers: Int) -> [BudgetCategory] {
        let n = Double(max(1, nights))
        let t = Double(max(1, travelers))
        return [
            BudgetCategory(id: UUID().uuidString, type: .flights, budgetAmount: 400*t, comfortableAmount: 700*t, splurgeAmount: 1400*t, tier: .comfortable),
            BudgetCategory(id: UUID().uuidString, type: .stay, budgetAmount: 60*n, comfortableAmount: 130*n, splurgeAmount: 300*n, tier: .comfortable),
            BudgetCategory(id: UUID().uuidString, type: .food, budgetAmount: 20*n*t, comfortableAmount: 50*n*t, splurgeAmount: 120*n*t, tier: .comfortable),
            BudgetCategory(id: UUID().uuidString, type: .transport, budgetAmount: 8*n*t, comfortableAmount: 20*n*t, splurgeAmount: 50*n*t, tier: .comfortable),
            BudgetCategory(id: UUID().uuidString, type: .activities, budgetAmount: 15*n*t, comfortableAmount: 40*n*t, splurgeAmount: 100*n*t, tier: .comfortable),
            BudgetCategory(id: UUID().uuidString, type: .visa, budgetAmount: 25*t, comfortableAmount: 50*t, splurgeAmount: 80*t, tier: .budget),
            BudgetCategory(id: UUID().uuidString, type: .insurance, budgetAmount: 30*t, comfortableAmount: 60*t, splurgeAmount: 120*t, tier: .budget),
            BudgetCategory(id: UUID().uuidString, type: .shopping, budgetAmount: 50*t, comfortableAmount: 150*t, splurgeAmount: 400*t, tier: .comfortable),
            BudgetCategory(id: UUID().uuidString, type: .emergency, budgetAmount: 100, comfortableAmount: 200, splurgeAmount: 400, tier: .budget),
        ]
    }
}
