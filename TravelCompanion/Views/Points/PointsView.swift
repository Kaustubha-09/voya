import SwiftUI

struct PointsView: View {
    @ObservedObject private var store = PointsStore.shared
    @State private var redeemTarget: RedemptionOption?
    @State private var showTierSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    headerCard
                    earnSection
                    redeemSection
                    historySection
                }
                .padding(.bottom, AppTheme.Spacing.xxl)
            }
            .background(AppTheme.Colors.surfaceSecondary)
            .navigationTitle("Voya Points")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HapticService.trigger(.selection)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Color.accentRed)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        HapticService.trigger(.selection)
                        showTierSheet = true
                    } label: {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(store.currentTier.color)
                    }
                }
            }
            .sheet(isPresented: $showTierSheet) {
                TierBenefitsView()
            }
            .alert(
                "Redeem \(redeemTarget?.title ?? "")?",
                isPresented: Binding(
                    get: { redeemTarget != nil },
                    set: { if !$0 { redeemTarget = nil } }
                )
            ) {
                Button("Redeem \(redeemTarget.map { "\($0.cost) pts" } ?? "")") {
                    if let option = redeemTarget {
                        store.redeem(option)
                        HapticService.trigger(.success)
                    }
                    redeemTarget = nil
                }
                Button("Cancel", role: .cancel) { redeemTarget = nil }
            } message: {
                if let option = redeemTarget {
                    Text(option.description)
                }
            }
        }
    }

    // MARK: - Header Card

    private var headerCard: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [store.currentTier.color, store.currentTier.color.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Balance")
                            .font(AppTheme.Fonts.subheadline())
                            .foregroundStyle(.white.opacity(0.85))

                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(store.totalPoints.formatted())
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                            Text("pts")
                                .font(AppTheme.Fonts.title2())
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }

                    Spacer()

                    tierBadge
                }

                progressBar
            }
            .padding(AppTheme.Spacing.xl)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous))
        .shadow(color: store.currentTier.color.opacity(0.35), radius: 16, x: 0, y: 8)
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.xs)
    }

    private var tierBadge: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 52, height: 52)
                Image(systemName: store.currentTier.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Text(store.currentTier.name)
                .font(AppTheme.Fonts.caption(.bold))
                .foregroundStyle(.white)
        }
        .onTapGesture {
            HapticService.trigger(.selection)
            showTierSheet = true
        }
    }

    private var progressBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.25))
                        .frame(height: 8)

                    Capsule()
                        .fill(.white)
                        .frame(width: geo.size.width * store.progressToNextTier, height: 8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: store.progressToNextTier)
                }
            }
            .frame(height: 8)

            if let next = store.nextTier {
                let needed = next.minPoints - store.totalPoints
                Text("\(needed.formatted()) points to \(next.name)")
                    .font(AppTheme.Fonts.caption())
                    .foregroundStyle(.white.opacity(0.85))
            } else {
                Text("You've reached the top tier!")
                    .font(AppTheme.Fonts.caption(.semibold))
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: - Earn Section

    private struct EarnChip {
        let label: String
        let pts: String
        let icon: String
        let type: PointsTransaction.TransactionType
    }

    private let earnChips: [EarnChip] = [
        EarnChip(label: "Booking",  pts: "+250", icon: "bed.double.fill",      type: .booking),
        EarnChip(label: "Review",   pts: "+50",  icon: "star.bubble.fill",     type: .review),
        EarnChip(label: "Referral", pts: "+200", icon: "person.badge.plus.fill", type: .referral),
        EarnChip(label: "Squad",    pts: "+75",  icon: "person.3.fill",        type: .squadJoin),
        EarnChip(label: "Story",    pts: "+30",  icon: "camera.fill",          type: .storyPost),
    ]

    private var earnSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            sectionHeader("Ways to Earn")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(earnChips, id: \.label) { chip in
                        earnChipView(chip)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }

    private func earnChipView(_ chip: EarnChip) -> some View {
        Button {
            HapticService.trigger(.selection)
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.accentRed.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: chip.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.accentRed)
                }
                Text(chip.pts)
                    .font(AppTheme.Fonts.caption(.bold))
                    .foregroundStyle(AppTheme.Colors.success)
                Text(chip.label)
                    .font(AppTheme.Fonts.caption2())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
            .frame(width: 76)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(AppTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md, style: .continuous))
            .shadow(color: AppTheme.Shadow.card.color, radius: AppTheme.Shadow.card.radius, x: 0, y: AppTheme.Shadow.card.y)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Redeem Section

    private var redeemSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            sectionHeader("Redeem Rewards")

            VStack(spacing: AppTheme.Spacing.xs) {
                ForEach(RedemptionOption.options) { option in
                    redemptionCard(option)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
        }
    }

    private func redemptionCard(_ option: RedemptionOption) -> some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radius.sm, style: .continuous)
                    .fill(categoryColor(option.category).opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: option.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(categoryColor(option.category))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(option.title)
                    .font(AppTheme.Fonts.subheadline(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text(option.description)
                    .font(AppTheme.Fonts.caption())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(option.cost.formatted())")
                    .font(AppTheme.Fonts.caption(.bold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("pts")
                    .font(AppTheme.Fonts.caption2())
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                Button {
                    HapticService.trigger(.selection)
                    redeemTarget = option
                } label: {
                    Text("Redeem")
                        .font(AppTheme.Fonts.caption(.semibold))
                        .foregroundStyle(store.canRedeem(option) ? .white : AppTheme.Colors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(store.canRedeem(option) ? Color.accentRed : AppTheme.Colors.surfaceTertiary)
                        .clipShape(Capsule())
                }
                .disabled(!store.canRedeem(option))
            }
        }
        .padding(AppTheme.Spacing.sm)
        .background(AppTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md, style: .continuous))
        .shadow(color: AppTheme.Shadow.card.color, radius: AppTheme.Shadow.card.radius, x: 0, y: AppTheme.Shadow.card.y)
    }

    private func categoryColor(_ category: RedemptionOption.Category) -> Color {
        switch category {
        case .discount:  return AppTheme.Colors.success
        case .upgrade:   return AppTheme.Colors.info
        case .exclusive: return AppTheme.Colors.warning
        }
    }

    // MARK: - History Section

    private var historySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            sectionHeader("Recent Activity")

            VStack(spacing: 0) {
                ForEach(store.transactions.prefix(20)) { tx in
                    transactionRow(tx)

                    if tx.id != store.transactions.prefix(20).last?.id {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
            .background(AppTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous))
            .shadow(color: AppTheme.Shadow.card.color, radius: AppTheme.Shadow.card.radius, x: 0, y: AppTheme.Shadow.card.y)
            .padding(.horizontal, AppTheme.Spacing.md)
        }
    }

    private func transactionRow(_ tx: PointsTransaction) -> some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(tx.points > 0 ? AppTheme.Colors.success.opacity(0.12) : Color.accentRed.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: tx.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(tx.points > 0 ? AppTheme.Colors.success : Color.accentRed)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(tx.description)
                    .font(AppTheme.Fonts.subheadline())
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineLimit(1)
                Text(tx.date, style: .date)
                    .font(AppTheme.Fonts.caption())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }

            Spacer()

            Text(tx.points > 0 ? "+\(tx.points.formatted())" : "\(tx.points.formatted())")
                .font(AppTheme.Fonts.subheadline(.semibold))
                .foregroundStyle(tx.points > 0 ? AppTheme.Colors.success : Color.accentRed)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(AppTheme.Fonts.title3())
            .foregroundStyle(AppTheme.Colors.textPrimary)
            .padding(.horizontal, AppTheme.Spacing.md)
    }
}

#Preview {
    PointsView()
}
