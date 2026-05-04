import SwiftUI

struct SquadDetailView: View {
    let squad: TravelSquad
    @ObservedObject private var store = SquadStore.shared
    @State private var messageText = ""
    @State private var scrollProxy: ScrollViewProxy? = nil
    @Environment(\.dismiss) private var dismiss

    private var currentSquad: TravelSquad {
        store.squads.first { $0.id == squad.id } ?? squad
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    Divider()
                    infoSection
                    Divider()
                    membersSection
                    Divider()
                    tripInfoSection
                }
            }

            chatSection
        }
        .navigationTitle(currentSquad.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                joinLeaveButton
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(currentSquad.name)
                    .font(.title2.bold())

                Text(currentSquad.status.label)
                    .font(.caption.bold())
                    .foregroundStyle(currentSquad.status.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(currentSquad.status.color.opacity(0.12))
                    .clipShape(Capsule())

                if currentSquad.isFlash {
                    FlashBadge()
                }
            }

            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(Color.accentRed)
                Text(currentSquad.destination)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("·")
                    .foregroundStyle(.secondary)
                Text(currentSquad.dateRange)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("·")
                    .foregroundStyle(.secondary)
                Text("\(currentSquad.nights)n")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                StyleBadge(style: currentSquad.travelStyle)
                if currentSquad.isWomenOnly {
                    WomenOnlyBadge()
                }
            }

            Text(currentSquad.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground))
    }

    private var infoSection: some View {
        EmptyView()
    }

    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Members")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(currentSquad.members) { member in
                        MemberCard(member: member)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background(Color(UIColor.systemBackground))
    }

    private var tripInfoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Trip Info")
                .font(.headline)

            HStack(spacing: 0) {
                TripInfoTile(icon: "calendar", label: "Start Date", value: {
                    let f = DateFormatter()
                    f.dateStyle = .medium
                    return f.string(from: currentSquad.startDate)
                }())
                Divider().frame(height: 40)
                TripInfoTile(icon: "moon.fill", label: "Duration", value: "\(currentSquad.nights) nights")
                Divider().frame(height: 40)
                TripInfoTile(icon: "person.2.fill", label: "Spots Left", value: currentSquad.isFull ? "Full" : "\(currentSquad.spotsLeft)")
                Divider().frame(height: 40)
                TripInfoTile(icon: currentSquad.isOpenJoin ? "door.left.hand.open" : "lock.fill", label: "Access", value: currentSquad.isOpenJoin ? "Open" : "Invite")
            }
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(16)
        .background(Color(UIColor.systemBackground))
    }

    private var chatSection: some View {
        VStack(spacing: 0) {
            Divider()

            Text("Squad Chat")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(Color(UIColor.systemBackground))

            Divider()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(currentSquad.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .frame(height: 260)
                .background(Color(UIColor.secondarySystemBackground))
                .onAppear {
                    scrollProxy = proxy
                    if let last = currentSquad.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
                .onChange(of: currentSquad.messages.count) { _, _ in
                    if let last = currentSquad.messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            Divider()

            HStack(spacing: 10) {
                TextField("Message the squad...", text: $messageText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(Color(UIColor.systemGroupedBackground))
                    .clipShape(Capsule())
                    .disabled(!currentSquad.hasJoined)

                Button {
                    let trimmed = messageText.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    HapticService.trigger(.selection)
                    SquadStore.shared.sendMessage(squadID: squad.id, text: trimmed)
                    messageText = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(messageText.trimmingCharacters(in: .whitespaces).isEmpty ? .secondary : Color.accentRed)
                }
                .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty || !currentSquad.hasJoined)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
        }
    }

    private var joinLeaveButton: some View {
        Group {
            if currentSquad.hasJoined {
                Button {
                    HapticService.trigger(.selection)
                    SquadStore.shared.leave(id: squad.id)
                } label: {
                    Text("Leave")
                        .foregroundStyle(.secondary)
                }
            } else {
                Button {
                    HapticService.trigger(.success)
                    SquadStore.shared.join(id: squad.id)
                } label: {
                    Text("Join")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentRed)
                }
                .disabled(!currentSquad.isOpenJoin || currentSquad.isFull)
            }
        }
    }
}

private struct MemberCard: View {
    let member: SquadMember

    private let colors: [Color] = [.accentRed, .blue, .green, .orange, .purple, .indigo]
    private var avatarColor: Color { colors[abs(member.id.hashValue) % colors.count] }

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(avatarColor)
                    .frame(width: 54, height: 54)
                    .overlay(
                        Text(member.initials)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    )

                if member.isLead {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.yellow)
                        .offset(x: 4, y: 4)
                }
            }

            VStack(spacing: 3) {
                HStack(spacing: 3) {
                    Text(member.name)
                        .font(.caption.bold())
                        .lineLimit(1)
                    if member.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.blue)
                    }
                }

                if member.isLocal {
                    Text("Local")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())
                }

                if member.tripCount > 0 {
                    Text("\(member.tripCount) trips")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                if member.rating > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", member.rating))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if !member.bio.isEmpty {
                Text(member.bio)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 110)
            }
        }
        .padding(12)
        .background(Color(UIColor.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .frame(width: 130)
    }
}

private struct MessageBubble: View {
    let message: SquadMessage

    var body: some View {
        if message.isSystem {
            Text(message.text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(Color(UIColor.systemGray5))
                .clipShape(Capsule())
                .frame(maxWidth: .infinity)
        } else if message.isCurrentUser {
            HStack {
                Spacer(minLength: 60)
                VStack(alignment: .trailing, spacing: 2) {
                    Text(message.text)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.accentRed)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    Text(message.timeString)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        } else {
            HStack(alignment: .bottom, spacing: 6) {
                Circle()
                    .fill(Color(UIColor.systemGray4))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Text(message.senderInitials)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.secondary)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(message.senderName)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text(message.text)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    Text(message.timeString)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 60)
            }
        }
    }
}

private struct TripInfoTile: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.accentRed)
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        SquadDetailView(squad: TravelSquad.seedSquads[0])
    }
}
