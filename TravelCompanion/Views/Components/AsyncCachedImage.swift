import SwiftUI

/// Loads a remote image with in-memory caching.
/// Shows a skeleton placeholder while loading.
struct AsyncCachedImage: View {
    let urlString: String
    var contentMode: ContentMode = .fill

    @StateObject private var loader: ImageLoader

    init(urlString: String, contentMode: ContentMode = .fill) {
        self.urlString = urlString
        self.contentMode = contentMode
        _loader = StateObject(wrappedValue: ImageLoader(urlString: urlString))
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                ZStack {
                    Color.subtleGray
                    if loader.isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                            .font(.title2)
                    }
                }
            }
        }
        .task { await loader.load() }
    }
}

#Preview {
    AsyncCachedImage(urlString: "https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=400")
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
}
