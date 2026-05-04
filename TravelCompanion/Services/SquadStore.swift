import Foundation

final class SquadStore: ObservableObject {
    static let shared = SquadStore()

    @Published private(set) var squads: [TravelSquad] = []

    private let key = "saved_squads"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
        if squads.isEmpty {
            squads = TravelSquad.seedSquads
            persist()
        }
    }

    var mySquads: [TravelSquad] { squads.filter { $0.hasJoined } }
    var discoverSquads: [TravelSquad] { squads.filter { !$0.hasJoined && $0.status == .forming } }
    var flashSquads: [TravelSquad] { squads.filter { $0.isFlash && !$0.hasJoined } }

    func join(id: String) {
        guard let i = squads.firstIndex(where: { $0.id == id }) else { return }
        let youMember = SquadMember(
            id: "member_you_\(id)",
            name: "You",
            initials: "YO",
            isVerified: false,
            isLocal: false,
            isLead: false,
            tripCount: 0,
            rating: 0.0,
            bio: "",
            homeCity: "",
            travelStyle: .mixed
        )
        let sysMsg = SquadMessage(
            id: UUID().uuidString,
            senderName: "System",
            senderInitials: "",
            text: "You joined the squad.",
            sentAt: Date.now,
            isSystem: true,
            isCurrentUser: false
        )
        squads[i].hasJoined = true
        squads[i].members.append(youMember)
        squads[i].messages.append(sysMsg)
        persist()
    }

    func leave(id: String) {
        guard let i = squads.firstIndex(where: { $0.id == id }) else { return }
        let sysMsg = SquadMessage(
            id: UUID().uuidString,
            senderName: "System",
            senderInitials: "",
            text: "You left the squad.",
            sentAt: Date.now,
            isSystem: true,
            isCurrentUser: false
        )
        squads[i].hasJoined = false
        squads[i].members.removeAll { $0.id == "member_you_\(id)" }
        squads[i].messages.append(sysMsg)
        persist()
    }

    func sendMessage(squadID: String, text: String) {
        guard let i = squads.firstIndex(where: { $0.id == squadID }) else { return }
        let msg = SquadMessage(
            id: UUID().uuidString,
            senderName: "You",
            senderInitials: "YO",
            text: text,
            sentAt: Date.now,
            isSystem: false,
            isCurrentUser: true
        )
        squads[i].messages.append(msg)
        persist()
    }

    func create(_ squad: TravelSquad) {
        squads.insert(squad, at: 0)
        persist()
    }

    private func persist() {
        if let data = try? encoder.encode(squads) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? decoder.decode([TravelSquad].self, from: data) else { return }
        squads = loaded
    }
}
