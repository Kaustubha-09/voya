import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    // Shared home VM so favorites can read the full loaded stays list
    @EnvironmentObject private var homeViewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favoriteStays.isEmpty {
                    emptyState
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Saved Stays")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.refresh(from: homeViewModel.allStays)
        }
    }

    // MARK: - List

    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.favoriteStays) { stay in
                    NavigationLink(value: stay) {
                        StayCardView(stay: stay)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation { viewModel.remove(stay: stay) }
                        } label: {
                            Label("Remove", systemImage: "heart.slash")
                        }
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .navigationDestination(for: Stay.self) { stay in
            DetailView(viewModel: DetailViewModel(stay: stay))
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.system(size: 56))
                .foregroundStyle(Color.accentRed.opacity(0.4))
            Text("No saved stays yet")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Tap the heart on any listing to save it here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(HomeViewModel())
}
