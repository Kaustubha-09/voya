import SwiftUI

struct StoryDetailView: View {
    @ObservedObject var viewModel: StoriesViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var progress: CGFloat = 0
    @State private var isLiked = false
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    private let storyDuration: CGFloat = 5.0
    private let tickInterval: CGFloat = 0.05

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let story = viewModel.selectedStory {
                storyContent(story: story)
            }
        }
        .statusBar(hidden: true)
        .gesture(
            DragGesture(minimumDistance: 40, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height > 80 {
                        dismiss()
                    }
                }
        )
        .onReceive(timer) { _ in
            guard viewModel.selectedStory != nil else { return }
            progress += tickInterval / storyDuration
            if progress >= 1.0 {
                advanceOrDismiss()
            }
        }
        .onChange(of: viewModel.selectedStory?.id) { _ in
            isLiked = false
            progress = 0
        }
    }

    @ViewBuilder
    private func storyContent(story: TravelStory) -> some View {
        ZStack {
            AsyncImage(url: URL(string: story.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Color.gray.opacity(0.3)
                case .empty:
                    Color.black
                        .overlay(ProgressView().tint(.white))
                @unknown default:
                    Color.black
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .ignoresSafeArea()

            topGradient
            bottomGradient

            VStack(spacing: 0) {
                progressBarsRow(story: story)
                    .padding(.top, 56)
                    .padding(.horizontal, 12)

                topOverlay(story: story)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)

                Spacer()

                bottomOverlay(story: story)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 48)
            }

            tapZones
        }
    }

    private var topGradient: some View {
        LinearGradient(
            colors: [Color.black.opacity(0.6), Color.clear],
            startPoint: .top,
            endPoint: .center
        )
        .ignoresSafeArea()
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private var bottomGradient: some View {
        LinearGradient(
            colors: [Color.clear, Color.black.opacity(0.7)],
            startPoint: .center,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private func progressBarsRow(story: TravelStory) -> some View {
        let stories = viewModel.activeStories
        let currentIdx = stories.firstIndex(where: { $0.id == story.id }) ?? 0

        return HStack(spacing: 4) {
            ForEach(Array(stories.enumerated()), id: \.offset) { idx, _ in
                progressSegment(for: idx, currentIdx: currentIdx)
            }
        }
        .frame(height: 2.5)
    }

    private func progressSegment(for idx: Int, currentIdx: Int) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.35))
                Capsule()
                    .fill(Color.white)
                    .frame(width: segmentWidth(geo: geo, idx: idx, currentIdx: currentIdx))
            }
        }
    }

    private func segmentWidth(geo: GeometryProxy, idx: Int, currentIdx: Int) -> CGFloat {
        if idx < currentIdx { return geo.size.width }
        if idx == currentIdx { return geo.size.width * progress }
        return 0
    }

    private func topOverlay(story: TravelStory) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.accentRed)
                    .frame(width: 36, height: 36)
                Text(story.authorInitials)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 4) {
                    Text(story.authorName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    if story.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                HStack(spacing: 4) {
                    Text(story.destination)
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.85))
                    Text("·")
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.6))
                    Text(story.timeAgo)
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.6))
                }
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }

    private func bottomOverlay(story: TravelStory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let stayTitle = story.stayTitle {
                Text(stayTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white.opacity(0.75))
            }

            Text(story.caption)
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                Label(story.tripType.label, systemImage: story.tripType.icon)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())

                Spacer()

                likeButton(story: story)
            }
        }
    }

    private func likeButton(story: TravelStory) -> some View {
        Button {
            HapticService.trigger(.success)
            isLiked.toggle()
            StoryStore.shared.toggleLike(id: story.id)
        } label: {
            HStack(spacing: 5) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundStyle(isLiked ? Color.accentRed : .white)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isLiked)
                Text("\(story.likes + (isLiked ? 1 : 0))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
        }
    }

    private var tapZones: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    progress = 0
                    viewModel.prevStory()
                }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    advanceOrDismiss()
                }
        }
    }

    private func advanceOrDismiss() {
        progress = 0
        let stories = viewModel.activeStories
        guard let current = viewModel.selectedStory,
              let idx = stories.firstIndex(where: { $0.id == current.id }) else {
            dismiss()
            return
        }
        if idx + 1 < stories.count {
            viewModel.nextStory()
        } else {
            dismiss()
        }
    }
}

#Preview {
    let vm = StoriesViewModel()
    vm.selectedStory = TravelStory.seedStories.first
    return StoryDetailView(viewModel: vm)
}
