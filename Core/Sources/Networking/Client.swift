import Foundation

public protocol Client: AnyObject, Sendable {

    func request<T: Decodable & Sendable>(_ url: URL, decoder: JSONDecoder) async throws -> T
}

// MARK: - Default Implementation

extension Client {
    public func request<T: Decodable>(_ url: URL, decoder: JSONDecoder = .init()) async throws -> T {
        try await request(url, decoder: decoder)
    }
}
