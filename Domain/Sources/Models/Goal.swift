public struct Goal: Decodable, Sendable {
    public let personId: Int
    public let assistId: Int?
    public let clock: Clock
    public let phase: String
    public let type: String
    public let description: String
}
