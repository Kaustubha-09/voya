import SwiftUI

struct RecentlyViewedSection: View {
    let stays: [Stay]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Viewed")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(stays) { stay in
                        NavigationLink(value: stay) {
                            RecentlyViewedCard(stay: stay)
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

struct RecentlyViewedCard: View {
    let stay: Stay

    var body: some View {
        HStack(spacing: 10) {
            AsyncCachedImage(urlString: stay.imageURL)
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .clipped()

            VStack(alignment: .leading, spacing: 3) {
                Text(stay.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(stay.location)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                RatingBadge(rating: stay.rating)
                    .scaleEffect(0.85, anchor: .leading)
            }
            .frame(width: 110, alignment: .leading)
        }
        .padding(8)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        RecentlyViewedSection(stays: Array(MockData.stays.prefix(3)))
    }
}
