import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.4)
                .tint(Color.accentRed)
            Text("Finding stays...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Skeleton card shown while loading
struct SkeletonCardView: View {
    @State private var animating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .frame(height: 220)
                .foregroundStyle(Color.subtleGray)

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 160, height: 16)
                    .foregroundStyle(Color.subtleGray)
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 110, height: 12)
                    .foregroundStyle(Color.subtleGray)
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 80, height: 14)
                    .foregroundStyle(Color.subtleGray)
            }
            .padding(14)
        }
        .cardStyle()
        .opacity(animating ? 0.5 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever()) {
                animating = true
            }
        }
    }
}

#Preview {
    SkeletonCardView().padding()
}
