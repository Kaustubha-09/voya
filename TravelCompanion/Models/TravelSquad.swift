import SwiftUI

struct TravelSquad: Identifiable, Codable {
    var id: String
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var description: String
    var travelStyle: TravelStyle
    var maxMembers: Int
    var isWomenOnly: Bool
    var isOpenJoin: Bool
    var members: [SquadMember]
    var messages: [SquadMessage]
    var status: SquadStatus
    var hasJoined: Bool

    var nights: Int { max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1) }
    var spotsLeft: Int { max(0, maxMembers - members.count) }
    var isFull: Bool { spotsLeft == 0 }
    var isFlash: Bool { startDate.timeIntervalSinceNow < 259200 && startDate > Date.now }
    var dateRange: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return "\(f.string(from: startDate)) – \(f.string(from: endDate))"
    }

    enum TravelStyle: String, Codable, CaseIterable, Identifiable {
        case adventure, relaxed, cultural, nightlife, foodie, mixed
        var id: String { rawValue }
        var label: String { rawValue.capitalized }
        var icon: String {
            switch self {
            case .adventure: return "figure.hiking"
            case .relaxed: return "leaf.fill"
            case .cultural: return "building.columns.fill"
            case .nightlife: return "moon.stars.fill"
            case .foodie: return "fork.knife"
            case .mixed: return "sparkles"
            }
        }
        var color: Color {
            switch self {
            case .adventure: return .green
            case .relaxed: return .cyan
            case .cultural: return .purple
            case .nightlife: return .indigo
            case .foodie: return .orange
            case .mixed: return Color(red: 0.91, green: 0.19, blue: 0.31)
            }
        }
    }

    enum SquadStatus: String, Codable {
        case forming, active, completed
        var label: String { rawValue.capitalized }
        var color: Color {
            switch self {
            case .forming: return .blue
            case .active: return .green
            case .completed: return .secondary
            }
        }
    }
}

struct SquadMember: Identifiable, Codable {
    var id: String
    var name: String
    var initials: String
    var isVerified: Bool
    var isLocal: Bool
    var isLead: Bool
    var tripCount: Int
    var rating: Double
    var bio: String
    var homeCity: String
    var travelStyle: TravelSquad.TravelStyle
}

struct SquadMessage: Identifiable, Codable {
    var id: String
    var senderName: String
    var senderInitials: String
    var text: String
    var sentAt: Date
    var isSystem: Bool
    var isCurrentUser: Bool

    var timeString: String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: sentAt)
    }
}

extension TravelSquad {
    static var seedSquads: [TravelSquad] {
        let now = Date.now
        let cal = Calendar.current

        func days(_ n: Int) -> Date { cal.date(byAdding: .day, value: n, to: now)! }

        let baliMembers: [SquadMember] = [
            SquadMember(id: "bm1", name: "Priya Sharma", initials: "PS", isVerified: true, isLocal: false, isLead: true, tripCount: 14, rating: 4.9, bio: "Adventure photographer chasing sunrises across Southeast Asia.", homeCity: "Mumbai", travelStyle: .adventure),
            SquadMember(id: "bm2", name: "Jake Torres", initials: "JT", isVerified: true, isLocal: false, isLead: false, tripCount: 8, rating: 4.7, bio: "Surfer and scuba diver. Always hunting the perfect wave.", homeCity: "Sydney", travelStyle: .adventure),
            SquadMember(id: "bm3", name: "Mei Lin", initials: "ML", isVerified: false, isLocal: false, isLead: false, tripCount: 3, rating: 4.5, bio: "First big solo trip — excited to meet fellow travellers!", homeCity: "Singapore", travelStyle: .mixed),
            SquadMember(id: "bm4", name: "Carlos Vega", initials: "CV", isVerified: true, isLocal: true, isLead: false, tripCount: 22, rating: 5.0, bio: "Born in Ubud. I know every hidden waterfall in Bali.", homeCity: "Ubud", travelStyle: .adventure),
            SquadMember(id: "bm5", name: "Hana Yoshida", initials: "HY", isVerified: true, isLocal: false, isLead: false, tripCount: 11, rating: 4.8, bio: "Yoga teacher and sunrise hiker. Loves jungle treks.", homeCity: "Osaka", travelStyle: .relaxed),
            SquadMember(id: "bm6", name: "Ravi Nair", initials: "RN", isVerified: false, isLocal: false, isLead: false, tripCount: 5, rating: 4.6, bio: "Motorbike enthusiast exploring Southeast Asia on two wheels.", homeCity: "Bangalore", travelStyle: .adventure)
        ]

        let baliMessages: [SquadMessage] = [
            SquadMessage(id: "bmsg1", senderName: "System", senderInitials: "", text: "Priya Sharma created this squad.", sentAt: days(-5), isSystem: true, isCurrentUser: false),
            SquadMessage(id: "bmsg2", senderName: "Priya Sharma", senderInitials: "PS", text: "Hey everyone! Super stoked for this trip 🤙 Who's done the Tegalalang rice terraces before?", sentAt: days(-4), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "bmsg3", senderName: "Carlos Vega", senderInitials: "CV", text: "I live near there — I'll take you all on a hidden route the tourists never find.", sentAt: days(-4), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "bmsg4", senderName: "System", senderInitials: "", text: "Jake Torres joined the squad.", sentAt: days(-3), isSystem: true, isCurrentUser: false),
            SquadMessage(id: "bmsg5", senderName: "Jake Torres", senderInitials: "JT", text: "Just in! Are we doing any surf sessions at Canggu?", sentAt: days(-3), isSystem: false, isCurrentUser: false)
        ]

        let bali = TravelSquad(
            id: "squad_bali",
            name: "Bali Backpackers",
            destination: "Bali, Indonesia",
            startDate: days(21),
            endDate: days(28),
            description: "10-day adventure loop through Ubud, Canggu, and Nusa Penida. Waterfalls, temple hikes, surf, and zero resort pools. We move fast and travel light.",
            travelStyle: .adventure,
            maxMembers: 8,
            isWomenOnly: false,
            isOpenJoin: true,
            members: baliMembers,
            messages: baliMessages,
            status: .forming,
            hasJoined: false
        )

        let parisMembers: [SquadMember] = [
            SquadMember(id: "pm1", name: "Sophie Durand", initials: "SD", isVerified: true, isLocal: true, isLead: true, tripCount: 18, rating: 4.9, bio: "Parisian art curator and obsessive café-hopper. I know every patisserie worth visiting.", homeCity: "Paris", travelStyle: .cultural),
            SquadMember(id: "pm2", name: "Ananya Patel", initials: "AP", isVerified: true, isLocal: false, isLead: false, tripCount: 9, rating: 4.8, bio: "Food journalist. Has eaten at 3 Michelin-starred restaurants and still prefers street food.", homeCity: "London", travelStyle: .foodie),
            SquadMember(id: "pm3", name: "Leo Fischer", initials: "LF", isVerified: true, isLocal: false, isLead: false, tripCount: 7, rating: 4.6, bio: "Architecture student with a sketchbook always in hand.", homeCity: "Berlin", travelStyle: .cultural)
        ]

        let parisMessages: [SquadMessage] = [
            SquadMessage(id: "pmsg1", senderName: "System", senderInitials: "", text: "Sophie Durand created this squad.", sentAt: days(-7), isSystem: true, isCurrentUser: false),
            SquadMessage(id: "pmsg2", senderName: "Sophie Durand", senderInitials: "SD", text: "Welcome! I've planned a Louvre morning, Marais afternoon, and dinner at a spot that's been in the family for 40 years. Prepare your stomachs.", sentAt: days(-6), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "pmsg3", senderName: "Ananya Patel", senderInitials: "AP", text: "Already researching natural wine bars in the 11th. This is going to be incredible.", sentAt: days(-5), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "pmsg4", senderName: "Leo Fischer", senderInitials: "LF", text: "Can we do a morning walk along the Canal Saint-Martin? Perfect sketching light.", sentAt: days(-4), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "pmsg5", senderName: "Sophie Durand", senderInitials: "SD", text: "Absolutely on the agenda. One spot left — I vet everyone personally, so reach out!", sentAt: days(-3), isSystem: false, isCurrentUser: false)
        ]

        let paris = TravelSquad(
            id: "squad_paris",
            name: "Paris Art & Food Week",
            destination: "Paris, France",
            startDate: days(35),
            endDate: days(42),
            description: "A curated week in Paris for people who care deeply about art, architecture, and eating extraordinarily well. Invite only — Sophie reviews every applicant. No tourist traps, no queue-waiting, all insider access.",
            travelStyle: .cultural,
            maxMembers: 4,
            isWomenOnly: false,
            isOpenJoin: false,
            members: parisMembers,
            messages: parisMessages,
            status: .forming,
            hasJoined: false
        )

        let tokyoMembers: [SquadMember] = [
            SquadMember(id: "tm1", name: "Yuki Tanaka", initials: "YT", isVerified: true, isLocal: true, isLead: true, tripCount: 20, rating: 5.0, bio: "Tokyo native. I'll show you the Japan guidebooks don't cover.", homeCity: "Tokyo", travelStyle: .cultural),
            SquadMember(id: "tm2", name: "Nadia El-Amin", initials: "NE", isVerified: true, isLocal: false, isLead: false, tripCount: 13, rating: 4.9, bio: "Women's travel advocate. Has solo-travelled 47 countries.", homeCity: "Dubai", travelStyle: .mixed),
            SquadMember(id: "tm3", name: "Fatima Malik", initials: "FM", isVerified: true, isLocal: false, isLead: false, tripCount: 6, rating: 4.7, bio: "On a sabbatical year. Obsessed with Japanese ceramics and tea ceremony.", homeCity: "Toronto", travelStyle: .cultural),
            SquadMember(id: "tm4", name: "Zara Ahmed", initials: "ZA", isVerified: false, isLocal: false, isLead: false, tripCount: 2, rating: 4.4, bio: "First time in Asia — ready for everything!", homeCity: "Manchester", travelStyle: .relaxed),
            SquadMember(id: "tm5", name: "Ishaan Rao", initials: "IR", isVerified: true, isLocal: false, isLead: false, tripCount: 10, rating: 4.8, bio: "Travel writer specialising in slow travel and neighbourhood deep-dives.", homeCity: "Hyderabad", travelStyle: .cultural)
        ]

        let tokyoMessages: [SquadMessage] = [
            SquadMessage(id: "tmsg1", senderName: "System", senderInitials: "", text: "Yuki Tanaka created this squad.", sentAt: days(-10), isSystem: true, isCurrentUser: false),
            SquadMessage(id: "tmsg2", senderName: "Yuki Tanaka", senderInitials: "YT", text: "Konnichiwa everyone! Planning Yanaka, Shimokitazawa, Harajuku, and a day trip to Nikko. Cherry blossom season is the best time to come.", sentAt: days(-9), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "tmsg3", senderName: "Nadia El-Amin", senderInitials: "NE", text: "This squad is exactly what I've been looking for. Safe, connected, women who love exploring.", sentAt: days(-8), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "tmsg4", senderName: "Fatima Malik", senderInitials: "FM", text: "Yuki — can we fit in a tea ceremony workshop? I've been dreaming of it for years.", sentAt: days(-7), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "tmsg5", senderName: "Yuki Tanaka", senderInitials: "YT", text: "Already booked one in Asakusa! Spots filling up fast — one more welcome.", sentAt: days(-6), isSystem: false, isCurrentUser: false)
        ]

        let tokyo = TravelSquad(
            id: "squad_tokyo",
            name: "Women Solo → Tokyo",
            destination: "Tokyo, Japan",
            startDate: days(28),
            endDate: days(38),
            description: "A women-only squad for solo travellers heading to Tokyo. Yuki (a local) leads the way through neighbourhoods most tourists never see. Safe, fun, deeply cultural. One spot remaining.",
            travelStyle: .cultural,
            maxMembers: 6,
            isWomenOnly: true,
            isOpenJoin: true,
            members: tokyoMembers,
            messages: tokyoMessages,
            status: .forming,
            hasJoined: false
        )

        let santoriniMembers: [SquadMember] = [
            SquadMember(id: "sm1", name: "Elena Papadaki", initials: "EP", isVerified: true, isLocal: true, isLead: true, tripCount: 25, rating: 5.0, bio: "Santorini local and travel host. Expert in caldera sunsets and the best tavernas.", homeCity: "Oia", travelStyle: .relaxed),
            SquadMember(id: "sm2", name: "Marco & Clara Rossi", initials: "MC", isVerified: true, isLocal: false, isLead: false, tripCount: 16, rating: 4.8, bio: "Couple from Milan. Slow travel, good wine, great food. Always up for rooftop sunsets.", homeCity: "Milan", travelStyle: .relaxed),
            SquadMember(id: "sm3", name: "Tom Nguyen", initials: "TN", isVerified: true, isLocal: false, isLead: false, tripCount: 9, rating: 4.7, bio: "Photographer and foodie. Here for the light, the octopus, and the Vinsanto.", homeCity: "Ho Chi Minh City", travelStyle: .foodie)
        ]

        let santoriniMessages: [SquadMessage] = [
            SquadMessage(id: "smsg1", senderName: "System", senderInitials: "", text: "Elena Papadaki created this squad.", sentAt: days(-14), isSystem: true, isCurrentUser: false),
            SquadMessage(id: "smsg2", senderName: "Elena Papadaki", senderInitials: "EP", text: "Yassas! I'm planning private sunset sailing, a wine tasting at Santo Wines, and mornings at the quieter black-sand beaches. Couples and solo travellers both welcome.", sentAt: days(-13), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "smsg3", senderName: "Marco & Clara Rossi", senderInitials: "MC", text: "We've been dreaming of Santorini for years. Count us in — when do we do the sailing?", sentAt: days(-12), isSystem: false, isCurrentUser: false),
            SquadMessage(id: "smsg4", senderName: "Elena Papadaki", senderInitials: "EP", text: "Day 3 evening — best light on the caldera. Two spots left, tell your friends!", sentAt: days(-11), isSystem: false, isCurrentUser: false)
        ]

        let santorini = TravelSquad(
            id: "squad_santorini",
            name: "Santorini Sunset Squad",
            destination: "Santorini, Greece",
            startDate: days(42),
            endDate: days(49),
            description: "Unhurried Santorini — private sailing on the caldera, volcanic beach mornings, Assyrtiko wine, and the most famous sunsets on earth. Led by Elena, an Oia local. Couples and solo travellers both very welcome.",
            travelStyle: .relaxed,
            maxMembers: 5,
            isWomenOnly: false,
            isOpenJoin: true,
            members: santoriniMembers,
            messages: santoriniMessages,
            status: .forming,
            hasJoined: false
        )

        let lisbonMembers: [SquadMember] = [
            SquadMember(id: "lm1", name: "Diego Alves", initials: "DA", isVerified: true, isLocal: true, isLead: true, tripCount: 31, rating: 4.9, bio: "Lisbon local and weekend adventure organiser. I know every rooftop, hidden bar, and dawn tram route.", homeCity: "Lisbon", travelStyle: .adventure),
            SquadMember(id: "lm2", name: "Sara Johansson", initials: "SJ", isVerified: true, isLocal: false, isLead: false, tripCount: 19, rating: 4.8, bio: "Flash travel addict. I've done 12 spontaneous weekend trips this year alone.", homeCity: "Stockholm", travelStyle: .adventure)
        ]

        let lisbonMessages: [SquadMessage] = [
            SquadMessage(id: "lmsg1", senderName: "System", senderInitials: "", text: "Diego Alves created this squad.", sentAt: cal.date(byAdding: .hour, value: -6, to: now)!, isSystem: true, isCurrentUser: false),
            SquadMessage(id: "lmsg2", senderName: "Diego Alves", senderInitials: "DA", text: "Last-minute weekend squad! Fado night Friday, Sintra day trip Saturday, LX Factory Sunday. Flights from most EU cities are under €80 right now.", sentAt: cal.date(byAdding: .hour, value: -5, to: now)!, isSystem: false, isCurrentUser: false),
            SquadMessage(id: "lmsg3", senderName: "Sara Johansson", senderInitials: "SJ", text: "Booked. See you at Humberto Delgado Airport Friday morning!", sentAt: cal.date(byAdding: .hour, value: -4, to: now)!, isSystem: false, isCurrentUser: false),
            SquadMessage(id: "lmsg4", senderName: "Diego Alves", senderInitials: "DA", text: "One spot left — who's spontaneous enough? 48 hours in the best city in Europe.", sentAt: cal.date(byAdding: .hour, value: -2, to: now)!, isSystem: false, isCurrentUser: false)
        ]

        let lisbon = TravelSquad(
            id: "squad_lisbon",
            name: "Flash: Lisbon This Weekend",
            destination: "Lisbon, Portugal",
            startDate: days(2),
            endDate: days(4),
            description: "Spontaneous Lisbon weekend — Fado, Sintra, Alfama, and the best pastéis de nata in the city. Diego knows every shortcut and secret bar. One spot left. Move fast.",
            travelStyle: .adventure,
            maxMembers: 3,
            isWomenOnly: false,
            isOpenJoin: true,
            members: lisbonMembers,
            messages: lisbonMessages,
            status: .forming,
            hasJoined: false
        )

        return [bali, paris, tokyo, santorini, lisbon]
    }
}
