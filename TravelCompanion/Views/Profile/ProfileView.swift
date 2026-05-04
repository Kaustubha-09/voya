import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
    @EnvironmentObject private var appState: AppStateManager
    @StateObject private var vm: ProfileViewModel

    @AppStorage("theme_preference") private var themePreference: String = "system"
    @State private var showComingSoon = false
    @State private var comingSoonTitle = ""

    init(user: User) {
        _vm = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    coverAndAvatarHeader
                    profileInfoSection
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    statsRow
                        .padding(.top, 20)
                    highlightsRow
                        .padding(.top, 24)
                    achievementsSection
                        .padding(.top, 24)
                    recentTripsGrid
                        .padding(.top, 24)
                    settingsSection
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                    Color.clear.frame(height: 40)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HapticService.trigger(.selection)
                        vm.startEditing()
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(Color.accentRed)
                    }
                }
            }
            .sheet(isPresented: $vm.isEditing) {
                EditProfileView(vm: vm).environmentObject(appState)
            }
            .sheet(isPresented: $showComingSoon) {
                comingSoonSheet
            }
            .alert("Sign Out", isPresented: $vm.showSignOutAlert) {
                Button("Sign Out", role: .destructive) {
                    HapticService.trigger(.soft)
                    appState.signOut()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }

    // MARK: - Cover + Avatar Header

    private var coverAndAvatarHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Cover photo gradient banner
            AppTheme.Colors.navyGradient
                .frame(height: 140)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        HapticService.trigger(.selection)
                    } label: {
                        Image(systemName: "camera.fill")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.45))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 12)
                    .padding(.bottom, 12)
                }

            // Avatar circle overlapping cover by ~30pt
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    LinearGradient(
                        colors: [Color.accentRed, Color.accentRed.opacity(0.65)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(Circle())
                    Text(vm.user.initials)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .frame(width: 80, height: 80)
                .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 3))

                // Verified badge
                if vm.user.isIDVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.accentRed)
                        .background(
                            Circle()
                                .fill(Color(UIColor.systemBackground))
                                .padding(-2)
                        )
                        .offset(x: 2, y: 2)
                }

                // Camera overlay button
                Button {
                    HapticService.trigger(.selection)
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(Color.accentRed)
                        .clipShape(Circle())
                }
                .offset(x: -2, y: -22)
            }
            .padding(.leading, 16)
            .offset(y: 30)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 30) // room for avatar overlap
    }

    // MARK: - Profile Info Section

    private var profileInfoSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Name row
            HStack(spacing: 6) {
                Text(vm.user.fullName)
                    .font(.title3)
                    .fontWeight(.bold)
                if vm.user.isIDVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color.accentRed)
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    HapticService.trigger(.selection)
                    vm.startEditing()
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Color.accentRed)
                }
            }

            // Bio
            Button {
                HapticService.trigger(.selection)
                vm.startEditing()
            } label: {
                Text(vm.user.bio.isEmpty ? "Add a bio..." : vm.user.bio)
                    .font(.subheadline)
                    .italic()
                    .foregroundStyle(vm.user.bio.isEmpty ? Color.secondary : Color.primary)
                    .multilineTextAlignment(.leading)
            }
            .buttonStyle(.plain)

            // Location (placeholder since User doesn't have location — show member since)
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Member since \(vm.user.memberSinceYear)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Social handle
            HStack(spacing: 4) {
                Image(systemName: "at")
                    .font(.caption)
                    .foregroundStyle(Color.accentRed)
                Text(vm.user.firstName.lowercased() + vm.user.lastName.lowercased())
                    .font(.caption)
                    .foregroundStyle(Color.accentRed)
            }
        }
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 0) {
            statColumn(value: "12", label: "Trips") {
                comingSoonTitle = "Trips"
                showComingSoon = true
            }
            statDivider
            statColumn(value: "8", label: "Countries") {
                comingSoonTitle = "Countries"
                showComingSoon = true
            }
            statDivider
            statColumn(value: "234", label: "Followers") {
                comingSoonTitle = "Followers"
                showComingSoon = true
            }
            statDivider
            statColumn(value: "89", label: "Following") {
                comingSoonTitle = "Following"
                showComingSoon = true
            }
        }
        .padding(.vertical, 14)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .cardShadow, radius: 6, x: 0, y: 3)
        .padding(.horizontal, 16)
    }

    private func statColumn(value: String, label: String, action: @escaping () -> Void) -> some View {
        Button {
            HapticService.trigger(.selection)
            action()
        } label: {
            VStack(spacing: 3) {
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primary)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var statDivider: some View {
        Rectangle()
            .fill(Color(UIColor.separator))
            .frame(width: 1, height: 36)
    }

    // MARK: - Highlights Row

    private let mockHighlights: [(label: String, gradient: [Color])] = [
        ("Europe 🇪🇺", [Color(red: 0.18, green: 0.36, blue: 0.90), Color(red: 0.06, green: 0.10, blue: 0.18)]),
        ("Bali 🌴",    [Color(red: 0.06, green: 0.72, blue: 0.51), Color(red: 0.03, green: 0.42, blue: 0.30)]),
        ("Japan 🗾",   [Color(red: 0.91, green: 0.19, blue: 0.31), Color(red: 0.62, green: 0.08, blue: 0.18)]),
        ("Food 🍜",    [Color(red: 0.95, green: 0.62, blue: 0.07), Color(red: 0.80, green: 0.40, blue: 0.05)])
    ]

    private var highlightsRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Travel Stories")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // "Add" circle
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color.accentRed, Color.accentRed.opacity(0.7)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ))
                                .frame(width: 64, height: 64)
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        Text("Add")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .onTapGesture { HapticService.trigger(.selection) }

                    // Mock highlights
                    ForEach(mockHighlights, id: \.label) { h in
                        VStack(spacing: 6) {
                            Circle()
                                .fill(LinearGradient(
                                    colors: h.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.accentRed, Color(red: 1.0, green: 0.80, blue: 0.18)],
                                                startPoint: .topLeading, endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2.5
                                        )
                                        .padding(-3)
                                )
                                .overlay(
                                    Text(String(h.label.unicodeScalars
                                        .filter { $0.properties.isEmoji }
                                        .map { String($0) }
                                        .joined()))
                                        .font(.title3)
                                )
                            Text(h.label.components(separatedBy: " ").first ?? h.label)
                                .font(.caption)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                        .onTapGesture {
                            HapticService.trigger(.selection)
                            comingSoonTitle = h.label
                            showComingSoon = true
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
        }
    }

    // MARK: - Achievements Section

    private struct Achievement {
        let name: String
        let icon: String
        let color: Color
    }

    private let achievements: [Achievement] = [
        Achievement(name: "First Trip",    icon: "airplane.fill",     color: Color(red: 1.0, green: 0.80, blue: 0.18)),
        Achievement(name: "Explorer",      icon: "figure.hiking",     color: Color(red: 0.18, green: 0.50, blue: 0.90)),
        Achievement(name: "Foodie",        icon: "fork.knife",        color: Color(red: 0.95, green: 0.50, blue: 0.10)),
        Achievement(name: "Photographer",  icon: "camera.fill",       color: Color(red: 0.55, green: 0.25, blue: 0.85)),
        Achievement(name: "Early Bird",    icon: "sun.horizon.fill",  color: Color(red: 0.95, green: 0.78, blue: 0.10)),
        Achievement(name: "Squad Leader",  icon: "person.3.fill",     color: Color(red: 0.91, green: 0.19, blue: 0.31))
    ]

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Achievements")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(achievements.count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color.accentRed)
                    .clipShape(Capsule())
                Spacer()
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(achievements, id: \.name) { badge in
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(badge.color.opacity(0.18))
                                    .frame(width: 52, height: 52)
                                Circle()
                                    .stroke(badge.color.opacity(0.35), lineWidth: 1.5)
                                    .frame(width: 52, height: 52)
                                Image(systemName: badge.icon)
                                    .font(.system(size: 22))
                                    .foregroundStyle(badge.color)
                            }
                            Text(badge.name)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(width: 56)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
        }
    }

    // MARK: - Recent Trips Grid

    private struct MockTrip: Identifiable {
        let id = UUID()
        let destination: String
        let date: String
        let colors: [Color]
    }

    private let mockTrips: [MockTrip] = [
        MockTrip(destination: "Tokyo, Japan",      date: "Mar 2024",
                 colors: [Color(red: 0.91, green: 0.19, blue: 0.31), Color(red: 0.62, green: 0.08, blue: 0.18)]),
        MockTrip(destination: "Bali, Indonesia",   date: "Nov 2023",
                 colors: [Color(red: 0.06, green: 0.72, blue: 0.51), Color(red: 0.03, green: 0.42, blue: 0.30)]),
        MockTrip(destination: "Paris, France",     date: "Aug 2023",
                 colors: [Color(red: 0.18, green: 0.36, blue: 0.90), Color(red: 0.06, green: 0.10, blue: 0.18)]),
        MockTrip(destination: "New York, USA",     date: "Jun 2023",
                 colors: [Color(red: 0.55, green: 0.25, blue: 0.85), Color(red: 0.25, green: 0.10, blue: 0.55)])
    ]

    private var recentTripsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Trips")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    HapticService.trigger(.selection)
                    comingSoonTitle = "All Trips"
                    showComingSoon = true
                } label: {
                    Text("See All")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentRed)
                }
            }
            .padding(.horizontal, 16)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(mockTrips) { trip in
                    tripCard(trip: trip)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func tripCard(trip: MockTrip) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            LinearGradient(colors: trip.colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 100)
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "airplane")
                        .font(.system(size: 28))
                        .foregroundStyle(.white.opacity(0.3))
                        .padding(10)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(trip.destination)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(trip.date)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
            .padding(.top, 6)
        }
        .onTapGesture {
            HapticService.trigger(.selection)
            comingSoonTitle = trip.destination
            showComingSoon = true
        }
    }

    // MARK: - Settings Section

    private var settingsSection: some View {
        VStack(spacing: 12) {
            // Account
            settingsCard(title: "Account") {
                settingsRow(icon: "person.crop.circle", label: "Edit Profile", color: Color.accentRed) {
                    HapticService.trigger(.selection)
                    vm.startEditing()
                }
                Divider().padding(.leading, 44)
                NavigationLink {
                    NotificationSettingsView()
                } label: {
                    settingsRowLabel(icon: "bell.fill", label: "Notifications", color: .orange)
                }
                .buttonStyle(.plain)
                Divider().padding(.leading, 44)
                NavigationLink {
                    PaymentMethodsView()
                } label: {
                    settingsRowLabel(icon: "creditcard.fill", label: "Payment Methods", color: .green)
                }
                .buttonStyle(.plain)
            }

            // Security
            settingsCard(title: "Security") {
                NavigationLink {
                    SecuritySettingsView().environmentObject(appState)
                } label: {
                    settingsRowLabel(icon: "shield.fill", label: "Security Settings", color: Color(red: 0.18, green: 0.36, blue: 0.90))
                }
                .buttonStyle(.plain)
            }

            // Appearance
            appearanceCard

            // Support
            settingsCard(title: "Support") {
                NavigationLink {
                    HelpView()
                } label: {
                    settingsRowLabel(icon: "questionmark.circle.fill", label: "Help & Support", color: Color(red: 0.55, green: 0.25, blue: 0.85))
                }
                .buttonStyle(.plain)
                Divider().padding(.leading, 44)
                HStack {
                    settingsRowLabel(icon: "info.circle.fill", label: "App Version", color: .gray)
                    Spacer()
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 4)
                }
            }

            // Sign Out
            Button(role: .destructive) {
                HapticService.trigger(.soft)
                vm.showSignOutAlert = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.body)
                    Text("Sign Out")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.accentRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.accentRed.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }

    // Card container for settings groups
    private func settingsCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.bottom, 6)

            VStack(spacing: 0) {
                content()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
        }
    }

    // Row label reuse helper
    private func settingsRowLabel(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(color)
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
            }
            Text(label)
                .font(.body)
                .foregroundStyle(Color.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 10)
    }

    // Row with an action closure (non-navigation)
    private func settingsRow(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            settingsRowLabel(icon: icon, label: label, color: color)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Appearance Card

    private var appearanceCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Appearance")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.bottom, 6)

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(Color(red: 0.18, green: 0.18, blue: 0.22))
                            .frame(width: 30, height: 30)
                        Image(systemName: themePreference == "dark" ? "moon.fill" : (themePreference == "light" ? "sun.max.fill" : "circle.lefthalf.filled"))
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                    Text("Theme")
                        .font(.body)
                    Spacer()
                }
                .padding(.vertical, 10)

                Picker("Theme", selection: $themePreference) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 10)
                .onChange(of: themePreference) { _, newValue in
                    HapticService.trigger(.selection)
                    applyTheme(newValue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
        }
    }

    private func applyTheme(_ value: String) {
        let style: UIUserInterfaceStyle
        switch value {
        case "light":  style = .light
        case "dark":   style = .dark
        default:       style = .unspecified
        }
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = style }
    }

    // MARK: - Coming Soon Sheet

    private var comingSoonSheet: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 12)
            Spacer()
            Image(systemName: "clock.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.accentRed.opacity(0.7))
            Text(comingSoonTitle)
                .font(.title3)
                .fontWeight(.bold)
            Text("Coming soon")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    ProfileView(user: .placeholder).environmentObject(AppStateManager())
}
