import Foundation

struct Booking: Identifiable, Codable, Equatable {
    let id: String
    let stayID: String
    let stayTitle: String
    let stayLocation: String
    let stayImageURL: String
    let hostName: String
    let checkIn: Date
    let checkOut: Date
    let guestCount: Int
    let pricePerNight: Double
    let cleaningFee: Double
    let serviceFee: Double
    let status: BookingStatus
    let confirmationCode: String
    let bookedAt: Date

    var nights: Int {
        max(1, Calendar.current.dateComponents([.day], from: checkIn, to: checkOut).day ?? 1)
    }

    var total: Double { (pricePerNight * Double(nights)) + cleaningFee + serviceFee }

    var formattedDateRange: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return "\(f.string(from: checkIn)) – \(f.string(from: checkOut))"
    }

    var formattedCheckIn: String  { format(checkIn, style: .full) }
    var formattedCheckOut: String { format(checkOut, style: .full) }
    var nightLabel: String        { "\(nights) night\(nights == 1 ? "" : "s")" }

    private func format(_ date: Date, style: DateFormatter.Style) -> String {
        let f = DateFormatter()
        f.dateStyle = style
        f.timeStyle = .none
        return f.string(from: date)
    }
}

enum BookingStatus: String, Codable, CaseIterable {
    case upcoming  = "Upcoming"
    case active    = "Active"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var color: String {
        switch self {
        case .upcoming:  return "blue"
        case .active:    return "green"
        case .completed: return "secondary"
        case .cancelled: return "red"
        }
    }

    var icon: String {
        switch self {
        case .upcoming:  return "clock.fill"
        case .active:    return "checkmark.circle.fill"
        case .completed: return "flag.checkered"
        case .cancelled: return "xmark.circle.fill"
        }
    }
}

// MARK: - Seed bookings for demo

extension Booking {
    static var seedBookings: [Booking] {
        let cal = Calendar.current
        let now = Date.now
        return [
            Booking(
                id: "b1",
                stayID: "2",
                stayTitle: "Mountain Retreat Cabin",
                stayLocation: "Aspen, Colorado",
                stayImageURL: "https://images.unsplash.com/photo-1542718610-a1d656d1884c?w=800",
                hostName: "Jake R.",
                checkIn: cal.date(byAdding: .day, value: 14, to: now)!,
                checkOut: cal.date(byAdding: .day, value: 21, to: now)!,
                guestCount: 2,
                pricePerNight: 420,
                cleaningFee: 75,
                serviceFee: 352.8,
                status: .upcoming,
                confirmationCode: "TCX-20482",
                bookedAt: cal.date(byAdding: .day, value: -3, to: now)!
            ),
            Booking(
                id: "b2",
                stayID: "5",
                stayTitle: "Charming Parisian Apartment",
                stayLocation: "Paris, France",
                stayImageURL: "https://images.unsplash.com/photo-1551361415-69c87624334f?w=800",
                hostName: "Amélie D.",
                checkIn: cal.date(byAdding: .month, value: -2, to: now)!,
                checkOut: cal.date(byAdding: .day, value: -51, to: now)!,
                guestCount: 1,
                pricePerNight: 240,
                cleaningFee: 75,
                serviceFee: 201.6,
                status: .completed,
                confirmationCode: "TCX-18831",
                bookedAt: cal.date(byAdding: .month, value: -3, to: now)!
            ),
            Booking(
                id: "b3",
                stayID: "1",
                stayTitle: "Cozy Beachfront Cottage",
                stayLocation: "Malibu, California",
                stayImageURL: "https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800",
                hostName: "Sarah M.",
                checkIn: cal.date(byAdding: .month, value: -5, to: now)!,
                checkOut: cal.date(byAdding: .day, value: -143, to: now)!,
                guestCount: 2,
                pricePerNight: 285,
                cleaningFee: 75,
                serviceFee: 239.4,
                status: .completed,
                confirmationCode: "TCX-15290",
                bookedAt: cal.date(byAdding: .month, value: -6, to: now)!
            )
        ]
    }
}
