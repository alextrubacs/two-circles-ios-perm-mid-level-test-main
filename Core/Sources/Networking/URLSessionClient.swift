import Foundation

public actor URLSessionClient: Client {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable & Sendable>(_ url: URL, decoder: JSONDecoder) async throws -> T {

        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)

        let value = try decoder.decode(T.self, from: data)

        return value
    }
}
