import Foundation

@MainActor
final class TripsViewModel: ObservableObject {
    @Published var selectedTab = 0 // 0: Upcoming, 1: Past

    private let store = BookingStore.shared

    var upcomingBookings: [Booking] { store.upcoming }
    var pastBookings: [Booking]     { store.past }

    var activeBookings: [Booking] { upcomingBookings }
    var hasUpcoming: Bool { !upcomingBookings.isEmpty }
    var hasPast: Bool     { !pastBookings.isEmpty }

    func cancel(booking: Booking) {
        store.cancel(id: booking.id)
        HapticService.trigger(.soft)
    }
}
