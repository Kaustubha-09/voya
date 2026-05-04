import SwiftUI

struct BudgetPlannerView: View {
    @ObservedObject var vm: BudgetViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var expandedCategoryID: String? = nil
    @State private var categoriesInitialized = false
    @State private var costSuggestions: [String] = []
    @State private var selectedPreset: CityBudgetPreset? = nil

    private let costService = CostOfLivingService.shared

    var body: some View {
        NavigationStack {
            Form {
                tripDetailsSection
                friendStaySection
                categoriesSection
                summarySection
            }
            .navigationTitle(vm.editingBudget == nil ? "New Budget" : "Edit Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        vm.reset()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        vm.saveBudget()
                        HapticService.trigger(.success)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!vm.canCreate || vm.categories.isEmpty)
                }
            }
            .onAppear {
                if !categoriesInitialized && vm.categories.isEmpty {
                    vm.initCategories()
                    categoriesInitialized = true
                }
            }
            .onChange(of: vm.destination) { _, _ in reinitIfNeeded() }
            .onChange(of: vm.travelers)   { _, _ in reinitIfNeeded() }
            .onChange(of: vm.startDate)   { _, _ in reinitIfNeeded() }
            .onChange(of: vm.endDate)     { _, _ in reinitIfNeeded() }
        }
    }

    private func costTierColor(_ tier: CityBudgetPreset.Tier) -> Color {
        switch tier {
        case .budget:    return .green
        case .moderate:  return .blue
        case .expensive: return .orange
        case .luxurious: return .purple
        }
    }

    private func reinitIfNeeded() {
        guard vm.editingBudget == nil else { return }
        vm.initCategories()
    }

    private var tripDetailsSection: some View {
        Section("Trip Details") {
            VStack(alignment: .leading, spacing: 4) {
                TextField("Destination (e.g. Tokyo, Japan)", text: $vm.destination)
                    .autocorrectionDisabled()
                    .onChange(of: vm.destination) { _, q in
                        costSuggestions = costService.suggestions(for: q)
                        selectedPreset = costService.preset(for: q)
                    }

                if !costSuggestions.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(costSuggestions, id: \.self) { s in
                                Button(s) {
                                    vm.destination = s
                                    selectedPreset = costService.preset(for: s)
                                    costSuggestions = []
                                    HapticService.trigger(.selection)
                                }
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.accentRed.opacity(0.1))
                                .foregroundStyle(Color.accentRed)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }
            }

            if let preset = selectedPreset {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: preset.tier.icon)
                            .foregroundStyle(costTierColor(preset.tier))
                        Text("\(preset.tier.rawValue) destination · \(preset.currency)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(costTierColor(preset.tier))
                    }
                    Text("Typical daily spend: food $\(Int(preset.dailyFood)) · transport $\(Int(preset.dailyTransport)) · activities $\(Int(preset.dailyActivities))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("💡 \(preset.tip)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                .listRowBackground(costTierColor(preset.tier).opacity(0.08))
            }

            DatePicker("Check-in", selection: $vm.startDate, displayedComponents: .date)
                .onChange(of: vm.startDate) { _, newVal in
                    if vm.endDate <= newVal {
                        vm.endDate = Calendar.current.date(byAdding: .day, value: 1, to: newVal)!
                    }
                }

            DatePicker(
                "Check-out",
                selection: $vm.endDate,
                in: Calendar.current.date(byAdding: .day, value: 1, to: vm.startDate)!...,
                displayedComponents: .date
            )

            Stepper("Travelers: \(vm.travelers)", value: $vm.travelers, in: 1...10)
        }
    }

    private var friendStaySection: some View {
        Section("Accommodation") {
            Toggle("Staying with a friend locally", isOn: $vm.hasFriendStay)
                .onChange(of: vm.hasFriendStay) { _, _ in
                    HapticService.trigger(.selection)
                }

            if vm.hasFriendStay && vm.friendStaySavings > 0 {
                HStack(spacing: 12) {
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Friend Stay Savings")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                        Text("You're saving \(vm.friendStaySavings.budgetFormatted) on accommodation (90% off stay cost)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.green.opacity(0.08))
            }
        }
    }

    private var categoriesSection: some View {
        Section("Budget Categories") {
            ForEach($vm.categories) { $category in
                CategoryRow(
                    category: $category,
                    isExpanded: expandedCategoryID == category.id,
                    onToggle: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            expandedCategoryID = expandedCategoryID == category.id ? nil : category.id
                        }
                        HapticService.trigger(.selection)
                    },
                    onTierChange: { tier in
                        vm.updateTier(for: category.id, tier: tier)
                        HapticService.trigger(.selection)
                    },
                    onAmountChange: { amount, tier in
                        vm.updateAmount(for: category.id, amount: amount, tier: tier)
                    }
                )
            }
        }
    }

    private var summarySection: some View {
        Section {
            HStack {
                Text("Subtotal")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(vm.subtotal.budgetFormatted)
                    .fontWeight(.medium)
            }

            if vm.hasFriendStay && vm.friendStaySavings > 0 {
                HStack {
                    Text("Friend Stay Savings")
                        .foregroundStyle(.green)
                    Spacer()
                    Text("-\(vm.friendStaySavings.budgetFormatted)")
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                }
            }

            HStack {
                Text("Total")
                    .fontWeight(.bold)
                Spacer()
                Text(vm.total.budgetFormatted)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentRed)
                    .font(.title3)
            }

            HStack {
                Text("Per person")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(vm.perPerson.budgetFormatted)
                    .fontWeight(.semibold)
            }
        } header: {
            Text("Summary")
        }
    }
}

private struct CategoryRow: View {
    @Binding var category: BudgetCategory
    let isExpanded: Bool
    let onToggle: () -> Void
    let onTierChange: (BudgetCategory.Tier) -> Void
    let onAmountChange: (Double, BudgetCategory.Tier) -> Void

    @State private var budgetText = ""
    @State private var comfortableText = ""
    @State private var splurgeText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    Image(systemName: category.type.icon)
                        .foregroundStyle(Color.accentRed)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.type.label)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                        Text(category.selectedAmount.budgetFormatted)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Picker("Tier", selection: Binding(
                        get: { category.tier },
                        set: { onTierChange($0) }
                    )) {
                        ForEach(BudgetCategory.Tier.allCases) { tier in
                            Text(tier.label).tag(tier)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 8)

                    VStack(spacing: 8) {
                        amountField(label: "Budget", text: $budgetText, tier: .budget)
                        amountField(label: "Comfortable", text: $comfortableText, tier: .comfortable)
                        amountField(label: "Splurge", text: $splurgeText, tier: .splurge)
                    }
                }
                .onAppear {
                    budgetText = formatAmount(category.budgetAmount)
                    comfortableText = formatAmount(category.comfortableAmount)
                    splurgeText = formatAmount(category.splurgeAmount)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func amountField(label: String, text: Binding<String>, tier: BudgetCategory.Tier) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .leading)
            Text("$")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            TextField("0", text: text)
                .keyboardType(.decimalPad)
                .font(.subheadline)
                .onChange(of: text.wrappedValue) { _, newVal in
                    if let amount = Double(newVal) {
                        onAmountChange(amount, tier)
                    }
                }
            if category.tier == tier {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.accentRed)
                    .font(.caption)
            }
        }
    }

    private func formatAmount(_ value: Double) -> String {
        String(Int(value))
    }
}

#Preview {
    BudgetPlannerView(vm: BudgetViewModel())
}
