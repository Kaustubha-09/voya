import SwiftUI

private struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
}

private let pages: [OnboardingPage] = [
    OnboardingPage(
        icon: "safari.fill",
        title: "Discover Amazing Places",
        subtitle: "Browse thousands of unique stays handpicked from around the world — beaches, mountains, cities, and more.",
        gradient: [Color(red: 0.91, green: 0.19, blue: 0.31), Color(red: 0.95, green: 0.4, blue: 0.2)]
    ),
    OnboardingPage(
        icon: "shield.checkered",
        title: "Book with Confidence",
        subtitle: "Every listing is verified. Secure payments, instant confirmation, and 24/7 guest support have you covered.",
        gradient: [Color(red: 0.2, green: 0.5, blue: 0.9), Color(red: 0.1, green: 0.7, blue: 0.8)]
    ),
    OnboardingPage(
        icon: "map.fill",
        title: "Travel Your Way",
        subtitle: "Filter by location, price, and rating. Save favorites, track upcoming trips, and relive past adventures.",
        gradient: [Color(red: 0.15, green: 0.65, blue: 0.45), Color(red: 0.3, green: 0.8, blue: 0.3)]
    )
]

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppStateManager
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: pages[currentPage].gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: currentPage)

            VStack(spacing: 0) {
                // Skip
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") { appState.completeOnboarding() }
                            .foregroundStyle(.white.opacity(0.8))
                            .padding()
                    }
                }

                Spacer()

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { i in
                        pageContent(pages[i]).tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 400)

                // Dots
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { i in
                        Capsule()
                            .fill(Color.white.opacity(i == currentPage ? 1 : 0.4))
                            .frame(width: i == currentPage ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 32)

                Spacer()

                // CTA
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        appState.completeOnboarding()
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(.white)
                        .foregroundStyle(pages[currentPage].gradient[0])
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }

    private func pageContent(_ page: OnboardingPage) -> some View {
        VStack(spacing: 24) {
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(.white)

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    OnboardingView().environmentObject(AppStateManager())
}
