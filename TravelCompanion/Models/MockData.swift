import Foundation

enum MockData {
    static let stays: [Stay] = [
        Stay(
            id: "1",
            title: "Cozy Beachfront Cottage",
            location: "Malibu, California",
            description: "Wake up to the sound of waves in this charming cottage steps from the Pacific. Features a private deck, outdoor shower, and stunning ocean views. Perfect for couples or solo travelers seeking a serene escape.",
            host: "Sarah M.",
            pricePerNight: 285,
            rating: 4.92,
            reviewCount: 134,
            imageURL: "https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800",
            additionalImages: [
                "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800",
                "https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800"
            ],
            amenities: [
                Amenity(id: "a1", name: "Ocean View", icon: "water.waves"),
                Amenity(id: "a2", name: "Wi-Fi", icon: "wifi"),
                Amenity(id: "a3", name: "Kitchen", icon: "fork.knife"),
                Amenity(id: "a4", name: "Parking", icon: "car.fill"),
                Amenity(id: "a5", name: "Air Conditioning", icon: "snowflake")
            ],
            coordinates: Coordinates(latitude: 34.0259, longitude: -118.7798)
        ),
        Stay(
            id: "2",
            title: "Mountain Retreat Cabin",
            location: "Aspen, Colorado",
            description: "A rustic yet luxurious cabin nestled among aspen trees with panoramic mountain views. Equipped with a hot tub, fireplace, and ski-in/ski-out access. An unforgettable alpine getaway.",
            host: "Jake R.",
            pricePerNight: 420,
            rating: 4.88,
            reviewCount: 89,
            imageURL: "https://images.unsplash.com/photo-1542718610-a1d656d1884c?w=800",
            additionalImages: [
                "https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?w=800",
                "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
            ],
            amenities: [
                Amenity(id: "b1", name: "Hot Tub", icon: "thermometer.sun.fill"),
                Amenity(id: "b2", name: "Fireplace", icon: "flame.fill"),
                Amenity(id: "b3", name: "Wi-Fi", icon: "wifi"),
                Amenity(id: "b4", name: "Ski Access", icon: "figure.skiing.downhill"),
                Amenity(id: "b5", name: "Heating", icon: "heat.waves")
            ],
            coordinates: Coordinates(latitude: 39.1911, longitude: -106.8175)
        ),
        Stay(
            id: "3",
            title: "Modern Loft in SoHo",
            location: "New York City, New York",
            description: "Stylish industrial loft in the heart of SoHo, surrounded by world-class galleries, restaurants, and boutiques. High ceilings, exposed brick, and floor-to-ceiling windows make this a truly unique urban experience.",
            host: "Priya K.",
            pricePerNight: 195,
            rating: 4.79,
            reviewCount: 212,
            imageURL: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800",
            additionalImages: [
                "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800",
                "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800"
            ],
            amenities: [
                Amenity(id: "c1", name: "Wi-Fi", icon: "wifi"),
                Amenity(id: "c2", name: "Gym", icon: "dumbbell.fill"),
                Amenity(id: "c3", name: "Doorman", icon: "person.badge.key.fill"),
                Amenity(id: "c4", name: "Rooftop", icon: "building.2.fill"),
                Amenity(id: "c5", name: "Kitchen", icon: "fork.knife")
            ],
            coordinates: Coordinates(latitude: 40.7233, longitude: -74.0030)
        ),
        Stay(
            id: "4",
            title: "Tropical Villa with Private Pool",
            location: "Tulum, Mexico",
            description: "Immerse yourself in the lush jungle with this stunning villa boasting a private infinity pool, open-air living spaces, and direct access to pristine Caribbean beaches. A true paradise escape.",
            host: "Carlos V.",
            pricePerNight: 550,
            rating: 4.97,
            reviewCount: 67,
            imageURL: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800",
            additionalImages: [
                "https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800",
                "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800"
            ],
            amenities: [
                Amenity(id: "d1", name: "Private Pool", icon: "drop.fill"),
                Amenity(id: "d2", name: "Beach Access", icon: "beach.umbrella"),
                Amenity(id: "d3", name: "Chef Service", icon: "fork.knife"),
                Amenity(id: "d4", name: "Wi-Fi", icon: "wifi"),
                Amenity(id: "d5", name: "Air Conditioning", icon: "snowflake")
            ],
            coordinates: Coordinates(latitude: 20.2114, longitude: -87.4654)
        ),
        Stay(
            id: "5",
            title: "Charming Parisian Apartment",
            location: "Paris, France",
            description: "Live like a local in this beautifully curated Haussmann-era apartment in the 7th arrondissement. Steps from the Eiffel Tower, with original parquet floors, high ceilings, and a sun-drenched balcony.",
            host: "Amélie D.",
            pricePerNight: 240,
            rating: 4.85,
            reviewCount: 178,
            imageURL: "https://images.unsplash.com/photo-1551361415-69c87624334f?w=800",
            additionalImages: [
                "https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800",
                "https://images.unsplash.com/photo-1564078516393-cf04bd966897?w=800"
            ],
            amenities: [
                Amenity(id: "e1", name: "Balcony", icon: "door.sliding.left.hand.open"),
                Amenity(id: "e2", name: "Wi-Fi", icon: "wifi"),
                Amenity(id: "e3", name: "Washer", icon: "washer.fill"),
                Amenity(id: "e4", name: "Kitchen", icon: "fork.knife"),
                Amenity(id: "e5", name: "Elevator", icon: "arrow.up.arrow.down.square")
            ],
            coordinates: Coordinates(latitude: 48.8566, longitude: 2.2920)
        ),
        Stay(
            id: "6",
            title: "Lakeside Houseboat",
            location: "Seattle, Washington",
            description: "Spend your nights rocking gently on this iconic Lake Union houseboat. Two decks, a rooftop patio with sweeping city and mountain views, and the most unique Seattle experience you can have.",
            host: "Tom B.",
            pricePerNight: 175,
            rating: 4.71,
            reviewCount: 95,
            imageURL: "https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800",
            additionalImages: [
                "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800",
                "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=800"
            ],
            amenities: [
                Amenity(id: "f1", name: "Lake View", icon: "binoculars.fill"),
                Amenity(id: "f2", name: "Kayak", icon: "figure.water.fitness"),
                Amenity(id: "f3", name: "Wi-Fi", icon: "wifi"),
                Amenity(id: "f4", name: "Deck", icon: "sun.horizon.fill"),
                Amenity(id: "f5", name: "Heating", icon: "heat.waves")
            ],
            coordinates: Coordinates(latitude: 47.6434, longitude: -122.3319)
        )
    ]
}
