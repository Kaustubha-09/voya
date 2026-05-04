import Foundation

struct CityBudgetPreset {
    let dailyFood: Double
    let dailyTransport: Double
    let dailyActivities: Double
    let tier: Tier
    let currency: String
    let tip: String

    enum Tier: String {
        case budget       = "Budget"
        case moderate     = "Moderate"
        case expensive    = "Expensive"
        case luxurious    = "Luxurious"

        var color: String {
            switch self {
            case .budget:    return "green"
            case .moderate:  return "blue"
            case .expensive: return "orange"
            case .luxurious: return "purple"
            }
        }

        var icon: String {
            switch self {
            case .budget:    return "dollarsign.circle"
            case .moderate:  return "dollarsign.circle.fill"
            case .expensive: return "creditcard.fill"
            case .luxurious: return "star.fill"
            }
        }
    }
}

struct CostOfLivingService {
    static let shared = CostOfLivingService()

    private let presets: [String: CityBudgetPreset] = [
        // Budget destinations
        "bali":        CityBudgetPreset(dailyFood: 15,  dailyTransport: 5,  dailyActivities: 20,  tier: .budget,    currency: "IDR", tip: "Cheap scooter rentals, amazing street food"),
        "thailand":    CityBudgetPreset(dailyFood: 12,  dailyTransport: 4,  dailyActivities: 18,  tier: .budget,    currency: "THB", tip: "One of the most affordable destinations in Asia"),
        "bangkok":     CityBudgetPreset(dailyFood: 12,  dailyTransport: 4,  dailyActivities: 18,  tier: .budget,    currency: "THB", tip: "BTS Skytrain is cheap and covers most areas"),
        "vietnam":     CityBudgetPreset(dailyFood: 10,  dailyTransport: 3,  dailyActivities: 15,  tier: .budget,    currency: "VND", tip: "Street food is excellent and costs under $2"),
        "morocco":     CityBudgetPreset(dailyFood: 18,  dailyTransport: 6,  dailyActivities: 22,  tier: .budget,    currency: "MAD", tip: "Negotiate prices in the souks"),
        "india":       CityBudgetPreset(dailyFood: 10,  dailyTransport: 4,  dailyActivities: 12,  tier: .budget,    currency: "INR", tip: "Incredibly affordable; internal flights are cheap"),
        "mexico":      CityBudgetPreset(dailyFood: 20,  dailyTransport: 6,  dailyActivities: 25,  tier: .budget,    currency: "MXN", tip: "Tacos and local buses keep costs very low"),
        "cancun":      CityBudgetPreset(dailyFood: 25,  dailyTransport: 8,  dailyActivities: 30,  tier: .moderate,  currency: "MXN", tip: "Hotel zone is pricier; explore downtown for deals"),
        "colombia":    CityBudgetPreset(dailyFood: 15,  dailyTransport: 5,  dailyActivities: 18,  tier: .budget,    currency: "COP", tip: "Medellín and Cartagena are very affordable"),

        // Moderate destinations
        "lisbon":      CityBudgetPreset(dailyFood: 30,  dailyTransport: 10, dailyActivities: 25,  tier: .moderate,  currency: "EUR", tip: "One of Europe's most affordable capitals"),
        "porto":       CityBudgetPreset(dailyFood: 28,  dailyTransport: 8,  dailyActivities: 22,  tier: .moderate,  currency: "EUR", tip: "Wine and seafood are excellent value"),
        "prague":      CityBudgetPreset(dailyFood: 25,  dailyTransport: 8,  dailyActivities: 20,  tier: .moderate,  currency: "CZK", tip: "Beer is cheaper than water — seriously"),
        "budapest":    CityBudgetPreset(dailyFood: 22,  dailyTransport: 7,  dailyActivities: 18,  tier: .moderate,  currency: "HUF", tip: "Thermal baths are a must and very affordable"),
        "barcelona":   CityBudgetPreset(dailyFood: 40,  dailyTransport: 12, dailyActivities: 35,  tier: .moderate,  currency: "EUR", tip: "Eat at local menús del día for €10-12"),
        "rome":        CityBudgetPreset(dailyFood: 42,  dailyTransport: 10, dailyActivities: 38,  tier: .moderate,  currency: "EUR", tip: "Many museums are free on the first Sunday"),
        "athens":      CityBudgetPreset(dailyFood: 32,  dailyTransport: 9,  dailyActivities: 28,  tier: .moderate,  currency: "EUR", tip: "Souvlaki and gyros are cheap and delicious"),
        "istanbul":    CityBudgetPreset(dailyFood: 20,  dailyTransport: 6,  dailyActivities: 22,  tier: .moderate,  currency: "TRY", tip: "Street food and trams make it very affordable"),
        "berlin":      CityBudgetPreset(dailyFood: 35,  dailyTransport: 12, dailyActivities: 28,  tier: .moderate,  currency: "EUR", tip: "Great public transport day pass available"),
        "seoul":       CityBudgetPreset(dailyFood: 25,  dailyTransport: 8,  dailyActivities: 30,  tier: .moderate,  currency: "KRW", tip: "T-money card for cheap metro and buses"),

        // Expensive destinations
        "paris":       CityBudgetPreset(dailyFood: 55,  dailyTransport: 15, dailyActivities: 45,  tier: .expensive, currency: "EUR", tip: "Picnic by the Seine to save on food"),
        "london":      CityBudgetPreset(dailyFood: 60,  dailyTransport: 20, dailyActivities: 50,  tier: .expensive, currency: "GBP", tip: "Many world-class museums are free"),
        "amsterdam":   CityBudgetPreset(dailyFood: 50,  dailyTransport: 14, dailyActivities: 40,  tier: .expensive, currency: "EUR", tip: "Rent a bike — it's the cheapest transport"),
        "tokyo":       CityBudgetPreset(dailyFood: 40,  dailyTransport: 18, dailyActivities: 45,  tier: .expensive, currency: "JPY", tip: "Convenience store food is surprisingly good"),
        "new york":    CityBudgetPreset(dailyFood: 65,  dailyTransport: 16, dailyActivities: 55,  tier: .expensive, currency: "USD", tip: "Many parks and sights are free"),
        "sydney":      CityBudgetPreset(dailyFood: 55,  dailyTransport: 15, dailyActivities: 48,  tier: .expensive, currency: "AUD", tip: "Beaches are free; eat at food courts"),
        "dubai":       CityBudgetPreset(dailyFood: 50,  dailyTransport: 20, dailyActivities: 60,  tier: .expensive, currency: "AED", tip: "Metro is cheap; malls are free to browse"),
        "singapore":   CityBudgetPreset(dailyFood: 30,  dailyTransport: 10, dailyActivities: 50,  tier: .expensive, currency: "SGD", tip: "Hawker centres offer incredible cheap meals"),
        "los angeles": CityBudgetPreset(dailyFood: 55,  dailyTransport: 25, dailyActivities: 50,  tier: .expensive, currency: "USD", tip: "You'll need a car — factor in rental cost"),
        "san francisco": CityBudgetPreset(dailyFood: 60, dailyTransport: 20, dailyActivities: 48, tier: .expensive, currency: "USD", tip: "Muni pass saves on public transport"),
        "miami":       CityBudgetPreset(dailyFood: 50,  dailyTransport: 18, dailyActivities: 45,  tier: .expensive, currency: "USD", tip: "South Beach restaurants have high markups"),

        // Luxurious
        "maldives":    CityBudgetPreset(dailyFood: 120, dailyTransport: 80, dailyActivities: 100, tier: .luxurious, currency: "USD", tip: "All-inclusive resorts often work out cheaper"),
        "santorini":   CityBudgetPreset(dailyFood: 70,  dailyTransport: 25, dailyActivities: 60,  tier: .luxurious, currency: "EUR", tip: "Oia restaurants have premium sunset pricing"),
        "mykonos":     CityBudgetPreset(dailyFood: 75,  dailyTransport: 28, dailyActivities: 65,  tier: .luxurious, currency: "EUR", tip: "Book nightlife tables in advance"),
        "amalfi":      CityBudgetPreset(dailyFood: 65,  dailyTransport: 30, dailyActivities: 55,  tier: .luxurious, currency: "EUR", tip: "Ferries between towns save on driving"),
        "zurich":      CityBudgetPreset(dailyFood: 80,  dailyTransport: 25, dailyActivities: 60,  tier: .luxurious, currency: "CHF", tip: "Swiss travel passes cover most transport"),
        "monaco":      CityBudgetPreset(dailyFood: 100, dailyTransport: 15, dailyActivities: 80,  tier: .luxurious, currency: "EUR", tip: "The casino is free to enter and explore"),
        "aspen":       CityBudgetPreset(dailyFood: 70,  dailyTransport: 20, dailyActivities: 120, tier: .luxurious, currency: "USD", tip: "Lift tickets are the biggest expense"),
        "banff":       CityBudgetPreset(dailyFood: 55,  dailyTransport: 15, dailyActivities: 80,  tier: .expensive, currency: "CAD", tip: "Parks Canada pass covers most entry fees"),
    ]

    func preset(for destination: String) -> CityBudgetPreset? {
        let key = destination.lowercased().trimmingCharacters(in: .whitespaces)
        if let exact = presets[key] { return exact }
        return presets.first { key.contains($0.key) || $0.key.contains(key) }?.value
    }

    func suggestions(for query: String) -> [String] {
        guard query.count >= 2 else { return [] }
        let q = query.lowercased()
        return presets.keys
            .filter { $0.hasPrefix(q) || $0.contains(q) }
            .sorted()
            .prefix(4)
            .map { $0.capitalized }
    }
}
