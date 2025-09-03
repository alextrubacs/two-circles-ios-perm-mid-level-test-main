public struct Team: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let shortName: String
    public let teamType: String
    public let club: Club
    public let altIds: AltIds?
}
