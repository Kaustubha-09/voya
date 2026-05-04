import SwiftUI

struct CreateSquadView: View {
    @ObservedObject var vm: SquadViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Squad Details") {
                    TextField("Squad name", text: $vm.createName)
                    TextField("Destination", text: $vm.createDestination)
                        .autocorrectionDisabled()
                }

                Section("Dates") {
                    DatePicker("Start Date", selection: $vm.createStartDate, in: Date.now..., displayedComponents: .date)
                    DatePicker("End Date", selection: $vm.createEndDate, in: vm.createStartDate..., displayedComponents: .date)
                }

                Section("About this trip") {
                    ZStack(alignment: .topLeading) {
                        if vm.createDescription.isEmpty {
                            Text("Tell people what this trip is about...")
                                .foregroundStyle(.tertiary)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $vm.createDescription)
                            .frame(minHeight: 100, maxHeight: 160)
                    }
                }

                Section("Travel Style") {
                    Picker("Style", selection: $vm.createTravelStyle) {
                        ForEach(TravelSquad.TravelStyle.allCases) { style in
                            Label(style.label, systemImage: style.icon)
                                .tag(style)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.accentRed)
                }

                Section("Squad Size") {
                    Stepper("Max \(vm.createMaxMembers) members", value: $vm.createMaxMembers, in: 2...12)
                }

                Section("Settings") {
                    Toggle(isOn: $vm.createIsWomenOnly) {
                        Label("Women Only", systemImage: "person.fill")
                    }
                    .tint(.pink)

                    Toggle(isOn: $vm.createIsOpenJoin) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(vm.createIsOpenJoin ? "Anyone can join" : "I'll approve members")
                                .font(.subheadline)
                            Text(vm.createIsOpenJoin ? "Open to all travellers" : "You review each request")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .tint(.accentRed)
                }

                Section {
                    Button {
                        HapticService.trigger(.success)
                        vm.createSquad()
                        dismiss()
                    } label: {
                        Text("Create Squad")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                    }
                    .listRowBackground(createButtonBackground)
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("New Squad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var isFormValid: Bool {
        !vm.createName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !vm.createDestination.trimmingCharacters(in: .whitespaces).isEmpty &&
        vm.createEndDate > vm.createStartDate
    }

    private var createButtonBackground: some View {
        Group {
            if isFormValid {
                Color.accentRed
            } else {
                Color.secondary.opacity(0.3)
            }
        }
    }
}

#Preview {
    CreateSquadView(vm: SquadViewModel())
}
