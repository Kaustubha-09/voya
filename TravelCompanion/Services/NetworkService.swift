import Foundation

// MARK: - Network Errors

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case serverError(Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL was invalid."
        case .noData: return "No data was received from the server."
        case .decodingFailed: return "Failed to parse the server response."
        case .serverError(let code): return "Server returned error code \(code)."
        case .unknown(let error): return error.localizedDescription
        }
    }
}

// MARK: - Network Service Protocol (for testability)

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

// MARK: - Concrete Implementation

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
