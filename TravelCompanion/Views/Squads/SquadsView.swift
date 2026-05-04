import SwiftUI

struct SquadsView: View {
    @StateObject private var vm = SquadViewModel()
    @ObservedObject private var store = SquadStore.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if !store.flashSquads.isEmpty {
                        flashBanner
                    }

                    Picker("", selection: $vm.selectedTab) {
                        Text("Discover").tag(0)
                        Text("My Squads").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)

                    if vm.selectedTab == 0 {
                        discoverTab
                    } else {
                        mySquadsTab
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Travel Squads")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HapticService.trigger(.selection)
                        vm.showCreateSquad = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $vm.showCreateSquad) {
                CreateSquadView(vm: vm)
            }
        }
    }

    private var flashBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption.bold())
                Text("Leaving Soon")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.flashSquads) { squad in
                        FlashSquadCard(squad: squad)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0.91, green: 0.19, blue: 0.31), Color(red: 0.7, green: 0.1, blue: 0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var discoverTab: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                        .padding(.leading, 10)
                    TextField("Search destination...", text: $vm.searchDestination)
                        .autocorrectionDisabled()
                }
                .padding(.vertical, 10)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(TravelSquad.TravelStyle.allCases) { style in
                            StyleFilterChip(style: style, isSelected: vm.selectedStyle == style) {
                                HapticService.trigger(.selection)
                                vm.selectedStyle = vm.selectedStyle == style ? nil : style
                            }
                        }
                        WomenOnlyChip(isOn: $vm.womenOnlyFilter)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 4)

            if vm.filteredDiscover.isEmpty {
                emptyDiscoverState
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(vm.filteredDiscover) { squad in
                        NavigationLink(destination: SquadDetailView(squad: squad)) {
                            SquadCardView(squad: squad)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
    }

    private var mySquadsTab: some View {
        VStack(spacing: 0) {
            if store.mySquads.isEmpty {
                emptyMySquadsState
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(store.mySquads) { squad in
                        NavigationLink(destination: SquadDetailView(squad: squad)) {
                            MySquadRow(squad: squad)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
    }

    private var emptyDiscoverState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("No squads match your filters")
                .font(.headline)
            Text("Try adjusting your search or filters")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Clear Filters") {
                vm.searchDestination = ""
                vm.selectedStyle = nil
                vm.womenOnlyFilter = false
            }
            .buttonStyle(.bordered)
            .tint(.accentRed)
        }
        .padding(40)
    }

    private var emptyMySquadsState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("No squads yet")
                .font(.headline)
            Text("Discover and join a squad, or create your own adventure.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Discover Squads") {
                vm.selectedTab = 0
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentRed)
        }
        .padding(40)
    }
}

private struct FlashSquadCard: View {
    let squad: TravelSquad
    @State private var joined = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(squad.destination)
                .font(.subheadline.bold())
                .foregroundStyle(.white)
            Text(squad.dateRange)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
            Text("\(squad.spotsLeft) spot\(squad.spotsLeft == 1 ? "" : "s") left")
                .font(.caption.bold())
                .foregroundStyle(.yellow)
            Button {
                HapticService.trigger(.success)
                SquadStore.shared.join(id: squad.id)
                joined = true
            } label: {
                Text(joined ? "Joined ✓" : "Join Now")
                    .font(.caption.bold())
                    .foregroundStyle(joined ? Color(red: 0.91, green: 0.19, blue: 0.31) : .white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(joined ? Color.white : Color.white.opacity(0.2))
                    .clipShape(Capsule())
            }
            .disabled(joined)
        }
        .padding(14)
        .background(Color.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .frame(width: 180)
    }
}

private struct StyleFilterChip: View {
    let style: TravelSquad.TravelStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: style.icon)
                    .font(.caption)
                Text(style.label)
                    .font(.caption.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? style.color : Color(UIColor.systemBackground))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isSelected ? style.color : Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

private struct WomenOnlyChip: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            HapticService.trigger(.selection)
            isOn.toggle()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: isOn ? "checkmark" : "person.fill")
                    .font(.caption)
                Text("Women Only")
                    .font(.caption.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isOn ? Color.pink : Color(UIColor.systemBackground))
            .foregroundStyle(isOn ? .white : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isOn ? Color.pink : Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

private struct MySquadRow: View {
    let squad: TravelSquad

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(squad.travelStyle.color.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: squad.travelStyle.icon)
                    .foregroundStyle(squad.travelStyle.color)
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(squad.name)
                        .font(.subheadline.bold())
                    Spacer()
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
                Text(squad.destination)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text(squad.dateRange)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\(squad.members.count) members")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(
            Divider().padding(.leading, 76),
            alignment: .bottom
        )
    }
}

#Preview {
    SquadsView()
}
