import Foundation

// MARK: - Cache Protocol

protocol CacheServiceProtocol {
    func get<T: Codable>(forKey key: String) -> T?
    func set<T: Codable>(_ value: T, forKey key: String)
    func remove(forKey key: String)
    func clearAll()
}

// MARK: - Two-tier Cache: in-memory + disk

final class CacheService: CacheServiceProtocol {
    static let shared = CacheService()

    private var memoryCache: [String: Data] = [:]
    private let diskURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    // Cache entries expire after 5 minutes
    private let ttl: TimeInterval = 300
    private var timestamps: [String: Date] = [:]

    init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskURL = caches.appendingPathComponent("TravelCompanion", isDirectory: true)
        try? FileManager.default.createDirectory(at: diskURL, withIntermediateDirectories: true)
    }

    func get<T: Codable>(forKey key: String) -> T? {
        // Check TTL
        if let ts = timestamps[key], Date().timeIntervalSince(ts) > ttl {
            remove(forKey: key)
            return nil
        }

        // 1. Check memory cache first (fastest)
        if let data = memoryCache[key] {
            return try? decoder.decode(T.self, from: data)
        }

        // 2. Fall through to disk
        let file = diskURL.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: file) else { return nil }
        let value = try? decoder.decode(T.self, from: data)

        // Warm the memory cache from disk
        if value != nil { memoryCache[key] = data }
        return value
    }

    func set<T: Codable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        memoryCache[key] = data
        timestamps[key] = Date()
        // Write to disk asynchronously so it does not block the main thread
        let file = diskURL.appendingPathComponent(key)
        Task.detached(priority: .background) {
            try? data.write(to: file, options: .atomic)
        }
    }

    func remove(forKey key: String) {
        memoryCache.removeValue(forKey: key)
        timestamps.removeValue(forKey: key)
        let file = diskURL.appendingPathComponent(key)
        try? FileManager.default.removeItem(at: file)
    }

    func clearAll() {
        memoryCache.removeAll()
        timestamps.removeAll()
        try? FileManager.default.removeItem(at: diskURL)
        try? FileManager.default.createDirectory(at: diskURL, withIntermediateDirectories: true)
    }
}
