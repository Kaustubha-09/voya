import Foundation
import Combine

@MainActor
final class StoriesViewModel: ObservableObject {
    @Published var selectedStory: TravelStory? = nil
    @Published var showAddStory = false
    @Published var showStoryDetail = false

    private let store = StoryStore.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        store.$stories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var activeStories: [TravelStory] {
        store.activeStories
    }

    func openStory(_ story: TravelStory) {
        selectedStory = story
        store.markViewed(id: story.id)
        HapticService.trigger(.selection)
        showStoryDetail = true
    }

    func nextStory() {
        guard let current = selectedStory,
              let idx = activeStories.firstIndex(where: { $0.id == current.id }),
              idx + 1 < activeStories.count else { return }
        let next = activeStories[idx + 1]
        selectedStory = next
        store.markViewed(id: next.id)
    }

    func prevStory() {
        guard let current = selectedStory,
              let idx = activeStories.firstIndex(where: { $0.id == current.id }),
              idx > 0 else { return }
        selectedStory = activeStories[idx - 1]
    }
}
