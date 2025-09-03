import Foundation

// MARK: - Match Status Enum
public enum MatchStatus: String, Decodable, CaseIterable, Sendable {
    case upcoming = "U"
    case inProgress = "I" 
    case completed = "C"
    
    /// Human-readable description of the status
    public var description: String {
        switch self {
        case .upcoming:
            return "Upcoming"
        case .inProgress:
            return "Live"
        case .completed:
            return "Finished"
        }
    }
    
    /// Whether the match has scores available
    public var hasScores: Bool {
        switch self {
        case .upcoming:
            return false
        case .inProgress, .completed:
            return true
        }
    }
    
    /// Whether the match is currently active
    public var isActive: Bool {
        return self == .inProgress
    }
    
    /// Whether the match is finished
    public var isFinished: Bool {
        return self == .completed
    }
    
    /// Whether the match is scheduled for the future
    public var isUpcoming: Bool {
        return self == .upcoming
    }
}
