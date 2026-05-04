import SwiftUI

struct TripDetailView: View {
    let booking: Booking
    @State private var showCancelAlert = false
    @ObservedObject private var store = BookingStore.shared

    private var currentBooking: Booking {
        store.bookings.first { $0.id == booking.id } ?? booking
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroImage
                content
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Reservation", isPresented: $showCancelAlert) {
            Button("Cancel Reservation", role: .destructive) {
                store.cancel(id: booking.id)
                HapticService.trigger(.success)
            }
            Button("Keep Reservation", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel your stay at \(booking.stayTitle)? This action cannot be undone.")
        }
    }

    private var heroImage: some View {
        AsyncCachedImage(urlString: booking.stayImageURL)
            .frame(height: 260)
            .clipped()
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    statusBadge
                    Spacer()
                    Text("#\(booking.confirmationCode)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(booking.stayTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(Color.accentRed)
                        .font(.subheadline)
                    Text(booking.stayLocation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Dates
            HStack {
                tripDateBlock(title: "Check-in", date: booking.formattedCheckIn,
                              icon: "arrow.right.circle.fill", color: .green)
                Spacer()
                tripDateBlock(title: "Check-out", date: booking.formattedCheckOut,
                              icon: "arrow.left.circle.fill", color: Color.accentRed)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            // Guest info
            infoRow(icon: "person.2.fill",   label: "Guests",    value: "\(booking.guestCount) guest\(booking.guestCount == 1 ? "" : "s")")
            infoRow(icon: "moon.fill",        label: "Duration",  value: booking.nightLabel)
            infoRow(icon: "house.fill",       label: "Host",      value: booking.hostName)

            Divider()

            // Price breakdown
            VStack(alignment: .leading, spacing: 12) {
                Text("Price Breakdown")
                    .font(.headline)

                priceRow("$\(Int(booking.pricePerNight)) × \(booking.nightLabel)",
                         value: "$\(Int(booking.pricePerNight * Double(booking.nights)))")
                priceRow("Cleaning fee",   value: "$\(Int(booking.cleaningFee))")
                priceRow("Service fee",    value: "$\(Int(booking.serviceFee))")
                Divider()
                HStack {
                    Text("Total").fontWeight(.bold)
                    Spacer()
                    Text("$\(Int(booking.total))").fontWeight(.bold).foregroundStyle(Color.accentRed)
                }
                .font(.headline)
            }

            // Cancel button (only for upcoming)
            if currentBooking.status == .upcoming {
                Button(role: .destructive) {
                    showCancelAlert = true
                } label: {
                    Text("Cancel Reservation")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.1))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }

            // Review prompt (only for completed)
            if currentBooking.status == .completed {
                reviewPrompt
            }

            Color.clear.frame(height: 20)
        }
        .padding(20)
    }

    private var statusBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: currentBooking.status.icon).font(.caption)
            Text(currentBooking.status.rawValue).font(.caption).fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.12))
        .foregroundStyle(statusColor)
        .clipShape(Capsule())
    }

    private var statusColor: Color {
        switch currentBooking.status {
        case .upcoming:  return .blue
        case .active:    return .green
        case .completed: return .secondary
        case .cancelled: return .red
        }
    }

    private var reviewPrompt: some View {
        VStack(spacing: 12) {
            Divider()
            Text("How was your stay?")
                .font(.headline)
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                }
            }
            Text("Leave a review to help future travellers.")
                .font(.caption)
                .foregroundStyle(.secondary)
            Button("Write a Review") {
                HapticService.trigger(.selection)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.accentRed)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // MARK: - Helpers

    private func tripDateBlock(title: String, date: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon).font(.caption).foregroundStyle(color)
            Text(date).font(.subheadline).fontWeight(.semibold)
        }
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(Color.accentRed)
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value).fontWeight(.medium)
        }
        .font(.subheadline)
    }

    private func priceRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        TripDetailView(booking: Booking.seedBookings[0])
    }
}
