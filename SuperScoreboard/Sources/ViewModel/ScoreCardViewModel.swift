import SwiftUI
import Domain

// MARK: - ScoreCard ViewModel
@Observable
class ScoreCardViewModel {
    
    // MARK: - Properties
    let match: Match
    
    // MARK: - Initialization
    init(match: Match) {
        self.match = match
    }
    
    // MARK: - Team Information
    var teamOneName: String {
        guard match.teams.count > 0 else { return "Unknown" }
        return match.teams[0].team.name
    }
    
    var teamTwoName: String {
        guard match.teams.count > 1 else { return "Unknown" }
        return match.teams[1].team.name
    }
    
    var clubOneName: String {
        guard match.teams.count > 0 else { return "UNK" }
        return match.teams[0].team.club.abbr
    }
    
    var clubTwoName: String {
        guard match.teams.count > 1 else { return "UNK" }
        return match.teams[1].team.club.abbr
    }
    
    // MARK: - Score Information
    var teamOneScore: Int? {
        guard match.teams.count > 0 else { return nil }
        return match.teams[0].score
    }
    
    var teamTwoScore: Int? {
        guard match.teams.count > 1 else { return nil }
        return match.teams[1].score
    }
    
    // MARK: - Display Logic
    var shouldShowScores: Bool {
        return match.status.hasScores
    }
    
    var shouldShowClubNames: Bool {
        return match.status.isActive || match.status.isFinished
    }
    
    var shouldShowKickoffTime: Bool {
        return match.status.isUpcoming
    }
    
    // MARK: - Match Tag Information
    var matchTagText: String {
        if match.status.isActive {
            return match.clock?.label ?? "Live"
        } else if match.status.isUpcoming {
            return kickoffTimeText
        } else {
            // For completed matches, show extra time or "FT"
            return calculateExtraTime() ?? "FT"
        }
    }

    var matchTagColor: Color {
        switch match.status {
        case .upcoming:
            Color(hex: "787880").opacity(0.2)
        case .inProgress:
            Color(hex: "BF1F25")
        case .completed:
            Color.green
        @unknown default:
            Color(hex: "787880").opacity(0.2)
        }
    }
    
    // MARK: - Score Display Text
    func scoreText(for score: Int?) -> String {
        guard let score = score else { return "-" }
        return "\(score)"
    }
    
    // MARK: - Kickoff Time Display
    var kickoffTimeText: String {
        // Try to extract time from millis first
        if let timeFromMillis = extractTimeFromMillis() {
            return timeFromMillis
        }
        
        // Final fallback to the raw label
        return match.kickoff.label
    }
    
    // MARK: - Private Helper Methods
    private func extractTimeFromMillis() -> String? {
        let date = Date(timeIntervalSince1970: TimeInterval(match.kickoff.millis / 1000))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    private func calculateExtraTime() -> String? {
        guard let clock = match.clock else { return nil }
        
        // Standard match duration is 90 minutes (5400 seconds)
        let standardMatchDuration = 5400
        
        // If the match went beyond standard time, calculate extra time
        if clock.secs > standardMatchDuration {
            let extraSeconds = clock.secs - standardMatchDuration
            let extraMinutes = extraSeconds / 60
            let remainingSeconds = extraSeconds % 60
            
            // Format as "+5'00" style
            return String(format: "+%d'%02d", extraMinutes, remainingSeconds)
        }
        
        // If match ended within regular time, show "FT"
        return "FT"
    }
    
    // MARK: - Match Status Helpers
    var isActive: Bool {
        return match.status.isActive
    }
    
    var isUpcoming: Bool {
        return match.status.isUpcoming
    }
    
    var isCompleted: Bool {
        return match.status.isFinished
    }
}
