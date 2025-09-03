public struct Match: Decodable, Sendable {
    public let id: Int
    public let kickoff: Kickoff
    public let competition: Competition?
    public let teams: [MatchTeam]
    public let ground: Ground
    public let status: String
    public let attendance: Int?
    public let clock: Clock?
    public let goals: [Goal]?
}
