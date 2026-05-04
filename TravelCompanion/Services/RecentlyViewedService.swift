import Foundation

// LRU store: most-recent ID at index 0, max 10 entries, persisted via UserDefaults.
final class RecentlyViewedService {
    static let shared = RecentlyViewedService()

    private let key = "recently_viewed_ids"
    private let limit = 10

    var viewedIDs: [String] {
        get { UserDefaults.standard.stringArray(forKey: key) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    func record(id: String) {
        var ids = viewedIDs.filter { $0 != id } // evict duplicates
        ids.insert(id, at: 0)                   // push to front
        viewedIDs = Array(ids.prefix(limit))
    }

    // Returns stays ordered most-recently-viewed first
    func recentStays(from stays: [Stay]) -> [Stay] {
        let index = Dictionary(uniqueKeysWithValues: stays.map { ($0.id, $0) })
        return viewedIDs.compactMap { index[$0] }
    }
}
