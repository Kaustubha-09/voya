import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () async -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 52))
                .foregroundStyle(.orange)

            Text("Something went wrong")
                .font(.title3)
                .fontWeight(.semibold)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                Task { await retryAction() }
            } label: {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.accentRed)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView(message: "The server could not be reached.") { }
}
