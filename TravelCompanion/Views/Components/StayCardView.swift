import SwiftUI

struct StayCardView: View {
    let stay: Stay
    var priceAnalysis: PriceAnalysis? = nil
    var distance: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero image
            AsyncCachedImage(urlString: stay.imageURL)
                .frame(height: 220)
                .clipped()
                .overlay(alignment: .topLeading) {
                    if let analysis = priceAnalysis, analysis.showBadge {
                        PriceBadge(analysis: analysis)
                            .padding(10)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if let dist = distance {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 9))
                            Text(dist)
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial.opacity(0.9))
                        .background(Color.black.opacity(0.4))
                        .clipShape(Capsule())
                        .padding(10)
                    }
                }

            // Card body
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(stay.title)
                            .font(.headline)
                            .lineLimit(1)
                        Text(stay.location)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    RatingBadge(rating: stay.rating)
                }

                HStack(spacing: 2) {
                    Text("$\(Int(stay.pricePerNight))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("/ night")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .cardStyle()
    }
}

#Preview {
    VStack {
        StayCardView(stay: MockData.stays[0],
                     priceAnalysis: PriceAnalysis(badge: .greatValue, percentDiff: -0.28))
        StayCardView(stay: MockData.stays[3],
                     priceAnalysis: PriceAnalysis(badge: .luxury, percentDiff: 0.45))
    }
    .padding()
}
