import SwiftUI

struct SeasonalDetailView: View {
    let rec: SeasonalRecommendation
    @Environment(\.dismiss) private var dismiss
    @State private var showAddedToast = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroSection
                contentSection
                    .padding(.horizontal)
                    .padding(.top, 20)

                addToTripButton
                    .padding(.horizontal)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(false)
        .overlay(alignment: .bottom) {
            if showAddedToast {
                toastView
                    .padding(.bottom, 90)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: rec.imageURL)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(Color(.systemGray4))
                    .overlay(
                        ProgressView().tint(.white)
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320)
            .clipped()

            LinearGradient(
                colors: [.clear, .clear, .black.opacity(0.8)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 320)

            VStack(alignment: .leading, spacing: 8) {
                Label(rec.season.rawValue, systemImage: rec.season.icon)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(rec.season.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())

                Text(rec.destination)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(rec.country)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            infoGrid
            highlightsSection
            if !rec.festivals.isEmpty {
                festivalsSection
            }
            tripStylesSection
            travelTipCard
        }
    }

    private var infoGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            infoCell(
                icon: "thermometer.medium",
                iconColor: .orange,
                title: "Weather",
                value: rec.weatherDescription,
                detail: rec.tempRange
            )
            infoCell(
                icon: rec.priceTier.icon,
                iconColor: rec.priceTier.color,
                title: "Price Level",
                value: rec.priceTier.rawValue,
                detail: nil
            )
            infoCell(
                icon: rec.crowdLevel.icon,
                iconColor: rec.crowdLevel.color,
                title: "Crowds",
                value: rec.crowdLevel.rawValue,
                detail: nil
            )
            infoCell(
                icon: "calendar",
                iconColor: Color.accentRed,
                title: "Best Months",
                value: bestMonthsText,
                detail: nil
            )
        }
    }

    private func infoCell(icon: String, iconColor: Color, title: String, value: String, detail: String?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(iconColor)
                    .frame(width: 20)
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.3)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            if let detail {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var highlightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Highlights")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 10) {
                ForEach(Array(rec.highlights.enumerated()), id: \.offset) { index, highlight in
                    HStack(alignment: .top, spacing: 14) {
                        Text("\(index + 1)")
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(.white)
                            .frame(width: 26, height: 26)
                            .background(Color.accentRed)
                            .clipShape(Circle())

                        Text(highlight)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }
                }
            }
        }
    }

    private var festivalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Festivals & Events", systemImage: "party.popper.fill")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            VStack(spacing: 10) {
                ForEach(rec.festivals) { festival in
                    HStack(alignment: .top, spacing: 12) {
                        VStack(spacing: 4) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.accentRed)
                            Text(monthAbbrev(festival.month))
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color.accentRed)
                        }
                        .frame(width: 40)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(festival.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(festival.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.accentRed.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
    }

    private var tripStylesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Great For")
                .font(.headline)
                .fontWeight(.bold)

            FlowLayout(spacing: 8) {
                ForEach(rec.bestFor, id: \.self) { style in
                    Text(style.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentRed.opacity(0.1))
                        .foregroundStyle(Color.accentRed)
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var travelTipCard: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 20))
                .foregroundStyle(.yellow)
                .padding(10)
                .background(Color.yellow.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("Travel Tip")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(rec.travelTip)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color.yellow.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.yellow.opacity(0.25), lineWidth: 1)
        )
    }

    private var addToTripButton: some View {
        Button {
            HapticService.trigger(.success)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showAddedToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation { showAddedToast = false }
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                Text("Add to Trip")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.accentRed)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.accentRed.opacity(0.35), radius: 10, x: 0, y: 5)
        }
    }

    private var toastView: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.title3)
            Text("\(rec.destination) added to your trip")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
    }

    private var bestMonthsText: String {
        let df = DateFormatter()
        df.dateFormat = "MMM"
        return rec.months.prefix(4).compactMap { m -> String? in
            var comps = DateComponents(); comps.month = m; comps.day = 1; comps.year = 2025
            guard let date = Calendar.current.date(from: comps) else { return nil }
            return df.string(from: date)
        }.joined(separator: ", ")
    }

    private func monthAbbrev(_ m: Int) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM"
        var comps = DateComponents(); comps.month = m; comps.day = 1; comps.year = 2025
        return df.string(from: Calendar.current.date(from: comps)!)
    }
}
