import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Avatar circle with initials
                ZStack {
                    Circle()
                        .fill(Color.accentRed.opacity(0.15))
                    Text(review.authorInitials)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentRed)
                }
                .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.authorName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(review.date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                RatingBadge(rating: review.rating)
            }

            Text(review.comment)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    ReviewCard(review: MockData.reviews["1"]![0])
        .padding()
}
