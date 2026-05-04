import Foundation

enum StayCategory: String, CaseIterable, Identifiable {
    case all      = "All"
    case beach    = "Beach"
    case mountain = "Mountain"
    case city     = "City"
    case cabin    = "Cabin"
    case unique   = "Unique"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .all:      return "square.grid.2x2"
        case .beach:    return "beach.umbrella"
        case .mountain: return "mountain.2"
        case .city:     return "building.2"
        case .cabin:    return "house"
        case .unique:   return "sparkles"
        }
    }

    // Keyword-based heuristic match — no API field needed
    func matches(_ stay: Stay) -> Bool {
        switch self {
        case .all: return true
        case .beach:
            let corpus = "\(stay.title) \(stay.location) \(stay.description)".lowercased()
            return corpus.containsAny("beach", "ocean", "coastal", "sea", "malibu", "tulum", "caribbean")
        case .mountain:
            let corpus = "\(stay.title) \(stay.location) \(stay.description)".lowercased()
            return corpus.containsAny("mountain", "alpine", "ski", "aspen", "cabin", "retreat", "hike")
        case .city:
            let corpus = "\(stay.title) \(stay.location) \(stay.description)".lowercased()
            return corpus.containsAny("city", "loft", "apartment", "urban", "downtown", "soho", "new york", "paris", "seattle")
        case .cabin:
            let corpus = "\(stay.title) \(stay.description)".lowercased()
            return corpus.containsAny("cabin", "cottage", "retreat", "rustic", "houseboat", "lakeside")
        case .unique:
            let corpus = "\(stay.title) \(stay.description)".lowercased()
            return corpus.containsAny("villa", "houseboat", "treehouse", "floating", "unique", "infinity pool", "private pool")
        }
    }
}

private extension String {
    func containsAny(_ keywords: String...) -> Bool {
        keywords.contains { self.contains($0) }
    }
}
