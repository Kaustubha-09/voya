import Foundation
import SwiftUI

struct SeasonalRecommendation: Identifiable {
    let id = UUID()
    let destination: String
    let country: String
    let imageURL: String
    let months: [Int]
    let season: Season
    let weatherDescription: String
    let tempRange: String
    let priceTier: PriceTier
    let crowdLevel: CrowdLevel
    let highlights: [String]
    let festivals: [Festival]
    let bestFor: [TripStyle]
    let travelTip: String

    enum Season: String, CaseIterable {
        case spring = "Spring"
        case summer = "Summer"
        case autumn = "Autumn"
        case winter = "Winter"

        var icon: String {
            switch self {
            case .spring: return "leaf.fill"
            case .summer: return "sun.max.fill"
            case .autumn: return "wind"
            case .winter: return "snowflake"
            }
        }
        var color: Color {
            switch self {
            case .spring: return .green
            case .summer: return .orange
            case .autumn: return Color(red: 0.8, green: 0.4, blue: 0.1)
            case .winter: return .cyan
            }
        }
    }

    enum PriceTier: String {
        case budget = "Budget"
        case moderate = "Moderate"
        case expensive = "Expensive"
        case luxurious = "Luxurious"

        var color: Color {
            switch self {
            case .budget:    return .green
            case .moderate:  return .blue
            case .expensive: return .orange
            case .luxurious: return .purple
            }
        }
        var icon: String {
            switch self {
            case .budget: return "dollarsign.circle"
            case .moderate: return "dollarsign.circle.fill"
            case .expensive: return "creditcard.fill"
            case .luxurious: return "star.fill"
            }
        }
    }

    enum CrowdLevel: String {
        case quiet = "Quiet"
        case moderate = "Moderate"
        case busy = "Busy"
        case veryBusy = "Very Busy"

        var color: Color {
            switch self {
            case .quiet: return .green
            case .moderate: return .yellow
            case .busy: return .orange
            case .veryBusy: return .red
            }
        }
        var icon: String {
            switch self {
            case .quiet: return "person"
            case .moderate: return "person.2"
            case .busy: return "person.3.fill"
            case .veryBusy: return "person.3.sequence.fill"
            }
        }
    }

    enum TripStyle: String, CaseIterable {
        case adventure = "Adventure"
        case beach = "Beach"
        case culture = "Culture"
        case food = "Food"
        case wellness = "Wellness"
        case family = "Family"
        case romance = "Romance"
        case solo = "Solo"
        case skiing = "Skiing"
        case wildlife = "Wildlife"
    }

    struct Festival: Identifiable {
        let id = UUID()
        let name: String
        let month: Int
        let description: String
    }
}

struct SeasonalDataStore {
    static let all: [SeasonalRecommendation] = [

        SeasonalRecommendation(
            destination: "Chiang Mai",
            country: "Thailand",
            imageURL: "https://images.unsplash.com/photo-1528181304800-259b08848526?w=800",
            months: [1, 2, 12],
            season: .winter,
            weatherDescription: "Sunny, cool and dry — the best of Thailand",
            tempRange: "18–30°C",
            priceTier: .budget,
            crowdLevel: .busy,
            highlights: [
                "Trek through hill-tribe villages in Doi Inthanon",
                "Explore 300+ ancient temples including Wat Chedi Luang",
                "Night Bazaar street food and crafts market",
                "Elephant sanctuary ethical experience"
            ],
            festivals: [
                .init(name: "Yi Peng Lantern Festival", month: 1, description: "Thousands of paper lanterns float into the night sky in a breathtaking ceremony."),
                .init(name: "Chiang Mai Flower Festival", month: 2, description: "A vibrant parade of floral floats through the old city streets.")
            ],
            bestFor: [.adventure, .culture, .food, .solo],
            travelTip: "Book accommodation early for the Lantern Festival as the city fills up weeks in advance."
        ),

        SeasonalRecommendation(
            destination: "Maldives",
            country: "Maldives",
            imageURL: "https://images.unsplash.com/photo-1506929562872-bb421503ef21?w=800",
            months: [1, 2, 3],
            season: .winter,
            weatherDescription: "Crystalline waters, blazing sun, no rain",
            tempRange: "27–31°C",
            priceTier: .luxurious,
            crowdLevel: .moderate,
            highlights: [
                "Stay in an overwater bungalow above turquoise lagoon",
                "World-class snorkelling and diving on house reef",
                "Sunset dolphin cruise",
                "Spa treatments in open-air pavilions"
            ],
            festivals: [
                .init(name: "Maldives Independence Day", month: 1, description: "Cultural performances and boat parades across the atolls.")
            ],
            bestFor: [.beach, .romance, .wellness, .family],
            travelTip: "Travel on Thursday or Sunday for cheaper seaplane transfers between Male and the resort atolls."
        ),

        SeasonalRecommendation(
            destination: "Queenstown",
            country: "New Zealand",
            imageURL: "https://images.unsplash.com/photo-1507699622108-4be3abd695ad?w=800",
            months: [1, 2, 12],
            season: .summer,
            weatherDescription: "Warm and long days — perfect for outdoor adventures",
            tempRange: "14–25°C",
            priceTier: .expensive,
            crowdLevel: .busy,
            highlights: [
                "Bungee jump from the original Kawarau Bridge",
                "Milford Sound day cruise through fjords",
                "Skyline gondola and mountain biking",
                "Wine tasting in Central Otago vineyards"
            ],
            festivals: [
                .init(name: "Queenstown Winter Festival", month: 1, description: "Although a summer trip, the shoulder weeks offer uncrowded trails and summer festivals.")
            ],
            bestFor: [.adventure, .solo, .romance],
            travelTip: "Rent a campervan for freedom on the South Island — freedom camping sites are plentiful and stunning."
        ),

        SeasonalRecommendation(
            destination: "Mirissa",
            country: "Sri Lanka",
            imageURL: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800",
            months: [1, 2, 3],
            season: .winter,
            weatherDescription: "South coast dry season — calm seas and brilliant sunshine",
            tempRange: "26–32°C",
            priceTier: .budget,
            crowdLevel: .moderate,
            highlights: [
                "Blue whale watching — largest animals on Earth",
                "Surfing at Coconut Tree Hill beach",
                "Day trip to colonial Galle Fort",
                "Sea turtle conservation visit at Rekawa"
            ],
            festivals: [
                .init(name: "Duruthu Perahera", month: 1, description: "Buddhist pageant with decorated elephants, drummers and dancers in Colombo.")
            ],
            bestFor: [.beach, .wildlife, .adventure, .solo],
            travelTip: "The train from Colombo to Mirissa along the coast is one of the most scenic rail journeys in Asia — book upper-class tickets in advance."
        ),

        SeasonalRecommendation(
            destination: "Havana",
            country: "Cuba",
            imageURL: "https://images.unsplash.com/photo-1500582374653-c5c1e15e3bb0?w=800",
            months: [1, 2, 3],
            season: .winter,
            weatherDescription: "Dry season — low humidity, bright skies, cool evenings",
            tempRange: "20–27°C",
            priceTier: .budget,
            crowdLevel: .moderate,
            highlights: [
                "Classic car tour through the colourful Havana streets",
                "Live salsa dancing in Callejón de Hamel",
                "Day trip to tobacco farms in Viñales Valley",
                "Mojitos at Hemingway's favourite El Floridita bar"
            ],
            festivals: [
                .init(name: "Havana International Jazz Festival", month: 1, description: "World-class jazz musicians perform across venues throughout the city."),
                .init(name: "Carnaval de Santiago", month: 2, description: "The largest street carnival in Cuba with Afro-Cuban music and costumes.")
            ],
            bestFor: [.culture, .food, .romance, .solo],
            travelTip: "Bring enough cash — US cards do not work in Cuba. Exchange EUR or GBP at Cadecas for the best rate."
        ),

        SeasonalRecommendation(
            destination: "Marrakech",
            country: "Morocco",
            imageURL: "https://images.unsplash.com/photo-1489493585363-d69421e0edd3?w=800",
            months: [1, 2, 3, 10, 11],
            season: .winter,
            weatherDescription: "Mild, sunny days — ideal for exploring the medina",
            tempRange: "12–20°C",
            priceTier: .moderate,
            crowdLevel: .busy,
            highlights: [
                "Lose yourself in the labyrinthine Djemaa el-Fna souks",
                "Day trip to the Sahara dunes at Merzouga",
                "Hammam spa and argan oil massage in a riad",
                "Majorelle Garden botanical masterpiece"
            ],
            festivals: [
                .init(name: "Marrakech International Film Festival", month: 11, description: "Stars and filmmakers descend on the city for one of Africa's premier film events.")
            ],
            bestFor: [.culture, .food, .wellness, .romance],
            travelTip: "Stay inside the medina in a traditional riad for an authentic experience — and negotiate taxi prices before you get in."
        ),

        SeasonalRecommendation(
            destination: "Kyoto",
            country: "Japan",
            imageURL: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800",
            months: [3, 4],
            season: .spring,
            weatherDescription: "Cherry blossoms peak — Japan's most magical season",
            tempRange: "8–18°C",
            priceTier: .expensive,
            crowdLevel: .veryBusy,
            highlights: [
                "Cherry blossom viewing (hanami) along the Philosopher's Path",
                "Fushimi Inari shrine — thousands of torii gates at dawn",
                "Geisha spotting in Gion historic district",
                "Tea ceremony in a 400-year-old machiya townhouse"
            ],
            festivals: [
                .init(name: "Hanami Season", month: 3, description: "Parks and riverbanks transform into pink canopies as sakura reaches full bloom."),
                .init(name: "Miyako Odori", month: 4, description: "Geiko and maiko dancers perform traditional dances at Gion Kobu Kaburen-jo Theatre.")
            ],
            bestFor: [.culture, .food, .romance, .solo],
            travelTip: "Book JR Pass and accommodation 3–4 months ahead — peak cherry blossom dates sell out extremely fast."
        ),

        SeasonalRecommendation(
            destination: "Lisbon",
            country: "Portugal",
            imageURL: "https://images.unsplash.com/photo-1548707309-dcebeab9ea9b?w=800",
            months: [3, 4, 5],
            season: .spring,
            weatherDescription: "Warm and sunny with zero crowds — Europe's best-value capital",
            tempRange: "14–22°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Ride tram 28 through the historic Alfama district",
                "Pastéis de Belém — the original custard tart at the source",
                "Day trip to fairy-tale Sintra palaces",
                "Fado music evening in a candlelit Alfama tasca"
            ],
            festivals: [
                .init(name: "Lisbon Half Marathon", month: 3, description: "One of Europe's most scenic races across the 25 de Abril Bridge."),
                .init(name: "Peixe em Lisboa", month: 4, description: "Top chefs celebrate Portuguese seafood culture at this prestigious food festival.")
            ],
            bestFor: [.culture, .food, .solo, .romance],
            travelTip: "Get a 24-hour transport card — it covers trams, metro and buses for unlimited use and saves significant money."
        ),

        SeasonalRecommendation(
            destination: "Petra",
            country: "Jordan",
            imageURL: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=800",
            months: [3, 4, 10, 11],
            season: .spring,
            weatherDescription: "Warm but not scorching — ideal for exploring on foot",
            tempRange: "15–25°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Walk the Siq canyon to reach the iconic Treasury at sunrise",
                "Hike the High Place of Sacrifice trail for panoramic views",
                "Petra by Night candlelit ceremony",
                "Float in the Dead Sea and explore Wadi Rum desert"
            ],
            festivals: [
                .init(name: "Petra Desert Marathon", month: 4, description: "Runners race through ancient Nabataean canyons in one of the world's most dramatic races.")
            ],
            bestFor: [.adventure, .culture, .solo, .romance],
            travelTip: "The Jordan Pass covers your visa fee and entrance to Petra — buy it online before arrival to save considerably."
        ),

        SeasonalRecommendation(
            destination: "Cape Town",
            country: "South Africa",
            imageURL: "https://images.unsplash.com/photo-1580060839134-75a5edca2e99?w=800",
            months: [3, 4, 10, 11],
            season: .autumn,
            weatherDescription: "Mild shoulder season — fewer crowds and lower prices",
            tempRange: "16–24°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Cable car to Table Mountain summit at sunset",
                "Penguin colony at Boulders Beach, Simon's Town",
                "Cape Winelands — Stellenbosch and Franschhoek",
                "Whale watching at Hermanus (Sep–Nov)"
            ],
            festivals: [
                .init(name: "Cape Town Jazz Festival", month: 3, description: "Africa's largest jazz festival with 40+ artists across two nights."),
                .init(name: "Good Food and Wine Show", month: 4, description: "Celebrate South Africa's world-class cuisine and wines.")
            ],
            bestFor: [.adventure, .wildlife, .food, .romance],
            travelTip: "Book an Airbnb in the Bo-Kaap neighbourhood for authentic Cape Malay culture — and avoid the V&A Waterfront restaurants for better value."
        ),

        SeasonalRecommendation(
            destination: "Amsterdam",
            country: "Netherlands",
            imageURL: "https://images.unsplash.com/photo-1512470876302-972faa2aa9a4?w=800",
            months: [4, 5],
            season: .spring,
            weatherDescription: "Tulip fields in full bloom, mild and fresh",
            tempRange: "8–17°C",
            priceTier: .expensive,
            crowdLevel: .veryBusy,
            highlights: [
                "Keukenhof Gardens — 7 million tulips in bloom",
                "Canal boat tour through the UNESCO-listed waterways",
                "Rijksmuseum Rembrandt and Vermeer masterpieces",
                "Cycling through the flower bulb fields in Lisse"
            ],
            festivals: [
                .init(name: "King's Day", month: 4, description: "The entire city dresses in orange and turns into one giant street party on April 27."),
                .init(name: "Tulip Festival", month: 4, description: "Over 800,000 tulips are planted across Amsterdam's squares and parks.")
            ],
            bestFor: [.culture, .romance, .family, .solo],
            travelTip: "Pre-book the Anne Frank House weeks ahead — same-day tickets sell out within minutes of release each morning."
        ),

        SeasonalRecommendation(
            destination: "Dubrovnik",
            country: "Croatia",
            imageURL: "https://images.unsplash.com/photo-1555990793-da11153b2473?w=800",
            months: [5, 6, 9],
            season: .spring,
            weatherDescription: "Warm Adriatic weather without the peak-summer crush",
            tempRange: "20–27°C",
            priceTier: .expensive,
            crowdLevel: .busy,
            highlights: [
                "Walk the 2km medieval city walls above terracotta rooftops",
                "Island hop to Hvar, Korčula and Mljet by catamaran",
                "Game of Thrones filming location tour",
                "Sea kayaking around the old city walls at sunset"
            ],
            festivals: [
                .init(name: "Dubrovnik Summer Festival", month: 6, description: "Classical music, theatre and dance performed in the stunning open-air venues within the city walls.")
            ],
            bestFor: [.beach, .culture, .romance, .adventure],
            travelTip: "Take the cable car to Mount Srđ at golden hour — the view over the walled city and islands is extraordinary, and far less crowded than the city walls."
        ),

        SeasonalRecommendation(
            destination: "Reykjavik",
            country: "Iceland",
            imageURL: "https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=800",
            months: [6, 7],
            season: .summer,
            weatherDescription: "Midnight sun — 24 hours of daylight for endless exploring",
            tempRange: "10–16°C",
            priceTier: .expensive,
            crowdLevel: .busy,
            highlights: [
                "Golden Circle — Geysir, Gullfoss and Þingvellir National Park",
                "Midnight sun hike on Fimmvörðuháls trail",
                "Whale watching from Reykjavik harbour",
                "Snorkelling in Silfra fissure between two tectonic plates"
            ],
            festivals: [
                .init(name: "Secret Solstice Festival", month: 6, description: "A unique music festival held under the midnight sun with 96 hours of daylight."),
                .init(name: "Reykjavik Pride", month: 7, description: "One of the world's most inclusive Pride celebrations with huge street parades.")
            ],
            bestFor: [.adventure, .solo, .wildlife, .romance],
            travelTip: "Rent a 4WD campervan to access the highland F-roads — regular cars are prohibited and the highlands are Iceland's most spectacular scenery."
        ),

        SeasonalRecommendation(
            destination: "Galway",
            country: "Ireland",
            imageURL: "https://images.unsplash.com/photo-1590089415225-401ed6f9db8e?w=800",
            months: [5, 6, 7],
            season: .spring,
            weatherDescription: "Green countryside, long evenings and lively pub culture",
            tempRange: "10–18°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Cycle the Wild Atlantic Way coastal cliffs route",
                "Traditional music sessions in Tigh Neachtain pub",
                "Aran Islands ferry and ancient stone fort Dún Aonghasa",
                "Connemara National Park hiking through bog landscapes"
            ],
            festivals: [
                .init(name: "Galway International Arts Festival", month: 7, description: "Two weeks of world-class theatre, music and visual arts across the city.")
            ],
            bestFor: [.culture, .solo, .adventure, .food],
            travelTip: "Book a B&B rather than a hotel — Irish bed and breakfasts offer far warmer hospitality and often include a full cooked breakfast."
        ),

        SeasonalRecommendation(
            destination: "Santorini",
            country: "Greece",
            imageURL: "https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800",
            months: [5, 6, 9, 10],
            season: .spring,
            weatherDescription: "Blue skies, warm sea, before or after the summer peak",
            tempRange: "20–28°C",
            priceTier: .expensive,
            crowdLevel: .busy,
            highlights: [
                "Sunset from the Oia clifftop village viewpoint",
                "Boat trip to the active Nea Kameni volcano caldera",
                "Wine tasting of Assyrtiko on volcanic soil vineyards",
                "Black sand beach at Perissa and red beach at Akrotiri"
            ],
            festivals: [
                .init(name: "Ifestia Festival", month: 9, description: "An extraordinary fireworks display re-enacts the ancient volcanic eruption over the caldera.")
            ],
            bestFor: [.beach, .romance, .food, .wellness],
            travelTip: "Stay in Imerovigli rather than Oia for similar caldera views at a quarter of the price — and avoid the Oia sunset crowds."
        ),

        SeasonalRecommendation(
            destination: "Thimphu",
            country: "Bhutan",
            imageURL: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800",
            months: [3, 4, 5, 9, 10],
            season: .spring,
            weatherDescription: "Clear mountain skies and comfortable trekking temperatures",
            tempRange: "10–20°C",
            priceTier: .expensive,
            crowdLevel: .quiet,
            highlights: [
                "Trek to Tiger's Nest Monastery (Paro Taktsang) cliff edge",
                "Attend a Tsechu festival in full traditional mask dance",
                "Punakha Dzong fortress at the river confluence",
                "Archery — Bhutan's national sport — with locals"
            ],
            festivals: [
                .init(name: "Paro Tsechu", month: 4, description: "One of Bhutan's most sacred festivals with colourful mask dances in traditional dress."),
                .init(name: "Thimphu Tsechu", month: 9, description: "Five days of religious dance performances near the Tashichho Dzong palace.")
            ],
            bestFor: [.adventure, .culture, .wellness, .solo],
            travelTip: "All foreign tourists must book through a licensed Bhutanese tour operator — the Sustainable Development Fee includes accommodation, transport and a guide."
        ),

        SeasonalRecommendation(
            destination: "Tromsø",
            country: "Norway",
            imageURL: "https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=800",
            months: [7, 8],
            season: .summer,
            weatherDescription: "Midnight sun hiking season — vivid alpine landscapes",
            tempRange: "12–20°C",
            priceTier: .expensive,
            crowdLevel: .quiet,
            highlights: [
                "Midnight sun hike to Storsteinen summit for panoramic views",
                "Arctic wildlife safari — reindeer, moose and sea eagles",
                "Fjord kayaking at midnight under the perpetual sun",
                "Arctic Cathedral architecture and midnight service"
            ],
            festivals: [
                .init(name: "Midnight Sun Marathon", month: 6, description: "Run a marathon at midnight under the sun — one of the world's most unique race experiences."),
                .init(name: "Tromsø International Film Festival", month: 7, description: "Nordic cinema takes the spotlight in the world's northernmost film festival.")
            ],
            bestFor: [.adventure, .wildlife, .solo, .romance],
            travelTip: "In summer, bring a sleep mask — blackout curtains are available in hotels but the midnight light still seeps through. The constant daylight is genuinely disorientating."
        ),

        SeasonalRecommendation(
            destination: "Banff",
            country: "Canada",
            imageURL: "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=800",
            months: [7, 8],
            season: .summer,
            weatherDescription: "Alpine meadows in bloom, glacial lakes electric blue",
            tempRange: "10–22°C",
            priceTier: .moderate,
            crowdLevel: .veryBusy,
            highlights: [
                "Canoe on impossibly turquoise Lake Louise at dawn",
                "Icefields Parkway drive — one of the world's great scenic routes",
                "Hike to the Plain of Six Glaciers teahouse",
                "Wildlife spotting — bears, elk and bighorn sheep along roadsides"
            ],
            festivals: [
                .init(name: "Banff Centre Mountain Film Festival", month: 8, description: "The world's premier mountain culture film and arts festival.")
            ],
            bestFor: [.adventure, .family, .romance, .wildlife],
            travelTip: "Arrive at Lake Louise and Moraine Lake before 6am to beat the crowds and get free parking — shuttle buses operate throughout the day if you arrive later."
        ),

        SeasonalRecommendation(
            destination: "Cusco & Machu Picchu",
            country: "Peru",
            imageURL: "https://images.unsplash.com/photo-1526392060635-9d6019884377?w=800",
            months: [6, 7, 8],
            season: .winter,
            weatherDescription: "Dry season in the Andes — crisp skies, no rain",
            tempRange: "5–18°C",
            priceTier: .moderate,
            crowdLevel: .busy,
            highlights: [
                "Sunrise at Machu Picchu from the Sun Gate (Inti Punku)",
                "Inca Trail 4-day trek through cloud forest and ruins",
                "Rainbow Mountain (Vinicunca) high-altitude hike",
                "Sacred Valley market day at Pisac village"
            ],
            festivals: [
                .init(name: "Inti Raymi", month: 6, description: "The Festival of the Sun is a spectacular ancient Inca ceremony re-enacted at Sacsayhuamán fortress."),
                .init(name: "Corpus Christi Cusco", month: 6, description: "Fifteen statues of saints are paraded through Cusco's Plaza de Armas in vivid procession.")
            ],
            bestFor: [.adventure, .culture, .solo, .wildlife],
            travelTip: "Book Machu Picchu timed-entry tickets and the Inca Trail at least 6 months ahead — daily permits are strictly capped and sell out rapidly."
        ),

        SeasonalRecommendation(
            destination: "Serengeti",
            country: "Tanzania",
            imageURL: "https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800",
            months: [7, 8, 9],
            season: .summer,
            weatherDescription: "Great Migration peak — dry savanna and clear skies",
            tempRange: "15–28°C",
            priceTier: .luxurious,
            crowdLevel: .moderate,
            highlights: [
                "Witness the Great Wildebeest Migration river crossings",
                "Hot-air balloon safari at sunrise over the plains",
                "Big Five game drives with expert Maasai guides",
                "Luxury tented camp dining under the stars"
            ],
            festivals: [
                .init(name: "Great Migration", month: 7, description: "Over 1.5 million wildebeest cross the Mara River in one of nature's most dramatic spectacles.")
            ],
            bestFor: [.wildlife, .adventure, .romance, .family],
            travelTip: "Position yourself in the northern Serengeti near the Mara River in July–August to maximise chances of witnessing the iconic river crossings."
        ),

        SeasonalRecommendation(
            destination: "Tuscany",
            country: "Italy",
            imageURL: "https://images.unsplash.com/photo-1523531294919-4bcd7c65e216?w=800",
            months: [9, 10],
            season: .autumn,
            weatherDescription: "Grape harvest season — golden light and empty roads",
            tempRange: "14–24°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Harvest-season wine tasting on a Chianti estate",
                "Val d'Orcia sunrise from Montichiello viewpoint",
                "Truffle hunting with hounds in San Miniato",
                "Medieval Siena Palio horse race heritage and city walls"
            ],
            festivals: [
                .init(name: "Grape Harvest Festivals (Vendemmia)", month: 9, description: "Villages across Tuscany celebrate the grape harvest with feasts, tastings and traditional songs."),
                .init(name: "Truffle Festival San Miniato", month: 10, description: "Dedicated to the prized white truffle with tastings, markets and truffle-paired dinners.")
            ],
            bestFor: [.food, .romance, .culture, .wellness],
            travelTip: "Rent a car — public transport between hill towns is very limited. The SS2 Via Cassia drive through the Val d'Orcia is one of the world's most scenic roads."
        ),

        SeasonalRecommendation(
            destination: "Hoi An",
            country: "Vietnam",
            imageURL: "https://images.unsplash.com/photo-1540611025311-01df3cef54b5?w=800",
            months: [2, 3, 9, 10],
            season: .autumn,
            weatherDescription: "Dry and warm — lanterns reflecting on the Thu Bon River",
            tempRange: "22–30°C",
            priceTier: .budget,
            crowdLevel: .busy,
            highlights: [
                "Lantern-lit Ancient Town streets at the full moon festival",
                "Cooking class and market tour with local chef",
                "My Son Hindu sanctuary ruins in the jungle",
                "Tailored silk clothing made overnight by skilled seamstresses"
            ],
            festivals: [
                .init(name: "Hoi An Lantern Festival", month: 9, description: "Every full moon, electric lights are switched off and the ancient town glows by lantern light."),
                .init(name: "Mid-Autumn Festival", month: 9, description: "Children parade with star-shaped lanterns and families share mooncakes under the full moon.")
            ],
            bestFor: [.culture, .food, .romance, .solo],
            travelTip: "The Ancient Town ticket includes entry to 5 heritage sites — choose your 5 wisely from the mix of assembly halls, merchant houses and craft workshops."
        ),

        SeasonalRecommendation(
            destination: "Kathmandu Valley",
            country: "Nepal",
            imageURL: "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800",
            months: [9, 10, 11],
            season: .autumn,
            weatherDescription: "Post-monsoon clarity — Himalayan peaks crystal clear",
            tempRange: "10–22°C",
            priceTier: .budget,
            crowdLevel: .busy,
            highlights: [
                "Everest Base Camp trek through Sherpa villages",
                "Sunrise over the Himalayas from Poon Hill, Ghorepani",
                "UNESCO Durbar Squares of Kathmandu, Patan and Bhaktapur",
                "White-water rafting on the Trishuli River"
            ],
            festivals: [
                .init(name: "Dashain", month: 10, description: "Nepal's biggest festival — families reunite, kites fill the sky and bamboo swings tower above every village."),
                .init(name: "Tihar (Diwali)", month: 10, description: "The festival of lights honours crows, dogs, cows and brothers across five colourful days.")
            ],
            bestFor: [.adventure, .culture, .solo, .wildlife],
            travelTip: "Acclimatise properly — spend at least 2 nights in Kathmandu (1400m) before heading to altitude. Altitude sickness is real and does not discriminate by fitness level."
        ),

        SeasonalRecommendation(
            destination: "Quebec",
            country: "Canada",
            imageURL: "https://images.unsplash.com/photo-1508193638397-1c4234db14d8?w=800",
            months: [9, 10],
            season: .autumn,
            weatherDescription: "Fall foliage at peak — maple forests ablaze with colour",
            tempRange: "5–18°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Laurentian Mountains fall foliage drive on Route 323",
                "Old Quebec City and UNESCO-listed fortification walls",
                "Whale watching at Tadoussac where St Lawrence meets Saguenay",
                "Sugar shack maple harvest experience with pancake feast"
            ],
            festivals: [
                .init(name: "Quebec City Fall Colours Festival", month: 10, description: "Guided hikes and photography tours to the best maple forest viewpoints."),
                .init(name: "Festival des Couleurs Mont-Tremblant", month: 9, description: "A weekend of live music, gondola rides and the most spectacular fall colours in eastern Canada.")
            ],
            bestFor: [.family, .romance, .food, .adventure],
            travelTip: "The Orford to Mont-Tremblant corridor offers the most accessible foliage. Rent a car and drive slowly — you will want to stop every five minutes."
        ),

        SeasonalRecommendation(
            destination: "Istanbul",
            country: "Turkey",
            imageURL: "https://images.unsplash.com/photo-1527838832700-5059252407fa?w=800",
            months: [9, 10, 4, 5],
            season: .autumn,
            weatherDescription: "Golden autumn light on domes and minarets — off-peak value",
            tempRange: "15–24°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Hagia Sophia and Blue Mosque at the break of dawn",
                "Grand Bazaar and Spice Market — 4000 shops under one roof",
                "Bosphorus sunset cruise between Europe and Asia",
                "Turkish bath (hamam) ritual at the Çemberlitaş Hamamı"
            ],
            festivals: [
                .init(name: "Istanbul Biennial", month: 9, description: "Contemporary art transforms the city every two years with installations in unexpected spaces."),
                .init(name: "Istanbul Film Festival", month: 10, description: "International and Turkish cinema showcased across the city's historic cinemas.")
            ],
            bestFor: [.culture, .food, .romance, .solo],
            travelTip: "The Istanbul e-visa takes 24 hours — apply online before travel. The Istanbulkart transit card works on all trams, ferries and metro lines."
        ),

        SeasonalRecommendation(
            destination: "Vienna",
            country: "Austria",
            imageURL: "https://images.unsplash.com/photo-1516550893923-42d28e5677af?w=800",
            months: [11, 12],
            season: .winter,
            weatherDescription: "Christmas market season — warm glühwein and fairy lights",
            tempRange: "0–6°C",
            priceTier: .expensive,
            crowdLevel: .busy,
            highlights: [
                "Christkindlmarkt at Rathausplatz — Vienna's most magnificent market",
                "Vienna State Opera for a world-class performance",
                "Imperial crypt and Schönbrunn Palace with seasonal tours",
                "Sacher Torte at the original Hotel Sacher café"
            ],
            festivals: [
                .init(name: "Christkindlmarkt", month: 11, description: "The Rathausplatz transforms into a magical Christmas village with over 150 stalls."),
                .init(name: "New Year's Concert", month: 12, description: "The Vienna Philharmonic's New Year's Concert is broadcast to 90 countries worldwide.")
            ],
            bestFor: [.culture, .romance, .family, .food],
            travelTip: "The Vienna City Card covers all public transport plus discounts to 210 attractions — an excellent investment if you plan to visit multiple museums."
        ),

        SeasonalRecommendation(
            destination: "Prague",
            country: "Czech Republic",
            imageURL: "https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=800",
            months: [11, 12],
            season: .winter,
            weatherDescription: "Snow-dusted spires and mulled wine at Christmas markets",
            tempRange: "-2–4°C",
            priceTier: .budget,
            crowdLevel: .busy,
            highlights: [
                "Old Town Square Christmas market and Astronomical Clock",
                "Prague Castle and St Vitus Cathedral at blue hour",
                "Czech beer tasting at a historic cellar brewery",
                "Josefov Jewish Quarter — six synagogues and the Old Jewish Cemetery"
            ],
            festivals: [
                .init(name: "Prague Christmas Markets", month: 12, description: "Old Town Square fills with stalls selling trdelník, glass ornaments and seasonal crafts."),
                .init(name: "St Nicholas Day", month: 12, description: "Costumed St Nicholas, angel and devil trios roam the streets handing out sweets and coal.")
            ],
            bestFor: [.culture, .food, .romance, .solo],
            travelTip: "Prague has a tourist restaurant trap culture — walk two streets away from the main square to find a Czech hospoda (pub) with authentic svíčková at a third of the price."
        ),

        SeasonalRecommendation(
            destination: "Rovaniemi",
            country: "Finland",
            imageURL: "https://images.unsplash.com/photo-1478827387698-1527781a4887?w=800",
            months: [12, 1, 2],
            season: .winter,
            weatherDescription: "Guaranteed snow, huskies and the best Northern Lights in Europe",
            tempRange: "-20–(-5)°C",
            priceTier: .expensive,
            crowdLevel: .moderate,
            highlights: [
                "Northern Lights (Aurora Borealis) snowshoe hunting",
                "Husky sled safari through snowy Lapland forest",
                "Ice fishing on a frozen lake with a local guide",
                "Santa Claus Village experience right on the Arctic Circle"
            ],
            festivals: [
                .init(name: "Arctic Lapland Rally", month: 1, description: "One of Finland's most spectacular motorsport events on frozen Lapland roads."),
                .init(name: "Christmas in Lapland", month: 12, description: "The world's most authentic Santa experience with real reindeers and guaranteed snowfall.")
            ],
            bestFor: [.adventure, .family, .romance, .wellness],
            travelTip: "Book a glass igloo or aurora cabin 6–12 months ahead for December and January. The glass roof allows Northern Lights viewing from your heated bed."
        ),

        SeasonalRecommendation(
            destination: "Goa",
            country: "India",
            imageURL: "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
            months: [11, 12, 1, 2],
            season: .winter,
            weatherDescription: "Perfect dry season — beach parties and golden sunsets",
            tempRange: "22–32°C",
            priceTier: .budget,
            crowdLevel: .veryBusy,
            highlights: [
                "Sunrise yoga on Arambol or Palolem beach",
                "Old Goa UNESCO churches and Portuguese heritage",
                "Night market at Anjuna — handicrafts and live music",
                "Spice plantation tour and traditional Goan seafood lunch"
            ],
            festivals: [
                .init(name: "Goa Carnival", month: 2, description: "A legacy of Portuguese rule — four days of parades, music and colourful floats through Panaji."),
                .init(name: "Sunburn Festival", month: 12, description: "Asia's largest electronic dance music festival held on a Goa beachfront stage.")
            ],
            bestFor: [.beach, .food, .wellness, .solo],
            travelTip: "North Goa is livelier and party-focused; South Goa is calmer and more upmarket. Choose based on your vibe — they feel like different destinations."
        ),

        SeasonalRecommendation(
            destination: "Sydney",
            country: "Australia",
            imageURL: "https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?w=800",
            months: [11, 12, 1, 2],
            season: .summer,
            weatherDescription: "Southern hemisphere summer — beaches and outdoor festivals",
            tempRange: "20–28°C",
            priceTier: .expensive,
            crowdLevel: .busy,
            highlights: [
                "New Year's Eve fireworks from Sydney Harbour Bridge",
                "Bondi to Coogee coastal walk above the Pacific",
                "Opera House guided tour and performance",
                "Taronga Zoo wildlife: koalas and kangaroos overlooking the harbour"
            ],
            festivals: [
                .init(name: "Sydney New Year's Eve", month: 12, description: "The world's first major fireworks display of the new year lights up the harbour in a dazzling show."),
                .init(name: "Sydney Festival", month: 1, description: "Three weeks of theatre, music and visual arts events across the city.")
            ],
            bestFor: [.beach, .family, .food, .adventure],
            travelTip: "The Opal card works on all trains, buses and ferries. The Manly Ferry from Circular Quay is the most scenic and cheapest harbour cruise available."
        ),

        SeasonalRecommendation(
            destination: "Bali",
            country: "Indonesia",
            imageURL: "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800",
            months: [6, 7, 8, 9],
            season: .summer,
            weatherDescription: "Dry season — surf, rice terraces and spiritual ceremonies",
            tempRange: "24–32°C",
            priceTier: .budget,
            crowdLevel: .veryBusy,
            highlights: [
                "Tegallalang rice terraces at sunrise before the tour buses arrive",
                "Surf the world-class right-hand break at Uluwatu",
                "Tirta Empul holy water temple purification ceremony",
                "Ubud cooking class and traditional dance performance"
            ],
            festivals: [
                .init(name: "Galungan", month: 7, description: "Bamboo poles called penjor line every road as Balinese Hinduism celebrates the victory of dharma over evil."),
                .init(name: "Bali Arts Festival", month: 6, description: "A month-long celebration of Balinese dance, music, crafts and ceremonial arts in Denpasar.")
            ],
            bestFor: [.beach, .wellness, .culture, .solo],
            travelTip: "Ride a scooter for maximum flexibility — most attractions are separated by winding roads through villages. Always negotiate a price before any taxi journey."
        ),

        SeasonalRecommendation(
            destination: "Edinburgh",
            country: "Scotland",
            imageURL: "https://images.unsplash.com/photo-1527747777966-d0d2a8caa63f?w=800",
            months: [8],
            season: .summer,
            weatherDescription: "The Fringe transforms the entire city into a performance space",
            tempRange: "13–18°C",
            priceTier: .moderate,
            crowdLevel: .veryBusy,
            highlights: [
                "Edinburgh Fringe Festival — 3500 shows in every venue imaginable",
                "Arthur's Seat volcano summit hike through Holyrood Park",
                "Royal Mile historic walk from castle to Holyrood Palace",
                "Scotch whisky tasting at The Scotch Whisky Experience"
            ],
            festivals: [
                .init(name: "Edinburgh Festival Fringe", month: 8, description: "The world's largest arts festival with over 60,000 performances during three weeks in August."),
                .init(name: "Edinburgh Military Tattoo", month: 8, description: "Spectacular military bands and pageantry performed on the floodlit castle esplanade.")
            ],
            bestFor: [.culture, .solo, .food, .adventure],
            travelTip: "Book Fringe tickets in advance for the most popular shows. Half the joy is stumbling on free street performances on the Royal Mile — budget acts are often extraordinary."
        ),

        SeasonalRecommendation(
            destination: "Patagonia",
            country: "Argentina",
            imageURL: "https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800",
            months: [11, 12, 1, 2],
            season: .summer,
            weatherDescription: "Southern hemisphere summer — glaciers and granite towers",
            tempRange: "8–18°C",
            priceTier: .expensive,
            crowdLevel: .moderate,
            highlights: [
                "Trek the W Circuit in Torres del Paine National Park",
                "Perito Moreno Glacier up-close walkway experience",
                "Condor watching at Mirador Condor above the steppe",
                "El Chaltén — Argentina's trekking capital and Fitz Roy base"
            ],
            festivals: [
                .init(name: "Ushuaia Jazz Festival", month: 1, description: "World-class jazz in the world's southernmost city — an unforgettable setting.")
            ],
            bestFor: [.adventure, .solo, .wildlife, .romance],
            travelTip: "Book Torres del Paine camping reservations online months in advance — the park strictly limits numbers and popular sites sell out in seconds when slots open."
        ),

        SeasonalRecommendation(
            destination: "Osaka",
            country: "Japan",
            imageURL: "https://images.unsplash.com/photo-1590559899731-a382839e5549?w=800",
            months: [10, 11],
            season: .autumn,
            weatherDescription: "Autumn leaves and crisp skies — Japan's foodie capital",
            tempRange: "12–20°C",
            priceTier: .moderate,
            crowdLevel: .busy,
            highlights: [
                "Dotonbori canal district — neon signs and street food paradise",
                "Autumn foliage at Minoo Park waterfalls",
                "Osaka Castle with surrounding momiji maple gardens",
                "Takoyaki, okonomiyaki and kushikatsu food tour of Shinsekai"
            ],
            festivals: [
                .init(name: "Tenjin Matsuri", month: 10, description: "One of Japan's three greatest festivals with river processions and fireworks over the Okawa River."),
                .init(name: "Osaka Autumn Leaves", month: 11, description: "Parks and temple grounds turn brilliant red, orange and gold through November.")
            ],
            bestFor: [.food, .culture, .solo, .family],
            travelTip: "The Osaka Amazing Pass gives unlimited metro rides and free entry to 40+ attractions including Osaka Castle — excellent value for a 2-day city pass."
        ),

        SeasonalRecommendation(
            destination: "Zermatt",
            country: "Switzerland",
            imageURL: "https://images.unsplash.com/photo-1531973576160-7125cd663d86?w=800",
            months: [1, 2, 12],
            season: .winter,
            weatherDescription: "World-class skiing under the iconic Matterhorn peak",
            tempRange: "-10–2°C",
            priceTier: .luxurious,
            crowdLevel: .busy,
            highlights: [
                "Ski the Matterhorn Glacier Paradise — highest ski resort in the Alps",
                "Gornergrat Bahn cog railway to 3089m summit viewpoint",
                "Car-free village — horse-drawn sleighs through snowy streets",
                "Fondue dinner in a traditional Swiss mountain chalet"
            ],
            festivals: [
                .init(name: "Zermatt Unplugged", month: 12, description: "Acoustic music festival with world-class artists performing intimate shows in a ski resort setting.")
            ],
            bestFor: [.skiing, .romance, .adventure, .wellness],
            travelTip: "The village is car-free by law — take the Matterhorn Gotthard Bahn train from Visp or Brig. Electric taxis transport luggage between the station and hotels."
        ),

        SeasonalRecommendation(
            destination: "Cartagena",
            country: "Colombia",
            imageURL: "https://images.unsplash.com/photo-1533577116850-9cc66cad8a9b?w=800",
            months: [12, 1, 2],
            season: .winter,
            weatherDescription: "Caribbean dry season — cobblestone streets and warm nights",
            tempRange: "25–32°C",
            priceTier: .moderate,
            crowdLevel: .moderate,
            highlights: [
                "Walled city walks through colourful colonial architecture",
                "Islas del Rosario snorkelling on pristine coral reefs",
                "Palenque village day trip — Africa's cultural legacy in Colombia",
                "Rooftop cocktails at sunset over the Caribbean and city walls"
            ],
            festivals: [
                .init(name: "Cartagena Film Festival", month: 1, description: "Latin America's oldest film festival, celebrating its rich cinematic heritage.")
            ],
            bestFor: [.beach, .culture, .romance, .food],
            travelTip: "Book a boutique hotel inside the walled city — walking distance to everything means you avoid taxis and experience the city at its most authentic in the evening."
        )
    ]
}
