import Foundation

struct FilterOptions: Equatable {
    var maxPrice: Double = 600
    var minRating: Double = 0

    var isActive: Bool {
        maxPrice < 600 || minRating > 0
    }

    func matches(_ stay: Stay) -> Bool {
        stay.pricePerNight <= maxPrice && stay.rating >= minRating
    }
}
