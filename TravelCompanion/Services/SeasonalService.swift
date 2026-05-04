import Foundation

struct SeasonalService {
    static let shared = SeasonalService()

    var all: [SeasonalRecommendation] { SeasonalDataStore.all }

    func recommendations(for month: Int) -> [SeasonalRecommendation] {
        all.filter { $0.months.contains(month) }
    }

    func recommendations(for season: SeasonalRecommendation.Season) -> [SeasonalRecommendation] {
        all.filter { $0.season == season }
    }

    func recommendations(for style: SeasonalRecommendation.TripStyle) -> [SeasonalRecommendation] {
        all.filter { $0.bestFor.contains(style) }
    }

    func featured(for month: Int) -> [SeasonalRecommendation] {
        recommendations(for: month)
            .filter { $0.priceTier != .expensive || $0.crowdLevel != .veryBusy }
            .prefix(6)
            .map { $0 }
    }

    static var currentMonth: Int {
        Calendar.current.component(.month, from: Date())
    }

    static var monthName: String {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df.string(from: Date())
    }
}
