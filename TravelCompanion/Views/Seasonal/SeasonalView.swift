import SwiftUI

struct SeasonalView: View {
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedSeason: SeasonalRecommendation.Season? = nil
    @State private var selectedStyle: SeasonalRecommendation.TripStyle? = nil

    private let service = SeasonalService.shared

    private var filteredRecs: [SeasonalRecommendation] {
        var base = service.recommendations(for: selectedMonth)
        if let s = selectedSeason { base = base.filter { $0.season == s } }
        if let st = selectedStyle { base = base.filter { $0.bestFor.contains(st) } }
        return base
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    monthSelector
                        .padding(.vertical, 12)

                    if let top = service.featured(for: selectedMonth).first {
                        NavigationLink(destination: SeasonalDetailView(rec: top)) {
                            heroCard(top)
                                .padding(.horizontal)
                                .padding(.bottom, 16)
                        }
                        .buttonStyle(.plain)
                    }

                    seasonFilterRow
                        .padding(.bottom, 8)

                    styleFilterRow
                        .padding(.bottom, 12)

                    if filteredRecs.isEmpty {
                        emptyState
                    } else {
                        ForEach(filteredRecs) { rec in
                            NavigationLink(destination: SeasonalDetailView(rec: rec)) {
                                SeasonalCard(rec: rec)
                                    .padding(.horizontal)
                                    .padding(.bottom, 14)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Color.clear.frame(height: 20)
                }
            }
            .navigationTitle("Best Time to Go")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var monthSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(1...12, id: \.self) { month in
                    let isSelected = month == selectedMonth
                    VStack(spacing: 4) {
                        Text(monthAbbrev(month))
                            .font(.caption)
                            .fontWeight(isSelected ? .bold : .regular)
                            .foregroundStyle(isSelected ? .white : .primary)
                        Text("\(service.recommendations(for: month).count)")
                            .font(.system(size: 10))
                            .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isSelected ? Color.accentRed : Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedMonth = month }
                        HapticService.trigger(.selection)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func heroCard(_ rec: SeasonalRecommendation) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: rec.imageURL)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(Color(.systemGray5))
            }
            .frame(height: 200)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.75)],
                startPoint: .top, endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Label(rec.season.rawValue, systemImage: rec.season.icon)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(rec.season.color)
                Text("\(rec.destination), \(rec.country)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text("Best in \(monthAbbrev(selectedMonth)) · \(rec.weatherDescription)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 6)
    }

    private var seasonFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip("All Seasons", icon: "globe", isSelected: selectedSeason == nil) {
                    selectedSeason = nil
                }
                ForEach(SeasonalRecommendation.Season.allCases, id: \.self) { s in
                    filterChip(s.rawValue, icon: s.icon, isSelected: selectedSeason == s) {
                        selectedSeason = selectedSeason == s ? nil : s
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var styleFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SeasonalRecommendation.TripStyle.allCases, id: \.self) { style in
                    filterChip(style.rawValue, icon: nil, isSelected: selectedStyle == style) {
                        selectedStyle = selectedStyle == style ? nil : style
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func filterChip(_ label: String, icon: String?, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: { action(); HapticService.trigger(.selection) }) {
            HStack(spacing: 5) {
                if let icon { Image(systemName: icon).font(.system(size: 11)) }
                Text(label).font(.caption).fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? Color.accentRed : Color(.systemGray6))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 52))
                .foregroundStyle(Color.accentRed.opacity(0.5))
            Text("No destinations match")
                .font(.title3).fontWeight(.semibold)
            Text("Try a different month or clear the filters")
                .font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    private func monthAbbrev(_ m: Int) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM"
        var comps = DateComponents(); comps.month = m; comps.day = 1; comps.year = 2025
        return df.string(from: Calendar.current.date(from: comps)!)
    }
}
