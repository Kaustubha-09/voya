import Foundation

// Persists confirmed bookings to UserDefaults.
// Acts as a lightweight local database for the Trips tab.
final class BookingStore: ObservableObject {
    static let shared = BookingStore()

    @Published private(set) var bookings: [Booking] = []

    private let key     = "saved_bookings"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        load()
        if bookings.isEmpty { seed() }
    }

    func add(_ booking: Booking) {
        bookings.insert(booking, at: 0)
        persist()
    }

    func cancel(id: String) {
        if let i = bookings.firstIndex(where: { $0.id == id }) {
            var updated = bookings[i]
            bookings[i] = Booking(
                id: updated.id, stayID: updated.stayID, stayTitle: updated.stayTitle,
                stayLocation: updated.stayLocation, stayImageURL: updated.stayImageURL,
                hostName: updated.hostName, checkIn: updated.checkIn, checkOut: updated.checkOut,
                guestCount: updated.guestCount, pricePerNight: updated.pricePerNight,
                cleaningFee: updated.cleaningFee, serviceFee: updated.serviceFee,
                status: .cancelled, confirmationCode: updated.confirmationCode, bookedAt: updated.bookedAt
            )
            _ = updated
            persist()
        }
    }

    var upcoming: [Booking] {
        bookings.filter { $0.status == .upcoming || $0.status == .active }
            .sorted { $0.checkIn < $1.checkIn }
    }

    var past: [Booking] {
        bookings.filter { $0.status == .completed || $0.status == .cancelled }
            .sorted { $0.checkIn > $1.checkIn }
    }

    private func persist() {
        if let data = try? encoder.encode(bookings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? decoder.decode([Booking].self, from: data) else { return }
        bookings = loaded
    }

    private func seed() {
        bookings = Booking.seedBookings
        persist()
    }
}
