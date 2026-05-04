import XCTest
@testable import TravelCompanion

@MainActor
final class HomeViewModelTests: XCTestCase {

    // MARK: - Load stays (success path)

    func testLoadStaysSuccess() async {
        let service = MockStayService()
        service.delay = .milliseconds(0)
        let vm = HomeViewModel(stayService: service)

        await vm.loadStays()

        if case .success(let stays) = vm.state {
            XCTAssertEqual(stays.count, MockData.stays.count)
        } else {
            XCTFail("Expected success state, got \(vm.state)")
        }
    }

    // MARK: - Load stays (failure path)

    func testLoadStaysFailure() async {
        let service = MockStayService()
        service.shouldFail = true
        service.delay = .milliseconds(0)
        let vm = HomeViewModel(stayService: service)

        await vm.loadStays()

        if case .failure = vm.state {
            XCTAssertNotNil(vm.errorMessage)
        } else {
            XCTFail("Expected failure state, got \(vm.state)")
        }
    }

    // MARK: - Does not re-fetch if already loaded

    func testLoadStaysDoesNotRefetchWhenAlreadyLoaded() async {
        var callCount = 0
        let service = CountingMockService { callCount += 1 }
        let vm = HomeViewModel(stayService: service)

        await vm.loadStays()
        await vm.loadStays() // second call should be a no-op

        XCTAssertEqual(callCount, 1)
    }

    // MARK: - Search filter

    func testSearchFilterByLocation() async {
        let service = MockStayService()
        service.delay = .milliseconds(0)
        let vm = HomeViewModel(stayService: service)
        await vm.loadStays()

        vm.searchText = "Paris"
        XCTAssertTrue(vm.filteredStays.allSatisfy {
            $0.location.lowercased().contains("paris") ||
            $0.title.lowercased().contains("paris")
        })
    }

    func testEmptySearchReturnsAllStays() async {
        let service = MockStayService()
        service.delay = .milliseconds(0)
        let vm = HomeViewModel(stayService: service)
        await vm.loadStays()

        vm.searchText = ""
        XCTAssertEqual(vm.filteredStays.count, MockData.stays.count)
    }

    // MARK: - Loading state is set before result

    func testLoadingStateSetDuringFetch() async {
        let service = MockStayService()
        service.delay = .milliseconds(200)
        let vm = HomeViewModel(stayService: service)

        let task = Task { await vm.loadStays() }
        // Give it a tick to enter the loading state
        try? await Task.sleep(for: .milliseconds(50))
        XCTAssertTrue(vm.state.isLoading)
        await task.value
    }
}

// MARK: - Helpers

private final class CountingMockService: StayServiceProtocol {
    private let onFetch: () -> Void
    init(_ onFetch: @escaping () -> Void) { self.onFetch = onFetch }

    func fetchStays() async throws -> [Stay] {
        onFetch()
        return MockData.stays
    }
}
