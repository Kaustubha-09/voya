import SwiftUI

struct StoriesBarView: View {
    let stories: [TravelStory]
    let onTap: (TravelStory) -> Void
    var onAddTap: (() -> Void)? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                addStoryButton
                ForEach(stories) { story in
                    StoryCircle(story: story)
                        .onTapGesture {
                            HapticService.trigger(.selection)
                            onTap(story)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private var addStoryButton: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Color.accentRed)
                    .frame(width: 64, height: 64)
                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(.white)
            }
            Text("Add Story")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 64)
        }
        .onTapGesture {
            HapticService.trigger(.selection)
            onAddTap?()
        }
    }
}

private struct StoryCircle: View {
    let story: TravelStory

    private var ringGradient: LinearGradient {
        LinearGradient(
            colors: story.hasViewed
                ? [Color.gray.opacity(0.4), Color.gray.opacity(0.4)]
                : [Color.accentRed, .orange],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .stroke(ringGradient, lineWidth: story.hasViewed ? 2 : 3)
                    .frame(width: 68, height: 68)

                Circle()
                    .fill(Color.accentRed.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Text(story.authorInitials)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.accentRed)
                    }

                if story.isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.blue)
                        .background(Circle().fill(Color.white).padding(-2))
                        .offset(x: 2, y: 2)
                }
            }

            Text(story.destination)
                .font(.caption2)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 64)
        }
    }
}

#Preview {
    StoriesBarView(stories: TravelStory.seedStories, onTap: { _ in })
        .padding(.vertical)
}
