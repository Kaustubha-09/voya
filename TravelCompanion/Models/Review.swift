import Foundation

struct Review: Identifiable, Codable {
    let id: String
    let authorName: String
    let authorInitials: String
    let rating: Double
    let date: String
    let comment: String
}

extension MockData {
    static let reviews: [String: [Review]] = [
        "1": [
            Review(id: "r1a", authorName: "James T.", authorInitials: "JT", rating: 5, date: "March 2026", comment: "Woke up to the most stunning sunrise over the ocean. The cottage is exactly as pictured — cozy, clean, and incredibly peaceful."),
            Review(id: "r1b", authorName: "Mei L.", authorInitials: "ML", rating: 5, date: "February 2026", comment: "Sarah was a wonderful host. The private deck is perfect for morning coffee. Will absolutely be back."),
            Review(id: "r1c", authorName: "Raj P.", authorInitials: "RP", rating: 4, date: "January 2026", comment: "Beautiful spot. Parking was a little tricky to find but once we settled in, everything was amazing.")
        ],
        "2": [
            Review(id: "r2a", authorName: "Anna K.", authorInitials: "AK", rating: 5, date: "March 2026", comment: "The hot tub under the stars was a dream. Ski access was a 2-minute walk. Jake left great trail maps and local tips."),
            Review(id: "r2b", authorName: "Chris M.", authorInitials: "CM", rating: 5, date: "February 2026", comment: "Best ski trip accommodation we've ever had. Fireplace kept us warm after long days on the slopes."),
            Review(id: "r2c", authorName: "Dana W.", authorInitials: "DW", rating: 4, date: "January 2026", comment: "Stunning views and very well-equipped kitchen. Slightly tricky GPS directions — text the host if lost.")
        ],
        "3": [
            Review(id: "r3a", authorName: "Lucia F.", authorInitials: "LF", rating: 5, date: "April 2026", comment: "The loft is even more gorgeous in person. Location couldn't be better — walked everywhere. Highly recommend."),
            Review(id: "r3b", authorName: "Tom H.", authorInitials: "TH", rating: 4, date: "March 2026", comment: "Great space for a work trip. Fast Wi-Fi, comfortable workspace, very stylish. City noise at night but that's Manhattan."),
            Review(id: "r3c", authorName: "Sana B.", authorInitials: "SB", rating: 5, date: "February 2026", comment: "Perfect NYC pied-à-terre. Loved the exposed brick and the rooftop is a hidden gem.")
        ],
        "4": [
            Review(id: "r4a", authorName: "Oliver G.", authorInitials: "OG", rating: 5, date: "March 2026", comment: "Absolute paradise. The infinity pool overlooking the jungle is surreal. Carlos arranged everything perfectly."),
            Review(id: "r4b", authorName: "Nadia R.", authorInitials: "NR", rating: 5, date: "February 2026", comment: "We celebrated our anniversary here — best decision ever. Chef service was a luxurious touch."),
            Review(id: "r4c", authorName: "Erik J.", authorInitials: "EJ", rating: 5, date: "January 2026", comment: "Tulum at its finest. Private, lush, and the beach access is world class. Book it.")
        ],
        "5": [
            Review(id: "r5a", authorName: "Claire D.", authorInitials: "CD", rating: 5, date: "April 2026", comment: "Amélie's apartment is a gem. Original parquet floors, beautiful art, and the Eiffel Tower view from the balcony is real."),
            Review(id: "r5b", authorName: "Max S.", authorInitials: "MS", rating: 4, date: "March 2026", comment: "Great location in the 7th. The apartment is compact but cleverly designed. Perfect Parisian base."),
            Review(id: "r5c", authorName: "Priya N.", authorInitials: "PN", rating: 5, date: "February 2026", comment: "Woke up, made coffee, stood on the balcony and stared at the Eiffel Tower. Life complete.")
        ],
        "6": [
            Review(id: "r6a", authorName: "Lily C.", authorInitials: "LC", rating: 5, date: "March 2026", comment: "The most unique Seattle experience. Fell asleep to the sound of water lapping the hull. Tom left us kayaks — incredible."),
            Review(id: "r6b", authorName: "Ben A.", authorInitials: "BA", rating: 4, date: "February 2026", comment: "Super cool houseboat. A bit compact but the rooftop patio makes up for it with stunning views of the skyline."),
            Review(id: "r6c", authorName: "Hana M.", authorInitials: "HM", rating: 5, date: "January 2026", comment: "Living on the water is a completely different vibe. Absolutely loved it. Already planning a return trip.")
        ]
    ]
}
