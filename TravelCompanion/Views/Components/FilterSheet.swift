import SwiftUI

struct FilterSheet: View {
    @Binding var filter: FilterOptions
    @Environment(\.dismiss) private var dismiss
    @State private var draft: FilterOptions

    init(filter: Binding<FilterOptions>) {
        _filter = filter
        _draft = State(initialValue: filter.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Up to")
                            Spacer()
                            Text("$\(Int(draft.maxPrice))")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accentRed)
                        }
                        Slider(value: $draft.maxPrice, in: 50...600, step: 25)
                            .tint(Color.accentRed)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Max price per night")
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("At least")
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill").foregroundStyle(.yellow).font(.caption)
                                Text(String(format: "%.1f", draft.minRating))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentRed)
                            }
                        }
                        Slider(value: $draft.minRating, in: 0...5, step: 0.5)
                            .tint(Color.accentRed)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Minimum rating")
                }
            }
            .navigationTitle("Filter Stays")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        draft = FilterOptions()
                        HapticService.trigger(.soft)
                    }
                    .foregroundStyle(Color.accentRed)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        filter = draft
                        HapticService.trigger(.selection)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    FilterSheet(filter: .constant(FilterOptions()))
}
