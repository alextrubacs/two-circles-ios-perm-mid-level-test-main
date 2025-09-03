import SwiftUI
import Domain

// MARK: - ScoreCard ViewModel
@Observable
class ScoreCardViewModel {
    
    // MARK: - Properties
    private let match: Match
    
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
            return match.kickoff.label
        } else {
            return match.clock?.label ?? "FT"
        }
    }

    var matchTagColor: Color {
        match.status == .inProgress ? Color(hex: "BF1F25") : Color.secondary
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
