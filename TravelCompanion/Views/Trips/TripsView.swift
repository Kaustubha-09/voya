import SwiftUI

struct TripsView: View {
    @StateObject private var vm = TripsViewModel()
    @ObservedObject private var store = BookingStore.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segment control
                Picker("", selection: $vm.selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("Past").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 10)

                if vm.selectedTab == 0 {
                    upcomingContent
                } else {
                    pastContent
                }
            }
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Upcoming

    private var upcomingContent: some View {
        Group {
            if store.upcoming.isEmpty {
                emptyState(
                    icon: "airplane",
                    title: "No upcoming trips",
                    subtitle: "Your next adventure awaits — explore stays and book your first trip."
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(store.upcoming) { booking in
                            NavigationLink {
                                TripDetailView(booking: booking)
                            } label: {
                                BookingCard(booking: booking)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 12)
                }
            }
        }
    }

    // MARK: - Past

    private var pastContent: some View {
        Group {
            if store.past.isEmpty {
                emptyState(
                    icon: "clock.arrow.circlepath",
                    title: "No past trips",
                    subtitle: "Your completed and cancelled trips will appear here."
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(store.past) { booking in
                            NavigationLink {
                                TripDetailView(booking: booking)
                            } label: {
                                BookingCard(booking: booking)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 12)
                }
            }
        }
    }

    // MARK: - Empty state

    private func emptyState(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(Color.accentRed.opacity(0.4))
            Text(title).font(.title3).fontWeight(.semibold)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - Booking Card

struct BookingCard: View {
    let booking: Booking

    var body: some View {
        HStack(spacing: 0) {
            AsyncCachedImage(urlString: booking.stayImageURL)
                .frame(width: 100, height: 90)
                .clipped()

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    statusBadge
                    Spacer()
                    Text("#\(booking.confirmationCode)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text(booking.stayTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(booking.stayLocation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(booking.formattedDateRange)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
                .padding(.trailing, 12)
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 6, x: 0, y: 3)
    }

    private var statusBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: booking.status.icon).font(.caption2)
            Text(booking.status.rawValue).font(.caption2).fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(statusColor.opacity(0.12))
        .foregroundStyle(statusColor)
        .clipShape(Capsule())
    }

    private var statusColor: Color {
        switch booking.status {
        case .upcoming:  return .blue
        case .active:    return .green
        case .completed: return .secondary
        case .cancelled: return .red
        }
    }
}

#Preview {
    TripsView()
}
