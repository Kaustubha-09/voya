import Foundation

// MARK: - Stay Service Protocol

protocol StayServiceProtocol {
    func fetchStays() async throws -> [Stay]
}

// MARK: - Production Implementation

final class StayService: StayServiceProtocol {
    // Using JSONPlaceholder-style mock endpoint.
    // In production, replace with your actual API base URL.
    private static let baseURL = "https://my.api.mockaroo.com/stays"

    private let network: NetworkServiceProtocol
    private let cache: CacheServiceProtocol

    init(network: NetworkServiceProtocol = NetworkService.shared,
         cache: CacheServiceProtocol = CacheService.shared) {
        self.network = network
        self.cache = cache
    }

    func fetchStays() async throws -> [Stay] {
        let cacheKey = "stays_list"

        // Return cached data if available (avoids redundant network calls on back navigation)
        if let cached: [Stay] = cache.get(forKey: cacheKey) {
            return cached
        }

        // Fall back to mock data — swap with real URL when API is available
        let stays = MockData.stays
        cache.set(stays, forKey: cacheKey)
        return stays
    }
}

// MARK: - Mock Implementation (for testing & previews)

final class MockStayService: StayServiceProtocol {
    var shouldFail = false
    var delay: Duration = .milliseconds(800)

    func fetchStays() async throws -> [Stay] {
        try await Task.sleep(for: delay)
        if shouldFail {
            throw NetworkError.serverError(500)
        }
        return MockData.stays
    }
}
