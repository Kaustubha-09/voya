import SwiftUI

private let unsplashURLs = [
    "https://images.unsplash.com/photo-1476514525405-359c9291c9d3?w=600",
    "https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=600",
    "https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=600",
    "https://images.unsplash.com/photo-1533105079780-92b9be4f5405?w=600",
    "https://images.unsplash.com/photo-1502602687087-c43a99a22c11?w=600",
    "https://images.unsplash.com/photo-1499363536502-87642509e31f?w=600",
]

struct AddStoryView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var destination = ""
    @State private var caption = ""
    @State private var stayName = ""
    @State private var imageURL = unsplashURLs.randomElement() ?? unsplashURLs[0]
    @State private var selectedTripType: TravelStory.TripType = .solo
    @State private var showValidationError = false

    private var canPost: Bool {
        !destination.trimmingCharacters(in: .whitespaces).isEmpty &&
        !caption.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    imagePreview
                    formFields
                }
                .padding()
            }
            .navigationTitle("New Story")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") { postStory() }
                        .fontWeight(.semibold)
                        .foregroundStyle(canPost ? Color.accentRed : Color.secondary)
                        .disabled(!canPost)
                }
            }
            .alert("Please fill in destination and caption.", isPresented: $showValidationError) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    private var imagePreview: some View {
        ZStack {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Color.gray.opacity(0.15)
                        .overlay(Image(systemName: "photo").font(.largeTitle).foregroundStyle(.secondary))
                @unknown default:
                    Color.gray.opacity(0.15)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        imageURL = unsplashURLs.randomElement() ?? unsplashURLs[0]
                        HapticService.trigger(.selection)
                    } label: {
                        Label("Shuffle", systemImage: "arrow.2.circlepath")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.45))
                            .clipShape(Capsule())
                    }
                    .padding(10)
                }
            }
        }
    }

    private var formFields: some View {
        VStack(alignment: .leading, spacing: 20) {
            fieldGroup(title: "Destination") {
                TextField("Where are you?", text: $destination)
                    .textInputAutocapitalization(.words)
            }

            fieldGroup(title: "Caption") {
                TextField("Share your moment…", text: $caption, axis: .vertical)
                    .lineLimit(3...6)
            }

            fieldGroup(title: "Stay (optional)") {
                TextField("Stay name (optional)", text: $stayName)
                    .textInputAutocapitalization(.words)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Trip Type")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Picker("Trip Type", selection: $selectedTripType) {
                    ForEach(TravelStory.TripType.allCases, id: \.self) { type in
                        Text(type.label).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }

            fieldGroup(title: "Photo URL") {
                TextField("Unsplash URL", text: $imageURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func fieldGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            content()
                .padding(12)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    private func postStory() {
        guard canPost else {
            showValidationError = true
            return
        }
        let now = Date.now
        let story = TravelStory(
            id: UUID().uuidString,
            authorName: "You",
            authorInitials: String(destination.prefix(1)).uppercased() + "Y",
            destination: destination.trimmingCharacters(in: .whitespaces),
            stayTitle: stayName.trimmingCharacters(in: .whitespaces).isEmpty ? nil : stayName.trimmingCharacters(in: .whitespaces),
            caption: caption.trimmingCharacters(in: .whitespaces),
            imageURL: imageURL,
            postedAt: now,
            expiresAt: now + 48 * 3600,
            likes: 0,
            isVerified: false,
            tripType: selectedTripType,
            hasViewed: true
        )
        StoryStore.shared.add(story)
        HapticService.trigger(.success)
        dismiss()
    }
}

#Preview {
    AddStoryView()
}
