import Foundation

// Multi-factor relevance ranker.
// Scoring weights: exact title > prefix > word match > location > description.
// Ties broken by rating (normalized to 0-1).
struct SearchRankingService {

    func rank(stays: [Stay], query: String) -> [Stay] {
        let q = query.lowercased()
        return stays
            .compactMap { stay -> (Stay, Double)? in
                let s = score(stay, query: q)
                return s > 0 ? (stay, s) : nil
            }
            .sorted { $0.1 > $1.1 }
            .map(\.0)
    }

    private func score(_ stay: Stay, query: String) -> Double {
        let title    = stay.title.lowercased()
        let location = stay.location.lowercased()
        let desc     = stay.description.lowercased()
        var s: Double = 0

        // --- Title scoring ---
        if title == query            { s += 10 }
        else if title.hasPrefix(query)  { s += 6 }
        else if title.contains(query)   { s += 4 }

        // --- Location scoring ---
        if location == query            { s += 8 }
        else if location.contains(query) { s += 3 }

        // --- Word-level scoring (partial token match) ---
        let qWords    = query.split(separator: " ").map(String.init)
        let titleWords    = Set(title.split(separator: " ").map(String.init))
        let locationWords = Set(location.split(separator: " ").map(String.init))

        for word in qWords {
            if titleWords.contains(where: { $0.hasPrefix(word) })    { s += 2.0 }
            if locationWords.contains(where: { $0.hasPrefix(word) }) { s += 1.5 }
            if desc.contains(word)                                    { s += 0.5 }
        }

        // --- Popularity boost (rating normalised, small weight) ---
        s += (stay.rating / 5.0) * 0.3

        return s
    }
}
