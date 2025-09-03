import Foundation

/// A `DataSource` that fetches data from a remote endpoint using a `Client`.
///
/// `RemoteDataSource` is a flexible data source designed for retrieving values from an external
/// resource, such as a web API. It leverages a provided `Client` to perform the network request
/// and decode the response into a specified `Decodable` type.
///
/// This makes it useful for:
/// - **Network-driven data providers**: Retrieving and decoding JSON or other data formats.
/// - **Integration with APIs**: Encapsulating remote requests as data sources.
/// - **Composable pipelines**: Allowing remote calls to be combined with other `DataSource`
///   types for modular data fetching strategies.
///
/// ## Type Parameters
/// - `T`: The type of value returned by the data source. Must conform to `Decodable` and `Sendable`.
///
/// ## Usage
///
/// ### Creating a Remote Data Source:
/// ```swift
/// struct User: Decodable, Sendable {
///     let id: Int
///     let name: String
/// }
///
/// let client = URLSessionClient() // Your networking client
/// let url = URL(string: "https://api.example.com/user/1")!
///
/// let dataSource = RemoteDataSource<User>(client: client, url: url)
///
/// do {
///     let user = try await dataSource.execute()
///     print("Fetched user:", user)
/// } catch {
///     print("Failed to fetch user:", error)
/// }
/// ```
public struct RemoteDataSource<T: Decodable & Sendable>: DataSource {

    private let client: Client

    private let url: URL

    public init(client: Client, url: URL) {
        self.client = client
        self.url = url
    }

    public func execute() async throws -> T {
        try await client.request(url)
    }
}
