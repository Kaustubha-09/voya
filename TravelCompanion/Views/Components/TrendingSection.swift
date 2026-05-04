import SwiftUI

struct TrendingSection: View {
    let stays: [Stay]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Trending Now")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "flame.fill")
                    .foregroundStyle(Color.accentRed)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(stays) { stay in
                        NavigationLink(value: stay) {
                            TrendingCard(stay: stay)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 4)
    }
}

struct TrendingCard: View {
    let stay: Stay

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncCachedImage(urlString: stay.imageURL)
                .frame(width: 190, height: 130)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(stay.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(stay.location)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                HStack {
                    RatingBadge(rating: stay.rating)
                    Spacer()
                    Text("$\(Int(stay.pricePerNight))")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentRed)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .frame(width: 190)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 6, x: 0, y: 3)
    }
}

#Preview {
    NavigationStack {
        TrendingSection(stays: Array(MockData.stays.prefix(4)))
    }
}
