import Foundation

struct Stay: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: String
    let location: String
    let description: String
    let host: String
    let pricePerNight: Double
    let rating: Double
    let reviewCount: Int
    let imageURL: String
    let additionalImages: [String]
    let amenities: [Amenity]
    let coordinates: Coordinates

    // Identity is determined solely by id
    static func == (lhs: Stay, rhs: Stay) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Amenity: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
}

struct Coordinates: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

struct StaysResponse: Codable {
    let stays: [Stay]
}
