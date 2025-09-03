/// A protocol for asynchronous data retrieval operations.
///
/// The `DataSource` protocol is a blueprint for creating objects capable of fetching or retrieving data
/// asynchronously. Each conforming type must specify an associated `Output` type that represents the
/// result of the operation and provide an implementation of the `execute` method to perform the operation.
///
/// # Conforming to `DataSource`
/// To conform to `DataSource`, a type must specify an associated `Output` type that conforms to
/// `Sendable`. The type must also implement the `execute()` method, which asynchronously produces
/// a value of the associated `Output` type or throws an error.
///
/// # Examples
///
/// ## Example 1: Simple In-Memory Data Source
/// A data source that simply returns a hardcoded value.
/// ```swift
/// public struct InMemoryDataSource<Output: Sendable>: DataSource {
///
///     private let value: Output
///
///     public init(value: Output) {
///         self.value = value
///     }
///
///     public func execute() async throws -> Output {
///         return value
///     }
/// }
///
/// // Usage
/// let dataSource = InMemoryDataSource(value: "Hello, DataSource!")
/// let result = try await dataSource.execute()
/// print(result) // "Hello, DataSource!"
/// ```
///
/// ## Example 2: Data Source with Side Effects
/// A data source that simulates a delay before returning a result.
/// ```swift
/// public struct DelayedDataSource<Output: Sendable>: DataSource {
///
///     private let value: Output
///     private let delay: TimeInterval
///
///     public init(value: Output, delay: TimeInterval) {
///         self.value = value
///         self.delay = delay
///     }
///
///     public func execute() async throws -> Output {
///         try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
///         return value
///     }
/// }
///
/// // Usage
/// let dataSource = DelayedDataSource(value: 42, delay: 2.0)
/// let result = try await dataSource.execute()
/// print(result) // prints "42" after a 2 second delay
/// ```
public protocol DataSource<Output>: Sendable {

    /// The type of value produced by the data source.
    associatedtype Output: Sendable

    /// Executes the data source to produce an output value.
    ///
    /// This method performs the operation defined by the data source, which may involve asynchronous
    /// work such as fetching data from a remote server or querying a database. If the operation fails, it
    /// throws an error.
    ///
    /// - Returns: The result of the operation as an instance of the associated `Output` type.
    /// - Throws: An error if the operation fails.
    func execute() async throws -> Output
}
