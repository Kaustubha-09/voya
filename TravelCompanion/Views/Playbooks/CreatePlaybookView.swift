import SwiftUI

struct CreatePlaybookView: View {
    @ObservedObject var vm: PlaybookViewModel
    @Environment(\.dismiss) private var dismiss

    private let allTags = ["beach", "mountains", "city", "food", "adventure", "culture", "budget", "luxury"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerBanner

                    VStack(spacing: 16) {
                        essentialsSection
                        tripDetailsSection
                        budgetSection
                        tagsSection
                        packingSection
                    }
                    .padding(.horizontal, 20)

                    publishButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 36)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Create Playbook")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                        HapticService.trigger(.soft)
                    }
                }
            }
        }
    }

    private var headerBanner: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1530521954765-bd2b6a640d03?w=800&q=80")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.subtleGray
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Share your journey")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("Help fellow travellers plan their perfect trip")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    private var essentialsSection: some View {
        FormSection(title: "Essentials") {
            VStack(spacing: 12) {
                LabeledField(label: "Destination", placeholder: "e.g. Bali, Indonesia", text: $vm.destination)
                LabeledField(label: "Guide Title", placeholder: "e.g. 7 Days in Bali on a Budget", text: $vm.title)
                LabeledField(label: "Your Name", placeholder: "e.g. Alex Rivera", text: $vm.authorName)
            }
        }
    }

    private var tripDetailsSection: some View {
        FormSection(title: "Trip Details") {
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Trip Type")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Picker("Trip Type", selection: $vm.tripType) {
                        ForEach(Playbook.TripType.allCases) { type in
                            Label(type.label, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color.accentRed)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Duration")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(vm.duration) day\(vm.duration == 1 ? "" : "s")")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.accentRed)
                    }
                    Stepper("", value: $vm.duration, in: 1...30)
                        .labelsHidden()
                }

                LabeledField(
                    label: "Best Time to Visit",
                    placeholder: "e.g. April–October (dry season)",
                    text: $vm.bestTimeToVisit
                )
            }
        }
    }

    private var budgetSection: some View {
        FormSection(title: "Daily Budget (USD)") {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Min")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Text("$")
                            .foregroundStyle(.secondary)
                        TextField("0", text: $vm.budgetMin)
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                Text("–")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Max")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Text("$")
                            .foregroundStyle(.secondary)
                        TextField("0", text: $vm.budgetMax)
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }

    private var tagsSection: some View {
        FormSection(title: "Tags") {
            FlowLayout(spacing: 8) {
                ForEach(allTags, id: \.self) { tag in
                    TagChip(
                        label: tag,
                        isSelected: vm.selectedTags.contains(tag)
                    ) {
                        vm.toggleTag(tag)
                    }
                }
            }
        }
    }

    private var packingSection: some View {
        FormSection(title: "Packing List") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    TextField("Add an item…", text: $vm.packingInput)
                        .onSubmit { vm.addPackingItem() }

                    Button {
                        vm.addPackingItem()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accentRed)
                    }
                    .disabled(vm.packingInput.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                if !vm.packingList.isEmpty {
                    FlowLayout(spacing: 8) {
                        ForEach(Array(vm.packingList.enumerated()), id: \.element) { index, item in
                            PackingItemChip(item: item) {
                                vm.packingList.remove(at: index)
                                HapticService.trigger(.selection)
                            }
                        }
                    }
                }
            }
        }
    }

    private var publishButton: some View {
        Button {
            guard !vm.destination.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            vm.savePlaybook()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "paperplane.fill")
                Text("Publish Guide")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                vm.destination.trimmingCharacters(in: .whitespaces).isEmpty
                    ? Color.subtleGray
                    : Color.accentRed
            )
            .foregroundStyle(
                vm.destination.trimmingCharacters(in: .whitespaces).isEmpty
                    ? Color.secondary
                    : Color.white
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .disabled(vm.destination.trimmingCharacters(in: .whitespaces).isEmpty)
    }
}

struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            content
                .padding(16)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

struct LabeledField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

struct TagChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption2.bold())
                }
                Text(label)
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? Color.accentRed : Color(UIColor.tertiarySystemGroupedBackground))
            .clipShape(Capsule())
        }
    }
}

struct PackingItemChip: View {
    let item: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 5) {
            Text(item)
                .font(.caption.weight(.medium))
                .lineLimit(1)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2.bold())
            }
        }
        .foregroundStyle(Color.accentRed)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.accentRed.opacity(0.1))
        .clipShape(Capsule())
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { subviews[$0].sizeThatFits(.unspecified).height }.max() ?? 0 }.reduce(0) { $0 + $1 + spacing } - spacing
        return CGSize(width: proposal.width ?? 0, height: max(height, 0))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { subviews[$0].sizeThatFits(.unspecified).height }.max() ?? 0
            for index in row {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += rowHeight + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[Int]] {
        let maxWidth = proposal.width ?? .infinity
        var rows: [[Int]] = [[]]
        var currentRowWidth: CGFloat = 0

        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            if currentRowWidth + size.width > maxWidth && !rows[rows.count - 1].isEmpty {
                rows.append([])
                currentRowWidth = 0
            }
            rows[rows.count - 1].append(index)
            currentRowWidth += size.width + spacing
        }
        return rows
    }
}

#Preview {
    CreatePlaybookView(vm: PlaybookViewModel())
}
