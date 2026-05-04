import Foundation

struct TravelStory: Identifiable, Codable {
    var id: String
    var authorName: String
    var authorInitials: String
    var destination: String
    var stayTitle: String?
    var caption: String
    var imageURL: String
    var postedAt: Date
    var expiresAt: Date
    var likes: Int
    var isVerified: Bool
    var tripType: TripType
    var hasViewed: Bool

    var isExpired: Bool { Date.now > expiresAt }

    var timeAgo: String {
        let diff = Date.now.timeIntervalSince(postedAt)
        if diff < 3600 { return "\(Int(diff/60))m ago" }
        if diff < 86400 { return "\(Int(diff/3600))h ago" }
        return "\(Int(diff/86400))d ago"
    }

    enum TripType: String, Codable, CaseIterable {
        case solo, couple, family, group, adventure
        var label: String { rawValue.capitalized }
        var icon: String {
            switch self {
            case .solo: return "person.fill"
            case .couple: return "person.2.fill"
            case .family: return "house.fill"
            case .group: return "person.3.fill"
            case .adventure: return "figure.hiking"
            }
        }
    }

    static var seedStories: [TravelStory] {
        let now = Date.now
        return [
            TravelStory(id: UUID().uuidString, authorName: "Sofia M.", authorInitials: "SM", destination: "Santorini", stayTitle: "Cliffside Cave Suite", caption: "Woke up to this view. Zero regrets. ✨", imageURL: "https://images.unsplash.com/photo-1533105079780-92b9be4f5405?w=600", postedAt: now - 3600, expiresAt: now + 86400, likes: 248, isVerified: true, tripType: .couple, hasViewed: false),
            TravelStory(id: UUID().uuidString, authorName: "James K.", authorInitials: "JK", destination: "Kyoto", stayTitle: nil, caption: "Bamboo grove at 6am — totally empty. Go early.", imageURL: "https://images.unsplash.com/photo-1476514525405-359c9291c9d3?w=600", postedAt: now - 7200, expiresAt: now + 79200, likes: 192, isVerified: false, tripType: .solo, hasViewed: false),
            TravelStory(id: UUID().uuidString, authorName: "Priya R.", authorInitials: "PR", destination: "Amalfi Coast", stayTitle: "Hillside Retreat", caption: "Lemon groves, pasta, sea breeze. This is life.", imageURL: "https://images.unsplash.com/photo-1502602687087-c43a99a22c11?w=600", postedAt: now - 14400, expiresAt: now + 72000, likes: 317, isVerified: true, tripType: .couple, hasViewed: false),
            TravelStory(id: UUID().uuidString, authorName: "Luca T.", authorInitials: "LT", destination: "Banff", stayTitle: "Mountain Lodge", caption: "Hiking to Lake Louise was worth every step.", imageURL: "https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=600", postedAt: now - 21600, expiresAt: now + 64800, likes: 154, isVerified: false, tripType: .adventure, hasViewed: true),
            TravelStory(id: UUID().uuidString, authorName: "Amara N.", authorInitials: "AN", destination: "Marrakech", stayTitle: "Riad in the Medina", caption: "The souk is sensory overload in the best way.", imageURL: "https://images.unsplash.com/photo-1499363536502-87642509e31f?w=600", postedAt: now - 43200, expiresAt: now + 43200, likes: 89, isVerified: false, tripType: .solo, hasViewed: false),
        ]
    }
}
