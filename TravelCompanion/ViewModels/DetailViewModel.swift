import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    @Published private(set) var stay: Stay
    @Published private(set) var isFavorite: Bool = false

    init(stay: Stay) {
        self.stay = stay
        self.isFavorite = FavoritesStore.shared.isFavorite(id: stay.id)
    }

    func recordView() {
        RecentlyViewedService.shared.record(id: stay.id)
    }

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return (formatter.string(from: NSNumber(value: stay.pricePerNight)) ?? "$\(Int(stay.pricePerNight))") + " / night"
    }

    var formattedRating: String {
        String(format: "%.2f", stay.rating)
    }

    func toggleFavorite() {
        FavoritesStore.shared.toggle(id: stay.id)
        isFavorite = FavoritesStore.shared.isFavorite(id: stay.id)
    }
}

// MARK: - Lightweight favorites store (persisted via UserDefaults)

final class FavoritesStore {
    static let shared = FavoritesStore()
    private let key = "favorite_stay_ids"

    private var favoriteIDs: Set<String> {
        get { Set(UserDefaults.standard.stringArray(forKey: key) ?? []) }
        set { UserDefaults.standard.set(Array(newValue), forKey: key) }
    }

    func isFavorite(id: String) -> Bool { favoriteIDs.contains(id) }

    func toggle(id: String) {
        var ids = favoriteIDs
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        favoriteIDs = ids
    }
}
