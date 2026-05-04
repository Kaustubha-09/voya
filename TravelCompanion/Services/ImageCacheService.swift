import SwiftUI

// MARK: - Lightweight image cache backed by NSCache (memory only)

final class ImageCacheService {
    static let shared = ImageCacheService()

    private let cache = NSCache<NSString, UIImage>()

    init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }

    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        let cost = Int(image.size.width * image.size.height * 4)
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
}

// MARK: - Async image loader ViewModel

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false

    private let urlString: String
    private let cache = ImageCacheService.shared

    init(urlString: String) {
        self.urlString = urlString
    }

    func load() async {
        guard image == nil else { return }

        if let cached = cache.get(forKey: urlString) {
            image = cached
            return
        }

        guard let url = URL(string: urlString) else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let loaded = UIImage(data: data) {
                cache.set(loaded, forKey: urlString)
                image = loaded
            }
        } catch {
            // Silently ignore image load failures; the placeholder stays visible
        }
    }
}
