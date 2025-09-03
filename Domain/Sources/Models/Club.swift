public struct Club: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let abbr: String
    public let shortName: String?
}
