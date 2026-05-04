import Foundation

@MainActor
final class BookingViewModel: ObservableObject {
    @Published var checkIn: Date = Calendar.current.date(byAdding: .day, value: 7, to: .now)!
    @Published var checkOut: Date = Calendar.current.date(byAdding: .day, value: 14, to: .now)!
    @Published var guestCount: Int = 2
    @Published var isConfirmed = false

    let stay: Stay

    init(stay: Stay) { self.stay = stay }

    var nights: Int {
        max(1, Calendar.current.dateComponents([.day], from: checkIn, to: checkOut).day ?? 1)
    }

    var subtotal: Double { Double(nights) * stay.pricePerNight }
    var cleaningFee: Double { 75 }
    var serviceFee: Double { subtotal * 0.12 }
    var total: Double { subtotal + cleaningFee + serviceFee }

    var formattedTotal: String { format(total) }
    var formattedSubtotal: String { format(subtotal) }
    var formattedCleaning: String { format(cleaningFee) }
    var formattedService: String { format(serviceFee) }
    var nightLabel: String { "\(nights) night\(nights == 1 ? "" : "s")" }

    var checkInRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: .now)!
        return min...max
    }

    var checkOutRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 1, to: checkIn)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: .now)!
        return min...max
    }

    func confirm() {
        let booking = Booking(
            id: UUID().uuidString,
            stayID: stay.id,
            stayTitle: stay.title,
            stayLocation: stay.location,
            stayImageURL: stay.imageURL,
            hostName: stay.host,
            checkIn: checkIn,
            checkOut: checkOut,
            guestCount: guestCount,
            pricePerNight: stay.pricePerNight,
            cleaningFee: cleaningFee,
            serviceFee: serviceFee,
            status: .upcoming,
            confirmationCode: "TCX-\(Int.random(in: 10000...99999))",
            bookedAt: .now
        )
        BookingStore.shared.add(booking)
        isConfirmed = true
    }

    private func format(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: value)) ?? "$\(Int(value))"
    }
}
