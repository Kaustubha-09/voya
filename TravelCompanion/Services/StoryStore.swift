import Foundation

final class StoryStore: ObservableObject {
    static let shared = StoryStore()

    @Published private(set) var stories: [TravelStory] = []

    private let key = "saved_stories"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
        if stories.isEmpty {
            stories = TravelStory.seedStories
            persist()
        }
    }

    var activeStories: [TravelStory] {
        stories
            .filter { !$0.isExpired }
            .sorted { $0.postedAt > $1.postedAt }
    }

    func add(_ story: TravelStory) {
        stories.insert(story, at: 0)
        persist()
    }

    func markViewed(id: String) {
        guard let i = stories.firstIndex(where: { $0.id == id }) else { return }
        stories[i].hasViewed = true
        persist()
    }

    func toggleLike(id: String) {
        guard let i = stories.firstIndex(where: { $0.id == id }) else { return }
        stories[i].likes += stories[i].likes > 0 ? -1 : 1
        persist()
    }

    func stories(for destination: String) -> [TravelStory] {
        stories.filter { $0.destination.localizedCaseInsensitiveContains(destination) }
    }

    private func persist() {
        if let data = try? encoder.encode(stories) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? decoder.decode([TravelStory].self, from: data) else { return }
        stories = loaded.filter { !$0.isExpired }
    }
}
