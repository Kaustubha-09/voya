import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showFilter = false

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    skeletonList
                case .success:
                    mainContent
                case .failure(let msg):
                    ErrorView(message: msg) { await viewModel.refresh() }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchInput,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search by city or listing")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    voyaTitle
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            .refreshable { await viewModel.refresh() }
            .sheet(isPresented: $showFilter) {
                FilterSheet(filter: $viewModel.filter)
            }
        }
        .task { await viewModel.loadStays() }
    }

    // MARK: - Main content (after load)

    private var mainContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {

                // Category chips always visible
                CategoryChipRow(selected: $viewModel.selectedCategory)
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                // Active filter summary
                if viewModel.filter.isActive {
                    filterSummaryPill
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }

                // Discovery sections shown only when not searching/filtering
                if !viewModel.isFiltering {
                    if !viewModel.trendingStays.isEmpty {
                        TrendingSection(stays: viewModel.trendingStays)
                            .padding(.top, 8)
                    }

                    seasonalTeaserSection
                        .padding(.top, 16)

                    nearMeSection
                        .padding(.top, 4)

                    if !viewModel.recentlyViewedStays.isEmpty {
                        RecentlyViewedSection(stays: viewModel.recentlyViewedStays)
                            .padding(.top, 16)
                    }

                    sectionDivider(title: viewModel.recentlyViewedStays.isEmpty ? "All Stays" : "All Listings")
                }

                if viewModel.filteredStays.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.filteredStays) { stay in
                        NavigationLink(value: stay) {
                            StayCardView(
                                stay: stay,
                                priceAnalysis: viewModel.priceAnalysis(for: stay),
                                distance: LocationService.shared.formattedDistance(to: stay.coordinates)
                            )
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Color.clear.frame(height: 20)
            }
        }
        .navigationDestination(for: Stay.self) { stay in
            DetailView(viewModel: DetailViewModel(stay: stay))
        }
        .scrollDismissesKeyboard(.immediately)
    }

    // MARK: - Skeleton

    private var skeletonList: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { _ in
                    SkeletonCardView().padding(.horizontal)
                }
            }
            .padding(.vertical, 12)
        }
    }

    // MARK: - Voya wordmark title

    private var voyaTitle: some View {
        HStack(spacing: 6) {
            VoyaLogoView(size: 22, showWordmark: false)
            Text("Voya")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentRed)
        }
    }

    // MARK: - Filter button with badge indicator

    private var filterButton: some View {
        Button {
            showFilter = true
            HapticService.trigger(.soft)
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.body)
                if viewModel.filter.isActive {
                    Circle()
                        .fill(Color.accentRed)
                        .frame(width: 8, height: 8)
                        .offset(x: 4, y: -4)
                }
            }
        }
    }

    // MARK: - Active filter pill

    private var filterSummaryPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .foregroundStyle(Color.accentRed)
            Text(filterSummaryText)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            Button("Clear") {
                viewModel.resetFilters()
                HapticService.trigger(.soft)
            }
            .font(.subheadline)
            .foregroundStyle(Color.accentRed)
        }
    }

    private var filterSummaryText: String {
        var parts: [String] = []
        if viewModel.filter.maxPrice < 600  { parts.append("≤$\(Int(viewModel.filter.maxPrice))/night") }
        if viewModel.filter.minRating > 0   { parts.append("★\(String(format: "%.1f", viewModel.filter.minRating))+") }
        return parts.joined(separator: " · ")
    }

    // MARK: - Section divider header

    private func sectionDivider(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Text("\(viewModel.filteredStays.count) stays")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }

    // MARK: - Seasonal teaser section

    private var seasonalTeaserSection: some View {
        let recs = SeasonalService.shared.featured(for: SeasonalService.currentMonth)
        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Best Time to Go")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Top picks for \(SeasonalService.monthName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                NavigationLink(destination: SeasonalView()) {
                    Text("See all")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentRed)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recs.prefix(4)) { rec in
                        NavigationLink(destination: SeasonalDetailView(rec: rec)) {
                            SeasonalTeaserCard(rec: rec)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
            }
        }
    }

    // MARK: - Near Me section

    @ViewBuilder
    private var nearMeSection: some View {
        let location = LocationService.shared
        if location.isDenied {
            EmptyView()
        } else if !location.isAuthorized {
            locationPermissionBanner
        } else if !viewModel.nearbyStays.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundStyle(Color.accentRed)
                        .font(.subheadline)
                    Text(location.currentCity.isEmpty ? "Near You" : "Near \(location.currentCity)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 12)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(viewModel.nearbyStays.prefix(6)) { stay in
                            NavigationLink(value: stay) {
                                NearbyStayCard(
                                    stay: stay,
                                    distance: location.formattedDistance(to: stay.coordinates)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                }
            }
        }
    }

    private var locationPermissionBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "location.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.accentRed)
            VStack(alignment: .leading, spacing: 2) {
                Text("See stays near you")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Allow location access for personalised suggestions")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button("Enable") {
                LocationService.shared.requestPermission()
                HapticService.trigger(.selection)
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.accentRed)
            .clipShape(Capsule())
        }
        .padding(14)
        .background(Color.accentRed.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
        .padding(.top, 12)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: viewModel.isFiltering ? "line.3.horizontal.decrease.circle" : "map.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color.accentRed.opacity(0.5))
            Text(viewModel.isFiltering ? "No stays match your filters" : "No stays available")
                .font(.title3)
                .fontWeight(.semibold)
            Text(viewModel.isFiltering ? "Try adjusting or clearing your filters." : "Pull to refresh.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if viewModel.isFiltering {
                Button("Reset All Filters") {
                    viewModel.resetFilters()
                    HapticService.trigger(.soft)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.accentRed)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }
}

private struct SeasonalTeaserCard: View {
    let rec: SeasonalRecommendation

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: rec.imageURL)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(Color(.systemGray5))
            }
            .frame(width: 180, height: 120)
            .clipped()
            .overlay(alignment: .topLeading) {
                Label(rec.season.rawValue, systemImage: rec.season.icon)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(rec.season.color.opacity(0.9))
                    .clipShape(Capsule())
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(rec.destination)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Text(rec.country)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Spacer()
                    Label(rec.priceTier.rawValue, systemImage: rec.priceTier.icon)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(rec.priceTier.color)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .frame(width: 180)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 6, x: 0, y: 3)
    }
}

private struct NearbyStayCard: View {
    let stay: Stay
    let distance: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncCachedImage(urlString: stay.imageURL)
                .frame(width: 200, height: 130)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    if let dist = distance {
                        HStack(spacing: 3) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 9))
                            Text(dist)
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.55))
                        .clipShape(Capsule())
                        .padding(8)
                    }
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(stay.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", stay.rating))
                        .font(.caption)
                        .fontWeight(.medium)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text("$\(Int(stay.pricePerNight))/night")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .frame(width: 200)
        .cardStyle()
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
