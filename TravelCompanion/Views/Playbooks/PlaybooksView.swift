import SwiftUI

struct PlaybooksView: View {
    @StateObject private var vm = PlaybookViewModel()
    @ObservedObject private var store = PlaybookStore.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    tripTypeFilterRow
                        .padding(.top, 8)
                    durationFilterRow
                        .padding(.top, 4)
                        .padding(.bottom, 8)

                    if !store.featured.isEmpty && vm.searchText.isEmpty && vm.selectedTripType == nil && vm.selectedDuration == nil {
                        featuredSection
                            .padding(.top, 4)
                        sectionHeader(title: "All Playbooks", count: vm.filteredPlaybooks.count)
                    }

                    if vm.filteredPlaybooks.isEmpty {
                        emptyState
                    } else {
                        ForEach(vm.filteredPlaybooks) { playbook in
                            NavigationLink(destination: PlaybookDetailView(playbook: playbook)) {
                                PlaybookRowCard(playbook: playbook)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 14)
                            }
                            .buttonStyle(.plain)
                        }
                        Color.clear.frame(height: 20)
                    }
                }
            }
            .navigationTitle("Playbooks")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $vm.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search destination or guide title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.showCreate = true
                        HapticService.trigger(.soft)
                    } label: {
                        Image(systemName: "plus")
                            .font(.body.weight(.semibold))
                    }
                }
            }
            .sheet(isPresented: $vm.showCreate) {
                CreatePlaybookView(vm: vm)
            }
        }
    }

    private var tripTypeFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All", icon: "square.grid.2x2.fill", isSelected: vm.selectedTripType == nil) {
                    vm.selectedTripType = nil
                    HapticService.trigger(.selection)
                }
                ForEach(Playbook.TripType.allCases) { type in
                    FilterChip(label: type.label, icon: type.icon, isSelected: vm.selectedTripType == type) {
                        vm.selectedTripType = (vm.selectedTripType == type) ? nil : type
                        HapticService.trigger(.selection)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var durationFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                DurationChip(label: "Any Length", isSelected: vm.selectedDuration == nil) {
                    vm.selectedDuration = nil
                    HapticService.trigger(.selection)
                }
                DurationChip(label: "1–3 days", isSelected: vm.selectedDuration == 3) {
                    vm.selectedDuration = (vm.selectedDuration == 3) ? nil : 3
                    HapticService.trigger(.selection)
                }
                DurationChip(label: "4–7 days", isSelected: vm.selectedDuration == 5) {
                    vm.selectedDuration = (vm.selectedDuration == 5) ? nil : 5
                    HapticService.trigger(.selection)
                }
                DurationChip(label: "8–14 days", isSelected: vm.selectedDuration == 10) {
                    vm.selectedDuration = (vm.selectedDuration == 10) ? nil : 10
                    HapticService.trigger(.selection)
                }
                DurationChip(label: "14+ days", isSelected: vm.selectedDuration == 14) {
                    vm.selectedDuration = (vm.selectedDuration == 14) ? nil : 14
                    HapticService.trigger(.selection)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Guides")
                .font(.title3.bold())
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(store.featured) { playbook in
                        NavigationLink(destination: PlaybookDetailView(playbook: playbook)) {
                            FeaturedPlaybookCard(playbook: playbook)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
        }
        .padding(.bottom, 8)
    }

    private func sectionHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.title3.bold())
            Spacer()
            Text("\(count) guides")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "map.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color.accentRed.opacity(0.5))
            Text("No playbooks found")
                .font(.title3.weight(.semibold))
            Text("Try adjusting your search or filters.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
        .padding(.horizontal, 32)
    }
}

struct FeaturedPlaybookCard: View {
    let playbook: Playbook

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: playbook.coverImageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.subtleGray
            }
            .frame(width: 300, height: 200)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: playbook.tripType.icon)
                        .font(.caption2)
                    Text(playbook.tripType.label)
                        .font(.caption2.weight(.semibold))
                }
                .foregroundStyle(.white.opacity(0.85))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.white.opacity(0.2))
                .clipShape(Capsule())

                Text(playbook.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text(playbook.destination)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        Text(playbook.rating.starRating)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(12)
        }
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct PlaybookRowCard: View {
    let playbook: Playbook

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: playbook.coverImageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.subtleGray
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(playbook.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.fill")
                        .font(.caption2)
                        .foregroundStyle(Color.accentRed)
                    Text(playbook.destination)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 4) {
                    Text(playbook.authorLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 6) {
                    Label(playbook.tripType.label, systemImage: playbook.tripType.icon)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Color.accentRed)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.accentRed.opacity(0.1))
                        .clipShape(Capsule())

                    Text("\(playbook.duration)d")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.subtleGray)
                        .clipShape(Capsule())
                }

                HStack(spacing: 10) {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        Text(playbook.rating.starRating)
                            .font(.caption.weight(.semibold))
                    }
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.triangle.branch")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("\(playbook.forkCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    HStack(spacing: 3) {
                        Image(systemName: "eye.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(playbook.viewCount >= 1000 ? "\(String(format: "%.1fk", Double(playbook.viewCount) / 1000))" : "\(playbook.viewCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(playbook.budgetRange)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.accentRed)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct FilterChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(label)
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? Color.accentRed : Color.subtleGray)
            .clipShape(Capsule())
        }
    }
}

struct DurationChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(isSelected ? Color.accentRed : Color.subtleGray)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    PlaybooksView()
}
