import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0
    @State private var taglineOpacity: Double = 0

    var body: some View {
        ZStack {
            AppTheme.Colors.navyGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VoyaLogoView(size: 120, showWordmark: true)
                    .scaleEffect(scale)
                    .opacity(opacity)

                Spacer().frame(height: 20)

                Text("Find your next adventure")
                    .font(AppTheme.Fonts.subheadline())
                    .foregroundStyle(.white.opacity(0.60))
                    .opacity(taglineOpacity)

                Spacer()

                Text("Travel Companion")
                    .font(AppTheme.Fonts.caption())
                    .foregroundStyle(.white.opacity(0.25))
                    .padding(.bottom, 48)
                    .opacity(taglineOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.72)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.4)) {
                taglineOpacity = 1.0
            }
        }
    }
}

#Preview { SplashView() }
