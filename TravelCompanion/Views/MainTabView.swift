import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppStateManager
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some View {
        TabView {
            HomeView(viewModel: homeViewModel)
                .tabItem { Label("Explore", systemImage: "house.fill") }

            TripsView()
                .tabItem { Label("Trips", systemImage: "airplane") }

            BudgetView()
                .tabItem { Label("Budget", systemImage: "wallet.pass.fill") }

            SquadsView()
                .tabItem { Label("Squads", systemImage: "person.3.fill") }

            PlaybooksView()
                .tabItem { Label("Playbooks", systemImage: "map.fill") }

            PointsView()
                .tabItem { Label("Rewards", systemImage: "star.circle.fill") }

            if let user = appState.currentUser {
                ProfileView(user: user)
                    .tabItem { Label("Profile", systemImage: "person.fill") }
            }
        }
        .tint(Color.accentRed)
        .environmentObject(homeViewModel)
    }
}

#Preview {
    MainTabView().environmentObject(AppStateManager())
}
