import SwiftUI

struct BookingSheet: View {
    @StateObject var viewModel: BookingViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            if viewModel.isConfirmed {
                confirmationView
            } else {
                bookingForm
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Booking form

    private var bookingForm: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Stay summary header
                HStack(spacing: 14) {
                    AsyncCachedImage(urlString: viewModel.stay.imageURL)
                        .frame(width: 72, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.stay.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Text(viewModel.stay.location)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        RatingBadge(rating: viewModel.stay.rating)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.systemBackground))

                Divider()

                VStack(spacing: 0) {
                    // Dates
                    Group {
                        DatePicker("Check-in", selection: $viewModel.checkIn,
                                   in: viewModel.checkInRange,
                                   displayedComponents: .date)
                        Divider().padding(.leading)
                        DatePicker("Check-out", selection: $viewModel.checkOut,
                                   in: viewModel.checkOutRange,
                                   displayedComponents: .date)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)

                    Divider()

                    // Guests
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Guests")
                            Text("\(viewModel.guestCount) guest\(viewModel.guestCount == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Stepper("", value: $viewModel.guestCount, in: 1...16)
                            .labelsHidden()
                    }
                    .padding()

                    Divider()

                    // Price breakdown
                    VStack(spacing: 14) {
                        priceRow(label: "$\(Int(viewModel.stay.pricePerNight)) × \(viewModel.nightLabel)",
                                 value: viewModel.formattedSubtotal)
                        priceRow(label: "Cleaning fee", value: viewModel.formattedCleaning)
                        priceRow(label: "Service fee (12%)", value: viewModel.formattedService)

                        Divider()

                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                            Spacer()
                            Text(viewModel.formattedTotal)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.accentRed)
                        }
                        .font(.headline)
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Reserve")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.confirm()
                HapticService.trigger(.success)
            } label: {
                Text("Confirm Reservation")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.accentRed)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }

    // MARK: - Confirmation

    private var confirmationView: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color.accentRed)
            Text("You're going to\n\(viewModel.stay.location)!")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("Reservation confirmed for \(viewModel.nightLabel) starting \(viewModel.checkIn.formatted(date: .abbreviated, time: .omitted)).")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
                .tint(Color.accentRed)
                .controlSize(.large)
            Spacer()
        }
        .navigationTitle("Confirmed!")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper

    private func priceRow(label: String, value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
        .font(.subheadline)
    }
}

#Preview {
    BookingSheet(viewModel: BookingViewModel(stay: MockData.stays[0]))
}
