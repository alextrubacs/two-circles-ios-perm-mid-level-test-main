/// A `DataSource` that provides a single predefined value or throws an error.
///
/// `SingleValueDataSource` is a simple data source that immediately returns a fixed value
/// or fails with an error when `execute()` is called. This makes it useful for:
/// - **Static data providers**: Returning a fixed value that does not require asynchronous retrieval.
/// - **Stubbing responses**: Simulating a data source without real network or database calls.
/// - **Testing**: Providing predictable values for unit tests.
///
/// ## Usage
///
/// ### Creating a Successful Data Source:
/// ```swift
/// let dataSource = SingleValueDataSource(42)
///
/// let value = try await dataSource.execute()
/// print("Value:", value) // Prints: Value: 42
/// ```
public struct SingleValueDataSource<Output: Sendable>: DataSource {

    private let value: Result<Output, Error>

    public init(_ value: Output) {
        self.value = .success(value)
    }

    public init(error: any Error) {
        self.value = .failure(error)
    }

    public func execute() async throws -> Output {
        switch value {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
