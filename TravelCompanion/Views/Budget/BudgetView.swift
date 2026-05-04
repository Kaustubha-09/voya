import SwiftUI

struct BudgetView: View {
    @StateObject private var vm = BudgetViewModel()
    @ObservedObject private var store = BudgetStore.shared

    var body: some View {
        NavigationStack {
            Group {
                if store.budgets.isEmpty {
                    emptyState
                } else {
                    budgetList
                }
            }
            .navigationTitle("Budget Planner")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.reset()
                        vm.showCreateSheet = true
                        HapticService.trigger(.selection)
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $vm.showCreateSheet) {
                BudgetPlannerView(vm: vm)
            }
        }
    }

    private var budgetList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.budgets) { budget in
                    NavigationLink(destination: BudgetDetailView(budget: budget, parentVM: vm)) {
                        BudgetCard(budget: budget)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 12)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "wallet.pass.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.accentRed.opacity(0.45))
            Text("No budgets yet")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Plan your first trip budget")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

private struct BudgetCard: View {
    let budget: TravelBudget

    private var dateRange: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return "\(f.string(from: budget.startDate)) – \(f.string(from: budget.endDate))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(budget.destination)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(dateRange)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if budget.hasFriendStay {
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
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(budget.total.budgetFormatted)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentRed)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Per person")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(budget.perPerson.budgetFormatted)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Travelers")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                        Text("\(budget.travelers)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .padding(16)
        .cardStyle()
    }
}

#Preview {
    BudgetView()
}
