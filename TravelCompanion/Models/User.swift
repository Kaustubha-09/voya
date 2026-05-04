import Foundation

struct User: Codable, Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var bio: String
    var profileImageURL: String?
    var dateOfBirth: Date?
    var isEmailVerified: Bool
    var isIDVerified: Bool
    var isHost: Bool
    var memberSince: Date

    var fullName: String { "\(firstName) \(lastName)" }
    var initials: String  { "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased() }

    var memberSinceYear: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        return f.string(from: memberSince)
    }

    static let placeholder = User(
        id: UUID().uuidString,
        firstName: "Kaustubha",
        lastName: "Eluri",
        email: "eluri.k@northeastern.edu",
        phone: "+1 (617) 000-0000",
        bio: "Travel enthusiast, coffee lover. Visited 14 countries.",
        profileImageURL: nil,
        dateOfBirth: Calendar.current.date(from: DateComponents(year: 1999, month: 6, day: 15)),
        isEmailVerified: true,
        isIDVerified: true,
        isHost: false,
        memberSince: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!
    )
}
