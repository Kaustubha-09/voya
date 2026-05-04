import SwiftUI

@MainActor final class SquadViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var searchDestination = ""
    @Published var selectedStyle: TravelSquad.TravelStyle? = nil
    @Published var womenOnlyFilter = false
    @Published var showCreateSquad = false
    @Published var showFlashAlert = false

    @Published var createName = ""
    @Published var createDestination = ""
    @Published var createStartDate = Date.now.addingTimeInterval(86400 * 14)
    @Published var createEndDate = Date.now.addingTimeInterval(86400 * 21)
    @Published var createDescription = ""
    @Published var createTravelStyle: TravelSquad.TravelStyle = .mixed
    @Published var createMaxMembers = 6
    @Published var createIsWomenOnly = false
    @Published var createIsOpenJoin = true

    var filteredDiscover: [TravelSquad] {
        var results = SquadStore.shared.discoverSquads
        if !searchDestination.isEmpty {
            results = results.filter { $0.destination.localizedCaseInsensitiveContains(searchDestination) }
        }
        if let style = selectedStyle {
            results = results.filter { $0.travelStyle == style }
        }
        if womenOnlyFilter {
            results = results.filter { $0.isWomenOnly }
        }
        return results
    }

    func createSquad() {
        let newSquad = TravelSquad(
            id: UUID().uuidString,
            name: createName,
            destination: createDestination,
            startDate: createStartDate,
            endDate: createEndDate,
            description: createDescription,
            travelStyle: createTravelStyle,
            maxMembers: createMaxMembers,
            isWomenOnly: createIsWomenOnly,
            isOpenJoin: createIsOpenJoin,
            members: [
                SquadMember(
                    id: "member_you_lead",
                    name: "You",
                    initials: "YO",
                    isVerified: false,
                    isLocal: false,
                    isLead: true,
                    tripCount: 0,
                    rating: 0.0,
                    bio: "",
                    homeCity: "",
                    travelStyle: createTravelStyle
                )
            ],
            messages: [
                SquadMessage(
                    id: UUID().uuidString,
                    senderName: "System",
                    senderInitials: "",
                    text: "You created this squad.",
                    sentAt: Date.now,
                    isSystem: true,
                    isCurrentUser: false
                )
            ],
            status: .forming,
            hasJoined: true
        )
        SquadStore.shared.create(newSquad)
        resetForm()
    }

    private func resetForm() {
        createName = ""
        createDestination = ""
        createStartDate = Date.now.addingTimeInterval(86400 * 14)
        createEndDate = Date.now.addingTimeInterval(86400 * 21)
        createDescription = ""
        createTravelStyle = .mixed
        createMaxMembers = 6
        createIsWomenOnly = false
        createIsOpenJoin = true
    }
}
