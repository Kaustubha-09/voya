import SwiftUI

struct SquadCardView: View {
    let squad: TravelSquad
    @State private var hasJoined: Bool

    init(squad: TravelSquad) {
        self.squad = squad
        self._hasJoined = State(initialValue: squad.hasJoined)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            destinationHeader

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text(squad.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    StyleBadge(style: squad.travelStyle)
                }

                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(Color.accentRed)
                        .font(.caption)
                    Text(squad.destination)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(squad.dateRange)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                memberAvatarRow

                HStack(spacing: 6) {
                    Text("\(squad.members.count) traveler\(squad.members.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(squad.isFull ? "Full" : "\(squad.spotsLeft) spot\(squad.spotsLeft == 1 ? "" : "s") left")
                        .font(.caption.bold())
                        .foregroundStyle(squad.isFull ? Color.secondary : Color.green)
                }

                HStack(spacing: 6) {
                    if squad.isFlash {
                        FlashBadge()
                    }
                    if squad.isWomenOnly {
                        WomenOnlyBadge()
                    }
                    Spacer()
                }

                actionButton
            }
            .padding(14)
        }
        .cardStyle()
    }

    private var destinationHeader: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [squad.travelStyle.color.opacity(0.7), squad.travelStyle.color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 88)

            HStack {
                Image(systemName: squad.travelStyle.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(14)
                Spacer()
                Text(squad.status.label)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.25))
                    .clipShape(Capsule())
                    .padding(12)
            }
        }
    }

    private var memberAvatarRow: some View {
        HStack(spacing: -8) {
            ForEach(Array(squad.members.prefix(5).enumerated()), id: \.offset) { index, member in
                Circle()
                    .fill(avatarColor(for: index))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text(member.initials)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
                    .zIndex(Double(squad.members.count - index))
            }
            if squad.members.count > 5 {
                Circle()
                    .fill(Color(UIColor.systemGray4))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text("+\(squad.members.count - 5)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.secondary)
                    )
                    .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
            }
        }
    }

    private var actionButton: some View {
        Group {
            if hasJoined {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Joined")
                }
                .font(.subheadline.bold())
                .foregroundStyle(.green)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else if !squad.isOpenJoin {
                HStack {
                    Image(systemName: "lock.fill")
                    Text("Invite Only")
                }
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(Color(UIColor.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                Button {
                    HapticService.trigger(.success)
                    SquadStore.shared.join(id: squad.id)
                    hasJoined = true
                } label: {
                    Text(squad.isFull ? "Full" : "Join Squad")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(squad.isFull ? Color.secondary : Color.accentRed)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(squad.isFull)
            }
        }
    }

    private func avatarColor(for index: Int) -> Color {
        let palette: [Color] = [.accentRed, .blue, .green, .orange, .purple]
        return palette[index % palette.count]
    }
}

struct StyleBadge: View {
    let style: TravelSquad.TravelStyle

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: style.icon)
                .font(.system(size: 10, weight: .semibold))
            Text(style.label)
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundStyle(style.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(style.color.opacity(0.12))
        .clipShape(Capsule())
    }
}

struct FlashBadge: View {
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 9, weight: .bold))
            Text("Flash")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundStyle(Color(red: 0.91, green: 0.19, blue: 0.31))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(red: 0.91, green: 0.19, blue: 0.31).opacity(0.1))
        .clipShape(Capsule())
    }
}

struct WomenOnlyBadge: View {
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "person.fill")
                .font(.system(size: 9, weight: .bold))
            Text("Women Only")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundStyle(.pink)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.pink.opacity(0.1))
        .clipShape(Capsule())
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(TravelSquad.seedSquads) { squad in
                SquadCardView(squad: squad)
            }
        }
        .padding()
    }
    .background(Color(UIColor.systemGroupedBackground))
}
