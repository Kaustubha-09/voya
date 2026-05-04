import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isEditing = false
    @Published var isSaving  = false
    @Published var saveError: String? = nil
    @Published var showSignOutAlert = false

    // Edit form fields
    @Published var editFirstName  = ""
    @Published var editLastName   = ""
    @Published var editPhone      = ""
    @Published var editBio        = ""
    @Published var selectedPhoto: PhotosPickerItem? = nil

    init(user: User) {
        self.user = user
    }

    var tripCount: Int { BookingStore.shared.bookings.count }
    var completedTrips: Int { BookingStore.shared.past.count }

    func startEditing() {
        editFirstName = user.firstName
        editLastName  = user.lastName
        editPhone     = user.phone
        editBio       = user.bio
        isEditing     = true
    }

    func cancelEditing() {
        isEditing = false
        saveError = nil
    }

    func saveProfile(appState: AppStateManager) async {
        isSaving = true
        defer { isSaving = false }
        // Simulate network call
        try? await Task.sleep(for: .milliseconds(800))
        user.firstName = editFirstName.trimmingCharacters(in: .whitespaces)
        user.lastName  = editLastName.trimmingCharacters(in: .whitespaces)
        user.phone     = editPhone
        user.bio       = editBio
        appState.updateUser(user)
        HapticService.trigger(.success)
        isEditing = false
    }

    var avatarGradient: LinearGradient {
        LinearGradient(
            colors: [Color.accentRed, Color.accentRed.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
