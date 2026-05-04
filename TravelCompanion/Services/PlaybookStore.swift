import Foundation

final class PlaybookStore: ObservableObject {
    static let shared = PlaybookStore()

    @Published private(set) var playbooks: [Playbook] = []

    private let key = "saved_playbooks"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
        if playbooks.isEmpty {
            playbooks = Playbook.seedPlaybooks
            persist()
        }
    }

    func add(_ playbook: Playbook) {
        playbooks.insert(playbook, at: 0)
        persist()
    }

    func update(_ playbook: Playbook) {
        guard let i = playbooks.firstIndex(where: { $0.id == playbook.id }) else { return }
        playbooks[i] = playbook
        persist()
    }

    func delete(id: String) {
        playbooks.removeAll { $0.id == id }
        persist()
    }

    func fork(_ playbook: Playbook, authorName: String) -> Playbook {
        if let i = playbooks.firstIndex(where: { $0.id == playbook.id }) {
            playbooks[i].forkCount += 1
        }
        let initials = authorName
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0) }
            .joined()
        let forked = Playbook(
            id: UUID().uuidString,
            title: "Fork of \(playbook.title)",
            destination: playbook.destination,
            coverImageURL: playbook.coverImageURL,
            authorName: authorName,
            authorInitials: initials.isEmpty ? "ME" : initials.uppercased(),
            authorIsVerified: false,
            tripType: playbook.tripType,
            duration: playbook.duration,
            days: playbook.days,
            tips: playbook.tips,
            budgetMin: playbook.budgetMin,
            budgetMax: playbook.budgetMax,
            bestTimeToVisit: playbook.bestTimeToVisit,
            packingList: playbook.packingList,
            rating: 0,
            ratingCount: 0,
            forkCount: 0,
            viewCount: 0,
            createdAt: Date(),
            lastUpdated: Date(),
            tags: playbook.tags
        )
        playbooks.insert(forked, at: 0)
        persist()
        return forked
    }

    func playbooks(for destination: String) -> [Playbook] {
        playbooks.filter { $0.destination.localizedCaseInsensitiveContains(destination) }
    }

    func playbooks(tripType: Playbook.TripType) -> [Playbook] {
        playbooks.filter { $0.tripType == tripType }
    }

    var featured: [Playbook] {
        playbooks
            .sorted { a, b in
                let scoreA = a.rating * log(Double(a.viewCount + 1))
                let scoreB = b.rating * log(Double(b.viewCount + 1))
                return scoreA > scoreB
            }
            .prefix(3)
            .map { $0 }
    }

    private func persist() {
        if let data = try? encoder.encode(playbooks) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? decoder.decode([Playbook].self, from: data) else { return }
        playbooks = loaded
    }
}
