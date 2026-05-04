import SwiftUI

struct EditProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    @EnvironmentObject private var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        ZStack {
                            LinearGradient(
                                colors: [Color.accentRed, Color.accentRed.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(Circle())
                            Text(vm.user.initials)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 88, height: 88)
                        .overlay(alignment: .bottomTrailing) {
                            ZStack {
                                Circle().fill(Color.accentRed)
                                Image(systemName: "camera.fill")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 28, height: 28)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }

                Section("Name") {
                    TextField("First name", text: $vm.editFirstName)
                    TextField("Last name",  text: $vm.editLastName)
                }

                Section("Contact") {
                    TextField("Phone number", text: $vm.editPhone)
                        .keyboardType(.phonePad)
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(vm.user.email)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }

                Section("About") {
                    TextField("Bio", text: $vm.editBio, axis: .vertical)
                        .lineLimit(3...6)
                }

                if let err = vm.saveError {
                    Section {
                        Text(err).foregroundStyle(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        vm.cancelEditing()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await vm.saveProfile(appState: appState)
                            dismiss()
                        }
                    } label: {
                        if vm.isSaving {
                            ProgressView().tint(Color.accentRed)
                        } else {
                            Text("Save").fontWeight(.semibold)
                        }
                    }
                    .disabled(vm.isSaving)
                }
            }
        }
    }
}

#Preview {
    EditProfileView(vm: ProfileViewModel(user: .placeholder))
        .environmentObject(AppStateManager())
}
