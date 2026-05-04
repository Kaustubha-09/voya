import SwiftUI

struct SeasonalCard: View {
    let rec: SeasonalRecommendation

    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(url: URL(string: rec.imageURL)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundStyle(Color(.systemGray3))
                    )
            }
            .frame(width: 100, height: 100)
            .clipped()
            .overlay(alignment: .topLeading) {
                Label(rec.season.rawValue, systemImage: rec.season.icon)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(rec.season.color.opacity(0.85))
                    .clipShape(Capsule())
                    .padding(6)
            }

            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(rec.destination)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(rec.country)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Text(rec.weatherDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Label(rec.priceTier.rawValue, systemImage: rec.priceTier.icon)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(rec.priceTier.color)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(rec.priceTier.color.opacity(0.12))
                        .clipShape(Capsule())

                    Label(rec.crowdLevel.rawValue, systemImage: rec.crowdLevel.icon)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(rec.crowdLevel.color)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(rec.crowdLevel.color.opacity(0.12))
                        .clipShape(Capsule())
                }

                if !rec.highlights.isEmpty {
                    HStack(spacing: 5) {
                        ForEach(rec.highlights.prefix(2), id: \.self) { highlight in
                            Text(highlight)
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 100)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}
