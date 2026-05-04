import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favoriteStays: [Stay] = []

    private let store = FavoritesStore.shared
    private var allStays: [Stay] = []

    func refresh(from stays: [Stay]) {
        allStays = stays
        reload()
    }

    func reload() {
        favoriteStays = allStays.filter { store.isFavorite(id: $0.id) }
    }

    func remove(stay: Stay) {
        store.toggle(id: stay.id)
        reload()
    }
}
