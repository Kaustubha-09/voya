import Foundation
import Combine
import CoreLocation

// MARK: - View State

enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case failure(String)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

// MARK: - Home ViewModel

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published state
    @Published private(set) var state: ViewState<[Stay]> = .idle
    @Published var filter = FilterOptions()
    @Published var selectedCategory: StayCategory = .all
    @Published var searchInput: String = ""
    @Published private(set) var debouncedSearch: String = ""

    // MARK: - Private services
    private let stayService: StayServiceProtocol
    private let ranker       = SearchRankingService()
    private let priceService = PriceAnalysisService()
    private let recentStore  = RecentlyViewedService.shared

    private var cancellables = Set<AnyCancellable>()
    private var priceCache: [String: PriceAnalysis] = [:]

    // MARK: - Init

    init(stayService: StayServiceProtocol = StayService()) {
        self.stayService = stayService
        setupSearchDebounce()
    }

    // MARK: - Derived: filtered + ranked stays (computed, not stored)

    var filteredStays: [Stay] {
        guard case .success(let stays) = state else { return [] }

        // 1. Category filter
        let byCat = selectedCategory == .all ? stays : stays.filter { selectedCategory.matches($0) }

        // 2. Price / rating filter
        let byFilter = byCat.filter { filter.matches($0) }

        // 3. Ranked text search (only when there is a query)
        let q = debouncedSearch.trimmingCharacters(in: .whitespaces)
        return q.isEmpty ? byFilter : ranker.rank(stays: byFilter, query: q)
    }

    var allStays: [Stay] {
        guard case .success(let stays) = state else { return [] }
        return stays
    }

    // Wilson-score approximation: rating × log(reviews + 1)
    // Balances quality with popularity without requiring a real Bayesian prior.
    var trendingStays: [Stay] {
        allStays
            .sorted { a, b in
                (a.rating * log(Double(a.reviewCount) + 1)) >
                (b.rating * log(Double(b.reviewCount) + 1))
            }
            .prefix(6)
            .map { $0 }
    }

    var recentlyViewedStays: [Stay] {
        recentStore.recentStays(from: allStays)
    }

    var nearbyStays: [Stay] {
        LocationService.shared.nearbyStays(from: allStays, withinKm: 2000)
    }

    var isLocationAuthorized: Bool {
        LocationService.shared.isAuthorized
    }

    var currentCity: String {
        LocationService.shared.currentCity
    }

    var errorMessage: String? {
        if case .failure(let msg) = state { return msg }
        return nil
    }

    var isFiltering: Bool {
        filter.isActive || !debouncedSearch.isEmpty || selectedCategory != .all
    }

    func priceAnalysis(for stay: Stay) -> PriceAnalysis? {
        priceCache[stay.id]
    }

    // MARK: - Intents

    func loadStays() async {
        if case .success = state { return }
        state = .loading
        do {
            let stays = try await stayService.fetchStays()
            state = .success(stays)
            priceCache = priceService.buildCache(stays: stays)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }

    func refresh() async {
        state = .loading
        do {
            let stays = try await stayService.fetchStays()
            state = .success(stays)
            priceCache = priceService.buildCache(stays: stays)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }

    func resetFilters() {
        filter = FilterOptions()
        selectedCategory = .all
        searchInput = ""
        // debouncedSearch will clear on next debounce tick
    }

    // MARK: - Debounce wiring

    private func setupSearchDebounce() {
        $searchInput
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.debouncedSearch = text
            }
            .store(in: &cancellables)
    }
}
