import SwiftUI

struct TierBenefitsView: View {
    @ObservedObject private var store = PointsStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    headerLabel

                    ForEach(RewardTier.tiers) { tier in
                        tierCard(tier)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xxl)
            }
            .background(AppTheme.Colors.surfaceSecondary)
            .navigationTitle("Tier Benefits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        HapticService.trigger(.selection)
                        dismiss()
                    }
                    .foregroundStyle(Color.accentRed)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Header

    private var headerLabel: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            Text("Your current tier")
                .font(AppTheme.Fonts.subheadline())
                .foregroundStyle(AppTheme.Colors.textSecondary)
            HStack(spacing: 8) {
                Image(systemName: store.currentTier.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(store.currentTier.color)
                Text(store.currentTier.name)
                    .font(AppTheme.Fonts.title2())
                    .foregroundStyle(store.currentTier.color)
            }
            Text("\(store.totalPoints.formatted()) pts")
                .font(AppTheme.Fonts.headline())
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.xs)
    }

    // MARK: - Tier Card

    private func tierCard(_ tier: RewardTier) -> some View {
        let isCurrent = tier.name == store.currentTier.name
        let isUnlocked = store.totalPoints >= tier.minPoints

        return VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(tier.color.opacity(isUnlocked ? 0.15 : 0.07))
                        .frame(width: 52, height: 52)
                    Image(systemName: tier.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(tier.color.opacity(isUnlocked ? 1.0 : 0.45))
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(tier.name)
                            .font(AppTheme.Fonts.title3())
                            .foregroundStyle(
                                isUnlocked
                                    ? AppTheme.Colors.textPrimary
                                    : AppTheme.Colors.textPrimary.opacity(0.45)
                            )
                        if isCurrent {
                            currentBadge
                        }
                    }
                    Text(tier.minPoints == 0 ? "Starting tier" : "\(tier.minPoints.formatted()) pts to unlock")
                        .font(AppTheme.Fonts.caption())
                        .foregroundStyle(
                            isUnlocked
                                ? AppTheme.Colors.textSecondary
                                : AppTheme.Colors.textSecondary.opacity(0.6)
                        )
                }

                Spacer()

                multiplierBadge(tier: tier, unlocked: isUnlocked)
            }

            Divider()
                .opacity(isUnlocked ? 1.0 : 0.4)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(tier.perks, id: \.self) { perk in
                    HStack(spacing: 8) {
                        Image(systemName: isUnlocked ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 14))
                            .foregroundStyle(isUnlocked ? tier.color : AppTheme.Colors.textTertiary)
                        Text(perk)
                            .font(AppTheme.Fonts.subheadline())
                            .foregroundStyle(
                                isUnlocked
                                    ? AppTheme.Colors.textPrimary
                                    : AppTheme.Colors.textPrimary.opacity(0.45)
                            )
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(
            isCurrent
                ? tier.color.opacity(0.06)
                : AppTheme.Colors.surface
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous)
                .stroke(
                    isCurrent ? tier.color : Color.clear,
                    lineWidth: 2
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous))
        .shadow(
            color: isCurrent
                ? tier.color.opacity(0.20)
                : AppTheme.Shadow.card.color,
            radius: AppTheme.Shadow.card.radius,
            x: 0,
            y: AppTheme.Shadow.card.y
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
    }

    private var currentBadge: some View {
        Text("Current")
            .font(AppTheme.Fonts.caption2(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(store.currentTier.color)
            .clipShape(Capsule())
    }

    private func multiplierBadge(tier: RewardTier, unlocked: Bool) -> some View {
        let isWhole = tier.multiplier.truncatingRemainder(dividingBy: 1) == 0
        let label = isWhole
            ? String(format: "%.0f×", tier.multiplier)
            : String(format: "%.2g×", tier.multiplier)

        return VStack(spacing: 2) {
            Text(label)
                .font(AppTheme.Fonts.title3())
                .foregroundStyle(unlocked ? tier.color : AppTheme.Colors.textTertiary)
            Text("multiplier")
                .font(AppTheme.Fonts.caption2())
                .foregroundStyle(unlocked ? AppTheme.Colors.textSecondary : AppTheme.Colors.textTertiary)
        }
        .padding(.horizontal, AppTheme.Spacing.sm)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(tier.color.opacity(unlocked ? 0.10 : 0.04))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm, style: .continuous))
    }
}

#Preview {
    TierBenefitsView()
}
