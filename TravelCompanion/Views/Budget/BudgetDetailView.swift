import SwiftUI

struct BudgetDetailView: View {
    let budget: TravelBudget
    let parentVM: BudgetViewModel

    @ObservedObject private var store = BudgetStore.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false

    private var liveBudget: TravelBudget {
        store.budgets.first(where: { $0.id == budget.id }) ?? budget
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                barChartCard
                categoriesCard
                if liveBudget.hasFriendStay {
                    friendStayCard
                }
                summaryCard
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .navigationTitle(liveBudget.destination)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        parentVM.loadForEditing(liveBudget)
                        showEdit = true
                        HapticService.trigger(.selection)
                    } label: {
                        Image(systemName: "pencil")
                    }
                    Button(role: .destructive) {
                        BudgetStore.shared.delete(id: liveBudget.id)
                        HapticService.trigger(.error)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Color.accentRed)
                    }
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            BudgetPlannerView(vm: parentVM)
        }
    }

    private var headerCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(liveBudget.destination)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(dateRange)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                        Text("\(liveBudget.travelers) traveler\(liveBudget.travelers == 1 ? "" : "s")")
                            .font(.caption)
                        Text("·")
                            .foregroundStyle(.secondary)
                        Text("\(liveBudget.nights) night\(liveBudget.nights == 1 ? "" : "s")")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
                Spacer()
                if liveBudget.hasFriendStay {
                    Label("Friend Stay", systemImage: "person.2.fill")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())
                }
            }

            Divider()

            HStack {
                statBox(title: "Total", value: liveBudget.total.budgetFormatted, accent: true)
                Divider().frame(height: 44)
                statBox(title: "Per Person", value: liveBudget.perPerson.budgetFormatted)
                Divider().frame(height: 44)
                statBox(title: "Subtotal", value: liveBudget.subtotal.budgetFormatted)
            }
        }
        .padding(16)
        .cardStyle()
    }

    private func statBox(title: String, value: String, accent: Bool = false) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(accent ? .title2 : .subheadline)
                .fontWeight(.bold)
                .foregroundStyle(accent ? Color.accentRed : .primary)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var barChartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Spending Breakdown")
                .font(.headline)
                .fontWeight(.semibold)

            ForEach(liveBudget.categories) { category in
                let proportion = liveBudget.subtotal > 0 ? category.selectedAmount / liveBudget.subtotal : 0
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: category.type.icon)
                            .foregroundStyle(Color.accentRed)
                            .frame(width: 18)
                        Text(category.type.label)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(category.selectedAmount.budgetFormatted)
                            .font(.caption)
                            .fontWeight(.medium)
                        Text(String(format: "%.0f%%", proportion * 100))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(width: 30, alignment: .trailing)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.accentRed.opacity(0.1))
                                .frame(height: 8)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.accentRed)
                                .frame(width: geo.size.width * proportion, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .padding(16)
        .cardStyle()
    }

    private var categoriesCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Category Breakdown")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 12)

            ForEach(Array(liveBudget.categories.enumerated()), id: \.element.id) { index, category in
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.accentRed.opacity(0.1))
                                .frame(width: 36, height: 36)
                            Image(systemName: category.type.icon)
                                .foregroundStyle(Color.accentRed)
                                .font(.subheadline)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(category.type.label)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(category.tier.label)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(category.selectedAmount.budgetFormatted)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)

                    if index < liveBudget.categories.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding(16)
        .cardStyle()
    }

    private var friendStayCard: some View {
        let standardTrip = liveBudget.subtotal
        let savings = liveBudget.friendStaySavings
        let youPay = liveBudget.total
        let savingsPct = standardTrip > 0 ? Int((savings / standardTrip) * 100) : 0

        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(.green)
                Text("Friend Stay Savings")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }

            VStack(spacing: 8) {
                savingsRow(label: "Standard trip", value: standardTrip.budgetFormatted, green: false)
                savingsRow(label: "You're paying", value: youPay.budgetFormatted, green: false, bold: true)
                Divider()
                HStack {
                    Text("You saved")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                    Spacer()
                    Text("\(savings.budgetFormatted) (\(savingsPct)%)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(16)
        .background(Color.green.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.green.opacity(0.25), lineWidth: 1)
        )
    }

    private func savingsRow(label: String, value: String, green: Bool, bold: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(bold ? .semibold : .regular)
        }
    }

    private var summaryCard: some View {
        VStack(spacing: 10) {
            summaryRow(label: "Subtotal", value: liveBudget.subtotal.budgetFormatted)

            if liveBudget.hasFriendStay && liveBudget.friendStaySavings > 0 {
                summaryRow(
                    label: "Friend Stay Savings",
                    value: "-\(liveBudget.friendStaySavings.budgetFormatted)",
                    green: true
                )
            }

            Divider()

            HStack {
                Text("Total")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(liveBudget.total.budgetFormatted)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentRed)
            }

            HStack {
                Text("Per person")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(liveBudget.perPerson.budgetFormatted)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding(16)
        .cardStyle()
    }

    private func summaryRow(label: String, value: String, green: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(green ? .green : .secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(green ? .green : .primary)
        }
    }

    private var dateRange: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return "\(f.string(from: liveBudget.startDate)) – \(f.string(from: liveBudget.endDate))"
    }
}

#Preview {
    NavigationStack {
        BudgetDetailView(
            budget: TravelBudget(
                id: "preview",
                destination: "Tokyo, Japan",
                startDate: .now,
                endDate: Calendar.current.date(byAdding: .day, value: 10, to: .now)!,
                travelers: 2,
                hasFriendStay: true,
                categories: BudgetCategory.defaults(for: "Tokyo, Japan", nights: 10, travelers: 2),
                createdAt: .now
            ),
            parentVM: BudgetViewModel()
        )
    }
}
