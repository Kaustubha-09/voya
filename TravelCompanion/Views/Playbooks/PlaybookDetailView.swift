import SwiftUI

struct PlaybookDetailView: View {
    let playbook: Playbook

    @State private var checkedItems: Set<String> = []
    @State private var showForkSuccess = false
    @State private var showTipSheet = false
    @State private var localTips: [PlaybookTip] = []
    @State private var upvotedTips: Set<String> = []

    private let store = PlaybookStore.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroImage
                contentStack
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .top) {
            if showForkSuccess {
                forkSuccessToast
                    .padding(.top, 60)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showTipSheet) {
            AddTipSheet(playbook: playbook) { tip in
                localTips.insert(tip, at: 0)
            }
        }
        .onAppear {
            localTips = playbook.tips
        }
    }

    private var heroImage: some View {
        AsyncImage(url: URL(string: playbook.coverImageURL)) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Color.subtleGray
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .clipped()
    }

    private var contentStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            authorRow
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)

            Divider().padding(.horizontal, 20)

            statsRow
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

            Divider().padding(.horizontal, 20)

            tripInfoChips
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

            if !playbook.days.isEmpty {
                Divider().padding(.horizontal, 20)
                itinerarySection
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
            }

            Divider().padding(.horizontal, 20)
            tipsSection
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

            if !playbook.packingList.isEmpty {
                Divider().padding(.horizontal, 20)
                packingSection
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
            }

            Divider().padding(.horizontal, 20)

            Button {
                showTipSheet = true
                HapticService.trigger(.soft)
            } label: {
                Label("Leave a Tip", systemImage: "lightbulb.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.accentRed)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 36)
        }
    }

    private var authorRow: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentRed.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(playbook.authorInitials)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.accentRed)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(playbook.title)
                    .font(.title3.bold())
                    .lineLimit(2)
                HStack(spacing: 4) {
                    Text("by \(playbook.authorName)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if playbook.authorIsVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(Color.accentRed)
                    }
                }
            }

            Spacer()

            Button {
                forkPlaybook()
            } label: {
                Label("Fork", systemImage: "arrow.triangle.branch")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.accentRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.accentRed.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
    }

    private var statsRow: some View {
        HStack(spacing: 24) {
            StatPill(icon: "star.fill", color: .yellow, value: playbook.rating.starRating, label: "Rating")
            StatPill(icon: "arrow.triangle.branch", color: .blue, value: "\(playbook.forkCount)", label: "Forks")
            StatPill(icon: "eye.fill", color: .purple, value: viewLabel, label: "Views")
            StatPill(icon: "calendar", color: .green, value: updatedLabel, label: "Updated")
        }
    }

    private var viewLabel: String {
        playbook.viewCount >= 1000
            ? "\(String(format: "%.1fk", Double(playbook.viewCount) / 1000))"
            : "\(playbook.viewCount)"
    }

    private var updatedLabel: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: playbook.lastUpdated, relativeTo: Date())
    }

    private var tripInfoChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                InfoChip(icon: playbook.tripType.icon, text: playbook.tripType.label, color: .accentRed)
                InfoChip(icon: "calendar", text: "\(playbook.duration) days", color: .blue)
                InfoChip(icon: "sun.max.fill", text: playbook.bestTimeToVisit, color: .orange)
                InfoChip(icon: "dollarsign.circle.fill", text: playbook.budgetRange + "/day", color: .green)
            }
        }
    }

    private var itinerarySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Itinerary")
                .font(.title3.bold())

            ForEach(playbook.days) { day in
                DisclosureGroup {
                    VStack(spacing: 0) {
                        ForEach(Array(day.activities.enumerated()), id: \.element.id) { index, activity in
                            ActivityTimelineRow(activity: activity, isLast: index == day.activities.count - 1)
                        }
                    }
                    .padding(.top, 8)
                } label: {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.accentRed)
                                .frame(width: 28, height: 28)
                            Text("\(day.dayNumber)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        }
                        Text(day.title)
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                        Text("\(day.activities.count) activities")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(14)
                .background(Color.subtleGray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Traveller Tips")
                .font(.title3.bold())

            ForEach(localTips) { tip in
                TipRow(tip: tip, isUpvoted: upvotedTips.contains(tip.id)) {
                    toggleUpvote(tip: tip)
                }
            }
        }
    }

    private var packingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Packing List")
                .font(.title3.bold())

            ForEach(playbook.packingList, id: \.self) { item in
                Button {
                    if checkedItems.contains(item) {
                        checkedItems.remove(item)
                    } else {
                        checkedItems.insert(item)
                    }
                    HapticService.trigger(.selection)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: checkedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                            .font(.body)
                            .foregroundStyle(checkedItems.contains(item) ? Color.accentRed : .secondary)
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(checkedItems.contains(item) ? .secondary : .primary)
                            .strikethrough(checkedItems.contains(item))
                            .animation(.none, value: checkedItems)
                        Spacer()
                    }
                }
            }
        }
    }

    private var forkSuccessToast: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text("Guide forked — saved to your playbooks!")
                .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .clipShape(Capsule())
        .shadow(color: .cardShadow, radius: 8, x: 0, y: 4)
        .padding(.horizontal, 24)
    }

    private func forkPlaybook() {
        _ = store.fork(playbook, authorName: "Me")
        HapticService.trigger(.success)
        withAnimation(.spring(response: 0.4)) {
            showForkSuccess = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showForkSuccess = false
            }
        }
    }

    private func toggleUpvote(tip: PlaybookTip) {
        guard let i = localTips.firstIndex(where: { $0.id == tip.id }) else { return }
        if upvotedTips.contains(tip.id) {
            upvotedTips.remove(tip.id)
            localTips[i].upvotes = max(0, localTips[i].upvotes - 1)
        } else {
            upvotedTips.insert(tip.id)
            localTips[i].upvotes += 1
        }
        HapticService.trigger(.selection)
    }
}

struct StatPill: View {
    let icon: String
    let color: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoChip: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
            Text(text)
                .font(.caption.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
}

struct ActivityTimelineRow: View {
    let activity: PlaybookActivity
    let isLast: Bool

    private var dotColor: Color {
        switch activity.type.color {
        case "orange": return .orange
        case "blue": return .blue
        case "purple": return .purple
        case "green": return .green
        default: return .yellow
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Text(activity.time)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 52, alignment: .trailing)
                    .padding(.top, 2)
            }

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 10, height: 10)
                    Image(systemName: activity.type.icon)
                        .font(.system(size: 5))
                        .foregroundStyle(.white)
                }
                .padding(.top, 4)

                if !isLast {
                    Rectangle()
                        .fill(Color.subtleGray)
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(activity.title)
                    .font(.subheadline.weight(.semibold))
                Text(activity.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if let cost = activity.estimatedCost, cost > 0 {
                    Text("~$\(Int(cost))")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(dotColor)
                }
            }
            .padding(.bottom, isLast ? 0 : 16)

            Spacer(minLength: 0)
        }
    }
}

struct TipRow: View {
    let tip: PlaybookTip
    let isUpvoted: Bool
    let onUpvote: () -> Void

    private var iconColor: Color {
        switch tip.category {
        case .local: return .accentRed
        case .food: return .orange
        case .transport: return .blue
        case .safety: return .green
        case .money: return .purple
        case .packing: return .brown
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: tip.category.icon)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(width: 32)

            Text(tip.text)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)

            Button(action: onUpvote) {
                VStack(spacing: 2) {
                    Image(systemName: isUpvoted ? "heart.fill" : "heart")
                        .font(.caption)
                        .foregroundStyle(isUpvoted ? Color.accentRed : .secondary)
                    Text("\(tip.upvotes)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color.subtleGray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct AddTipSheet: View {
    let playbook: Playbook
    let onAdd: (PlaybookTip) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var tipText = ""
    @State private var selectedCategory: PlaybookTip.TipCategory = .local

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(PlaybookTip.TipCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue.capitalized, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Your Tip") {
                    TextEditor(text: $tipText)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Leave a Tip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        guard !tipText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        let tip = PlaybookTip(
                            id: UUID().uuidString,
                            category: selectedCategory,
                            text: tipText.trimmingCharacters(in: .whitespaces),
                            upvotes: 0
                        )
                        onAdd(tip)
                        HapticService.trigger(.success)
                        dismiss()
                    }
                    .disabled(tipText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlaybookDetailView(playbook: Playbook.seedPlaybooks[0])
    }
}
