import Foundation
import SwiftUI

@MainActor final class PlaybookViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedTripType: Playbook.TripType? = nil
    @Published var showCreate = false
    @Published var selectedDuration: Int? = nil

    @Published var destination = ""
    @Published var title = ""
    @Published var tripType: Playbook.TripType = .solo
    @Published var duration: Int = 7
    @Published var authorName = ""
    @Published var budgetMin = ""
    @Published var budgetMax = ""
    @Published var bestTimeToVisit = ""
    @Published var selectedTags: Set<String> = []
    @Published var packingList: [String] = []
    @Published var packingInput = ""

    private let store = PlaybookStore.shared

    var filteredPlaybooks: [Playbook] {
        store.playbooks.filter { playbook in
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch = playbook.destination.localizedCaseInsensitiveContains(searchText)
                    || playbook.title.localizedCaseInsensitiveContains(searchText)
            }

            let matchesTripType: Bool
            if let type = selectedTripType {
                matchesTripType = playbook.tripType == type
            } else {
                matchesTripType = true
            }

            let matchesDuration: Bool
            if let dur = selectedDuration {
                switch dur {
                case 3:  matchesDuration = playbook.duration <= 3
                case 5:  matchesDuration = playbook.duration >= 4 && playbook.duration <= 7
                case 7:  matchesDuration = playbook.duration >= 4 && playbook.duration <= 7
                case 10: matchesDuration = playbook.duration >= 8 && playbook.duration <= 14
                case 14: matchesDuration = playbook.duration > 14
                default: matchesDuration = true
                }
            } else {
                matchesDuration = true
            }

            return matchesSearch && matchesTripType && matchesDuration
        }
    }

    func addPackingItem() {
        let trimmed = packingInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        packingList.append(trimmed)
        packingInput = ""
        HapticService.trigger(.selection)
    }

    func removePackingItem(at offsets: IndexSet) {
        packingList.remove(atOffsets: offsets)
    }

    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
        HapticService.trigger(.selection)
    }

    func savePlaybook() {
        let minBudget = Double(budgetMin) ?? 0
        let maxBudget = Double(budgetMax) ?? 0
        let name = authorName.isEmpty ? "Anonymous" : authorName
        let initials = name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0) }
            .joined()
            .uppercased()
        let playbook = Playbook(
            id: UUID().uuidString,
            title: title.isEmpty ? "\(duration) Days in \(destination)" : title,
            destination: destination,
            coverImageURL: "https://images.unsplash.com/photo-1533105079780-92b9be4f5405?w=800&q=80",
            authorName: name,
            authorInitials: initials.isEmpty ? "ME" : initials,
            authorIsVerified: false,
            tripType: tripType,
            duration: duration,
            days: [],
            tips: [],
            budgetMin: minBudget,
            budgetMax: maxBudget,
            bestTimeToVisit: bestTimeToVisit,
            packingList: packingList,
            rating: 0,
            ratingCount: 0,
            forkCount: 0,
            viewCount: 0,
            createdAt: Date(),
            lastUpdated: Date(),
            tags: Array(selectedTags)
        )
        store.add(playbook)
        HapticService.trigger(.success)
        resetCreateForm()
        showCreate = false
    }

    private func resetCreateForm() {
        destination = ""
        title = ""
        tripType = .solo
        duration = 7
        authorName = ""
        budgetMin = ""
        budgetMax = ""
        bestTimeToVisit = ""
        selectedTags = []
        packingList = []
        packingInput = ""
    }
}
