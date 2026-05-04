import SwiftUI

struct RatingBadge: View {
    let rating: Double
    let reviewCount: Int?

    init(rating: Double, reviewCount: Int? = nil) {
        self.rating = rating
        self.reviewCount = reviewCount
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.caption)
            Text(rating.starRating)
                .font(.subheadline)
                .fontWeight(.semibold)
            if let count = reviewCount {
                Text("(\(count))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    RatingBadge(rating: 4.92, reviewCount: 134)
        .padding()
}
