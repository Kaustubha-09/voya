import Foundation

struct Playbook: Identifiable, Codable {
    var id: String
    var title: String
    var destination: String
    var coverImageURL: String
    var authorName: String
    var authorInitials: String
    var authorIsVerified: Bool
    var tripType: TripType
    var duration: Int
    var days: [PlaybookDay]
    var tips: [PlaybookTip]
    var budgetMin: Double
    var budgetMax: Double
    var bestTimeToVisit: String
    var packingList: [String]
    var rating: Double
    var ratingCount: Int
    var forkCount: Int
    var viewCount: Int
    var createdAt: Date
    var lastUpdated: Date
    var tags: [String]

    var budgetRange: String { "$\(Int(budgetMin))–$\(Int(budgetMax))" }
    var authorLabel: String { authorIsVerified ? "\(authorName) ✓" : authorName }

    enum TripType: String, Codable, CaseIterable, Identifiable {
        case solo, couple, family, group, budget, luxury, adventure, cultural
        var id: String { rawValue }
        var label: String { rawValue.capitalized }
        var icon: String {
            switch self {
            case .solo: return "person.fill"
            case .couple: return "heart.fill"
            case .family: return "house.fill"
            case .group: return "person.3.fill"
            case .budget: return "dollarsign.circle.fill"
            case .luxury: return "star.fill"
            case .adventure: return "figure.hiking"
            case .cultural: return "building.columns.fill"
            }
        }
    }
}

struct PlaybookDay: Identifiable, Codable {
    var id: String
    var dayNumber: Int
    var title: String
    var activities: [PlaybookActivity]
}

struct PlaybookActivity: Identifiable, Codable {
    var id: String
    var time: String
    var title: String
    var description: String
    var type: ActivityType
    var estimatedCost: Double?

    enum ActivityType: String, Codable {
        case food, transport, activity, stay, tip
        var icon: String {
            switch self {
            case .food: return "fork.knife"
            case .transport: return "car.fill"
            case .activity: return "ticket.fill"
            case .stay: return "house.fill"
            case .tip: return "lightbulb.fill"
            }
        }
        var color: String {
            switch self {
            case .food: return "orange"
            case .transport: return "blue"
            case .activity: return "purple"
            case .stay: return "green"
            case .tip: return "yellow"
            }
        }
    }
}

struct PlaybookTip: Identifiable, Codable {
    var id: String
    var category: TipCategory
    var text: String
    var upvotes: Int

    enum TipCategory: String, Codable, CaseIterable {
        case local, food, transport, safety, money, packing
        var icon: String {
            switch self {
            case .local: return "mappin.circle.fill"
            case .food: return "fork.knife.circle.fill"
            case .transport: return "car.circle.fill"
            case .safety: return "shield.fill"
            case .money: return "dollarsign.circle.fill"
            case .packing: return "bag.fill"
            }
        }
    }
}

extension Playbook {
    static var seedPlaybooks: [Playbook] {
        let now = Date()
        let cal = Calendar.current

        return [

            Playbook(
                id: "pb-bali-solo",
                title: "7 Days in Bali: Solo Adventure",
                destination: "Bali, Indonesia",
                coverImageURL: "https://images.unsplash.com/photo-1476514525405-359c9291c9d3?w=800&q=80",
                authorName: "Maya Chen",
                authorInitials: "MC",
                authorIsVerified: true,
                tripType: .adventure,
                duration: 7,
                days: [
                    PlaybookDay(
                        id: "pb-bali-d1",
                        dayNumber: 1,
                        title: "Arrival & Seminyak Vibes",
                        activities: [
                            PlaybookActivity(id: "pb-bali-d1-a1", time: "2:00 PM", title: "Land at Ngurah Rai Airport", description: "Grab a Blue Bird taxi — avoid the touts outside. Fixed rate to Seminyak is around $12.", type: .transport, estimatedCost: 12),
                            PlaybookActivity(id: "pb-bali-d1-a2", time: "4:30 PM", title: "Check in & freshen up", description: "Drop your bags and recharge at your villa. Most hostels allow early luggage storage.", type: .stay, estimatedCost: 25),
                            PlaybookActivity(id: "pb-bali-d1-a3", time: "6:00 PM", title: "Sunset at Ku De Ta beach", description: "Iconic Seminyak sunset spot. Order a Bintang and watch surfers catch the last waves.", type: .activity, estimatedCost: 8),
                            PlaybookActivity(id: "pb-bali-d1-a4", time: "8:00 PM", title: "Dinner at Warung Sobat", description: "Local warungs on Jl. Kayu Aya serve Nasi Goreng for under $3. Skip the tourist strip.", type: .food, estimatedCost: 3)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-bali-d2",
                        dayNumber: 2,
                        title: "Ubud Jungle & Rice Terraces",
                        activities: [
                            PlaybookActivity(id: "pb-bali-d2-a1", time: "7:00 AM", title: "Sunrise at Tegallalang", description: "Arrive before 8am to beat the crowds. The misty rice terrace views are worth the early wake-up.", type: .activity, estimatedCost: 2),
                            PlaybookActivity(id: "pb-bali-d2-a2", time: "10:00 AM", title: "Ubud Sacred Monkey Forest", description: "Keep all food and shiny objects hidden — the macaques are bold. Entrance fee included.", type: .activity, estimatedCost: 4),
                            PlaybookActivity(id: "pb-bali-d2-a3", time: "1:00 PM", title: "Lunch at Locavore NXT", description: "Affordable sister restaurant to the famous Locavore. Farm-to-table Indonesian cuisine.", type: .food, estimatedCost: 18),
                            PlaybookActivity(id: "pb-bali-d2-a4", time: "3:30 PM", title: "Campuhan Ridge Walk", description: "A gentle 2km jungle walk with panoramic valley views. No entrance fee, go late afternoon to avoid heat.", type: .activity, estimatedCost: 0)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-bali-d3",
                        dayNumber: 3,
                        title: "Temple Hopping & East Bali",
                        activities: [
                            PlaybookActivity(id: "pb-bali-d3-a1", time: "8:00 AM", title: "Tirta Gangga Water Palace", description: "Rent a scooter the night before ($5/day) for the scenic 90-min drive east. Arrive early for mirror-calm photos.", type: .transport, estimatedCost: 5),
                            PlaybookActivity(id: "pb-bali-d3-a2", time: "11:00 AM", title: "Lempuyang Temple Gate of Heaven", description: "The iconic split gate with Agung in the background. Queue is long — go on weekday mornings.", type: .activity, estimatedCost: 3),
                            PlaybookActivity(id: "pb-bali-d3-a3", time: "2:00 PM", title: "Warung Makan Ibu Oka", description: "Legendary suckling pig (babi guling). Queue outside, cash only, portions are generous.", type: .food, estimatedCost: 7)
                        ]
                    )
                ],
                tips: [
                    PlaybookTip(id: "pb-bali-t1", category: .money, text: "Withdraw cash at BCA or Mandiri ATMs — they have the best rates and lowest fees for foreign cards.", upvotes: 142),
                    PlaybookTip(id: "pb-bali-t2", category: .transport, text: "Download the Gojek app before you land. It's cheaper than Grab and locals use it everywhere.", upvotes: 218),
                    PlaybookTip(id: "pb-bali-t3", category: .local, text: "Always carry a sarong — required at all temples. Buy one at any market for $2.", upvotes: 97),
                    PlaybookTip(id: "pb-bali-t4", category: .safety, text: "Don't drink tap water. Bottled water is everywhere and costs under $0.50.", upvotes: 183),
                    PlaybookTip(id: "pb-bali-t5", category: .food, text: "Eat where locals eat. If a warung has plastic chairs and no English menu, that's the best sign.", upvotes: 261)
                ],
                budgetMin: 40,
                budgetMax: 80,
                bestTimeToVisit: "April–October (dry season)",
                packingList: ["Sarong (or buy one there)", "Reef-safe sunscreen", "Mosquito repellent with DEET", "Stomach medicine (just in case)", "Unlocked phone for local SIM", "Waterproof sandals", "Light rain jacket", "Power adapter (Type C/F)", "Small daypack", "Cash (USD or IDR)"],
                rating: 4.8,
                ratingCount: 312,
                forkCount: 87,
                viewCount: 4210,
                createdAt: cal.date(byAdding: .month, value: -8, to: now)!,
                lastUpdated: cal.date(byAdding: .day, value: -14, to: now)!,
                tags: ["beach", "adventure", "budget", "solo", "culture"]
            ),

            Playbook(
                id: "pb-paris-couple",
                title: "5 Days in Paris: Romantic Luxury",
                destination: "Paris, France",
                coverImageURL: "https://images.unsplash.com/photo-1502602687087-c43a99a22c11?w=800&q=80",
                authorName: "Sophie Laurent",
                authorInitials: "SL",
                authorIsVerified: true,
                tripType: .luxury,
                duration: 5,
                days: [
                    PlaybookDay(
                        id: "pb-paris-d1",
                        dayNumber: 1,
                        title: "Arrival & Le Marais",
                        activities: [
                            PlaybookActivity(id: "pb-paris-d1-a1", time: "11:00 AM", title: "CDG to Hotel via Taxi", description: "Book a private taxi through the airport app for a flat €55 rate. The RER train saves money but luggage is awkward.", type: .transport, estimatedCost: 55),
                            PlaybookActivity(id: "pb-paris-d1-a2", time: "1:30 PM", title: "Lunch at Chez Janou", description: "A Provençal bistro tucked in Le Marais. The ratatouille and chocolate mousse are unmissable.", type: .food, estimatedCost: 45),
                            PlaybookActivity(id: "pb-paris-d1-a3", time: "4:00 PM", title: "Place des Vosges stroll", description: "Paris's oldest planned square. Grab macarons from nearby Ladurée and sit under the arcades.", type: .activity, estimatedCost: 12),
                            PlaybookActivity(id: "pb-paris-d1-a4", time: "8:00 PM", title: "Dinner at Septime", description: "Book 3 weeks ahead online. One of Paris's best natural wine and bistronomie restaurants. The €60 set menu is worth every euro.", type: .food, estimatedCost: 120)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-paris-d2",
                        dayNumber: 2,
                        title: "Louvre Morning, Montmartre Evening",
                        activities: [
                            PlaybookActivity(id: "pb-paris-d2-a1", time: "9:00 AM", title: "Louvre Museum (skip the queue)", description: "Pre-book timed entry online. Head straight to Richelieu wing to see Vermeer and Dutch masters before crowds build.", type: .activity, estimatedCost: 22),
                            PlaybookActivity(id: "pb-paris-d2-a2", time: "1:00 PM", title: "Café de Flore lunch", description: "A Saint-Germain institution. The croque monsieur and café au lait are iconic. Expensive but worth the experience.", type: .food, estimatedCost: 35),
                            PlaybookActivity(id: "pb-paris-d2-a3", time: "4:00 PM", title: "Sacré-Cœur & Montmartre wander", description: "Walk up the winding streets of Montmartre. Stop at Place du Tertre to watch portrait artists.", type: .activity, estimatedCost: 0),
                            PlaybookActivity(id: "pb-paris-d2-a4", time: "9:00 PM", title: "Wine tasting at Caves du Panthéon", description: "Intimate cellar wine bar in Latin Quarter. The sommelier-guided tasting flight is exceptional.", type: .food, estimatedCost: 65)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-paris-d3",
                        dayNumber: 3,
                        title: "Versailles Day Trip",
                        activities: [
                            PlaybookActivity(id: "pb-paris-d3-a1", time: "8:30 AM", title: "RER C to Versailles", description: "40 minutes from Gare d'Austerlitz. Buy a Paris Visite pass that covers the journey.", type: .transport, estimatedCost: 8),
                            PlaybookActivity(id: "pb-paris-d3-a2", time: "10:00 AM", title: "Palace of Versailles tour", description: "Start with the Hall of Mirrors then the King's Grand Apartments. Hire an audio guide — it transforms the visit.", type: .activity, estimatedCost: 27),
                            PlaybookActivity(id: "pb-paris-d3-a3", time: "2:00 PM", title: "Gardens & Grand Trianon", description: "Rent a golf cart to explore the 800-hectare gardens. The Grand Trianon is less crowded and equally stunning.", type: .activity, estimatedCost: 30)
                        ]
                    )
                ],
                tips: [
                    PlaybookTip(id: "pb-paris-t1", category: .transport, text: "Get a Navigo Semaine (weekly) Metro pass — unlimited zones, and it works on the RER too.", upvotes: 189),
                    PlaybookTip(id: "pb-paris-t2", category: .food, text: "Lunch menus (formule) at good restaurants are usually €15–25 for 2 courses — same kitchen as dinner at half the price.", upvotes: 347),
                    PlaybookTip(id: "pb-paris-t3", category: .local, text: "Most major museums are free on the first Sunday of the month. Plan around this if budget matters.", upvotes: 412),
                    PlaybookTip(id: "pb-paris-t4", category: .money, text: "Avoid currency exchange kiosks near tourist sites. Revolut or Wise cards give near-perfect rates.", upvotes: 228),
                    PlaybookTip(id: "pb-paris-t5", category: .safety, text: "Watch for pickpockets around the Eiffel Tower and metro line 1. Keep wallets in front pockets.", upvotes: 301)
                ],
                budgetMin: 300,
                budgetMax: 600,
                bestTimeToVisit: "April–June or September–October",
                packingList: ["Smart casual outfits (Parisians dress well)", "Comfortable walking shoes", "Compact umbrella", "Paris Museum Pass (buy ahead)", "French phrasebook or app", "Adapter (Type E)", "Small crossbody bag", "Silk scarf (doubles as style + temple cover)", "Reusable water bottle (free fountains everywhere)"],
                rating: 4.9,
                ratingCount: 541,
                forkCount: 134,
                viewCount: 8920,
                createdAt: cal.date(byAdding: .month, value: -12, to: now)!,
                lastUpdated: cal.date(byAdding: .day, value: -7, to: now)!,
                tags: ["city", "luxury", "culture", "food", "couple"]
            ),

            Playbook(
                id: "pb-thailand-budget",
                title: "10 Days Thailand on $35/Day",
                destination: "Thailand",
                coverImageURL: "https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=800&q=80",
                authorName: "Tom Rivers",
                authorInitials: "TR",
                authorIsVerified: false,
                tripType: .budget,
                duration: 10,
                days: [
                    PlaybookDay(
                        id: "pb-thai-d1",
                        dayNumber: 1,
                        title: "Bangkok Street Food Immersion",
                        activities: [
                            PlaybookActivity(id: "pb-thai-d1-a1", time: "9:00 AM", title: "Wat Pho temple complex", description: "150 baht entry. See the 46m reclining Buddha. Go early before tour groups arrive. Dress modestly.", type: .activity, estimatedCost: 4),
                            PlaybookActivity(id: "pb-thai-d1-a2", time: "12:00 PM", title: "Or Tor Kor Market lunch", description: "Bangkok's cleanest fresh market. Pad Thai, mango sticky rice, fresh durian. Everything under 50 baht.", type: .food, estimatedCost: 4),
                            PlaybookActivity(id: "pb-thai-d1-a3", time: "3:00 PM", title: "Khao San Road exploration", description: "Tourist central but worth a walk. Buy a Chang beer (35 baht) and people-watch from a street-side stool.", type: .activity, estimatedCost: 2),
                            PlaybookActivity(id: "pb-thai-d1-a4", time: "7:00 PM", title: "Yaowarat Chinatown night market", description: "One of Asia's great street food strips. The grilled seafood stalls along the main road are legendary.", type: .food, estimatedCost: 8)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-thai-d2",
                        dayNumber: 2,
                        title: "Chiang Mai Arrival & Night Bazaar",
                        activities: [
                            PlaybookActivity(id: "pb-thai-d2-a1", time: "7:00 AM", title: "Budget flight BKK → CNX", description: "Book AirAsia or Nok Air at least 3 weeks ahead. Around $20–35 one-way, faster than 11hr train.", type: .transport, estimatedCost: 28),
                            PlaybookActivity(id: "pb-thai-d2-a2", time: "12:00 PM", title: "Check in to guesthouse in Old City", description: "The moat area has great $8–12/night guesthouses. Rooftop cafes included in some.", type: .stay, estimatedCost: 10),
                            PlaybookActivity(id: "pb-thai-d2-a3", time: "7:00 PM", title: "Chiang Mai Night Bazaar", description: "Browse hill tribe crafts, silver jewelry, and silk scarves. Bargain confidently but respectfully — start at 40% of asking price.", type: .activity, estimatedCost: 15)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-thai-d3",
                        dayNumber: 3,
                        title: "Doi Inthanon & Hill Tribe Villages",
                        activities: [
                            PlaybookActivity(id: "pb-thai-d3-a1", time: "6:30 AM", title: "Songthaew to Doi Inthanon", description: "Red shared truck from Chiang Mai Gate. Negotiate 100–150 baht per person for a group run. Starts early.", type: .transport, estimatedCost: 5),
                            PlaybookActivity(id: "pb-thai-d3-a2", time: "9:00 AM", title: "Summit of Thailand hike", description: "Doi Inthanon at 2565m — bring a warm layer. The royal twin pagodas and cloud forest are surreal.", type: .activity, estimatedCost: 3),
                            PlaybookActivity(id: "pb-thai-d3-a3", time: "1:00 PM", title: "Karen hilltribe village visit", description: "Ask your guesthouse to arrange an ethical village visit with a local guide (not tour bus packages).", type: .activity, estimatedCost: 12),
                            PlaybookActivity(id: "pb-thai-d3-a4", time: "6:00 PM", title: "Khao Soi at SP Khao Soi", description: "The best Khao Soi in Chiang Mai according to locals. Two bowls for 60 baht. Cash only.", type: .food, estimatedCost: 2)
                        ]
                    )
                ],
                tips: [
                    PlaybookTip(id: "pb-thai-t1", category: .money, text: "Always pay in Thai baht, never in foreign currency — 'dynamic currency conversion' at ATMs costs you 3–5%.", upvotes: 374),
                    PlaybookTip(id: "pb-thai-t2", category: .transport, text: "Grab app works in all major cities. Tuk-tuks are fun but always agree on a price before you get in.", upvotes: 256),
                    PlaybookTip(id: "pb-thai-t3", category: .food, text: "Street food from busy stalls with high turnover is safer than tourist restaurants. Locals eating = good sign.", upvotes: 498),
                    PlaybookTip(id: "pb-thai-t4", category: .local, text: "Remove shoes before entering homes and temples. Always greet with a wai (hands pressed together, slight bow).", upvotes: 312),
                    PlaybookTip(id: "pb-thai-t5", category: .safety, text: "Buy a DTAC or TrueMove SIM at the airport for $10 — includes 15GB data for 30 days.", upvotes: 441)
                ],
                budgetMin: 25,
                budgetMax: 45,
                bestTimeToVisit: "November–February (cool & dry)",
                packingList: ["Lightweight quick-dry clothes", "Long pants/skirt for temples", "Flip flops + sturdy sneakers", "Stomach meds & electrolytes", "Insect repellent", "Small padlock for hostel lockers", "Earplugs", "Reef-safe sunscreen", "Reusable bag (plastic banned)", "Phrasebook: basic Thai phrases"],
                rating: 4.6,
                ratingCount: 289,
                forkCount: 63,
                viewCount: 5870,
                createdAt: cal.date(byAdding: .month, value: -6, to: now)!,
                lastUpdated: cal.date(byAdding: .day, value: -21, to: now)!,
                tags: ["budget", "food", "adventure", "culture", "beach"]
            ),

            Playbook(
                id: "pb-japan-cultural",
                title: "14 Days Japan: Deep Cultural Immersion",
                destination: "Japan",
                coverImageURL: "https://images.unsplash.com/photo-1512453979798-f4d97b9b6b22?w=800&q=80",
                authorName: "Kenji Watanabe",
                authorInitials: "KW",
                authorIsVerified: true,
                tripType: .cultural,
                duration: 14,
                days: [
                    PlaybookDay(
                        id: "pb-japan-d1",
                        dayNumber: 1,
                        title: "Tokyo Arrival & Shinjuku",
                        activities: [
                            PlaybookActivity(id: "pb-japan-d1-a1", time: "3:00 PM", title: "Narita Express to Shinjuku", description: "Buy the N'EX Tokyo Round Trip ticket (¥4,070) at the airport JR office — it saves ¥2,000 vs full price.", type: .transport, estimatedCost: 28),
                            PlaybookActivity(id: "pb-japan-d1-a2", time: "5:00 PM", title: "Check in & Suica card top-up", description: "Get a Suica card at any JR machine for trains, buses, convenience stores, and vending machines.", type: .tip, estimatedCost: 0),
                            PlaybookActivity(id: "pb-japan-d1-a3", time: "6:30 PM", title: "Omoide Yokocho (Memory Lane)", description: "Tiny alley of yakitori stalls behind Shinjuku station. Order chicken skewers and draft beer standing — pure Tokyo.", type: .food, estimatedCost: 18),
                            PlaybookActivity(id: "pb-japan-d1-a4", time: "9:00 PM", title: "Tokyo Metropolitan Government Building", description: "Free observation deck open until 10:30pm. The best free night view in Tokyo — 360-degree panorama at 202m.", type: .activity, estimatedCost: 0)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-japan-d2",
                        dayNumber: 2,
                        title: "Asakusa, Akihabara & Shibuya",
                        activities: [
                            PlaybookActivity(id: "pb-japan-d2-a1", time: "8:00 AM", title: "Senso-ji Temple morning visit", description: "Arrive at dawn before the market stalls open. The Nakamise shopping street is alive by 9am — try ningyo-yaki cakes.", type: .activity, estimatedCost: 0),
                            PlaybookActivity(id: "pb-japan-d2-a2", time: "11:00 AM", title: "Akihabara electronics & anime", description: "Even if not into anime — the multi-floor electronics stores are extraordinary. Yodobashi Camera has 8 floors.", type: .activity, estimatedCost: 20),
                            PlaybookActivity(id: "pb-japan-d2-a3", time: "2:00 PM", title: "Ramen at Fuunji", description: "Tsukemen (dipping ramen) masters in Shinjuku. Queue forms early. Worth the 20-min wait.", type: .food, estimatedCost: 12),
                            PlaybookActivity(id: "pb-japan-d2-a4", time: "6:00 PM", title: "Shibuya Scramble & Sky view", description: "Watch the famous crossing from Starbucks above or the new Shibuya Sky observation deck at sunset.", type: .activity, estimatedCost: 18)
                        ]
                    ),
                    PlaybookDay(
                        id: "pb-japan-d3",
                        dayNumber: 3,
                        title: "Kyoto Arrival & Geisha District",
                        activities: [
                            PlaybookActivity(id: "pb-japan-d3-a1", time: "9:00 AM", title: "Shinkansen Tokyo → Kyoto", description: "Book the Hikari (slightly slower than Nozomi) — JR Pass holders save ¥14,000 one-way.", type: .transport, estimatedCost: 0),
                            PlaybookActivity(id: "pb-japan-d3-a2", time: "12:30 PM", title: "Nishiki Market lunch walk", description: "Kyoto's 'kitchen' — a 400m covered market with samples of pickles, tofu, dango, and fresh fish. Graze your way through.", type: .food, estimatedCost: 10),
                            PlaybookActivity(id: "pb-japan-d3-a3", time: "4:00 PM", title: "Gion Hanamikoji twilight walk", description: "Best time to spot maiko (apprentice geisha). Walk slowly, stay quiet, and never block their path for photos.", type: .activity, estimatedCost: 0),
                            PlaybookActivity(id: "pb-japan-d3-a4", time: "7:30 PM", title: "Kappo dinner at Tankuma", description: "Counter kappo dining where you watch the chef. Book weeks ahead. The ¥12,000 menu showcases seasonal kaiseki.", type: .food, estimatedCost: 85)
                        ]
                    )
                ],
                tips: [
                    PlaybookTip(id: "pb-japan-t1", category: .transport, text: "The 21-day JR Pass (¥70,000) pays for itself if you do Tokyo–Kyoto–Hiroshima–Osaka. Buy it outside Japan.", upvotes: 592),
                    PlaybookTip(id: "pb-japan-t2", category: .local, text: "Never eat or drink while walking. Always bow when thanked. Avoid loud phone calls on trains.", upvotes: 483),
                    PlaybookTip(id: "pb-japan-t3", category: .money, text: "Japan is still mostly cash. 7-Eleven ATMs accept foreign cards and charge the lowest fees.", upvotes: 671),
                    PlaybookTip(id: "pb-japan-t4", category: .food, text: "Convenience store food (7-Eleven, Lawson, FamilyMart) is genuinely excellent — onigiri, sandwiches, hot foods.", upvotes: 748),
                    PlaybookTip(id: "pb-japan-t5", category: .packing, text: "Bring a small towel — many public restrooms lack hand dryers and paper towels. Pocket-size versions are sold everywhere.", upvotes: 334)
                ],
                budgetMin: 120,
                budgetMax: 220,
                bestTimeToVisit: "March–April (cherry blossom) or October–November (autumn leaves)",
                packingList: ["JR Pass (buy before departure)", "IC card (Suica/Pasmo) holder", "Pocket WiFi or SIM (rent at airport)", "Coin purse (lots of coins)", "Slip-on shoes (remove at restaurants/ryokan)", "Conservative clothing for temples", "Chopsticks etiquette card", "Translation app offline maps", "Portable battery pack", "Small backpack (lockers in train stations)", "Cash ¥50,000+ for first days"],
                rating: 4.9,
                ratingCount: 704,
                forkCount: 219,
                viewCount: 14300,
                createdAt: cal.date(byAdding: .month, value: -18, to: now)!,
                lastUpdated: cal.date(byAdding: .day, value: -3, to: now)!,
                tags: ["culture", "food", "city", "adventure", "luxury"]
            )
        ]
    }
}
