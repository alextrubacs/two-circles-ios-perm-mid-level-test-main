import Foundation
import Domain

// MARK: - Mock Data Manager
class MockData {
    
    // MARK: - Properties
    private static var _matches: [Match]?
    
    /// Lazy-loaded array of mock matches from JSON
    static var matches: [Match] {
        if let cached = _matches {
            return cached
        }
        
        let loaded = loadMatches()
        _matches = loaded
        return loaded
    }
    
    // MARK: - Individual Match Accessors
    static var liveMatch: Match {
        matches.first { $0.status == .inProgress && $0.id == 1 } ?? matches[0]
    }
    
    static var upcomingMatch: Match {
        matches.first { $0.status == .upcoming } ?? matches[1]
    }
    
    static var finishedMatch: Match {
        matches.first { $0.status == .completed && $0.id == 3 } ?? matches[2]
    }
    
    static var highScoringMatch: Match {
        matches.first { $0.id == 4 } ?? matches[3]
    }
    
    static var penaltyMatch: Match {
        matches.first { $0.clock?.label == "Pens" } ?? matches[4]
    }
    
    // MARK: - JSON Loading
    private static func loadMatches() -> [Match] {
        guard let url = Bundle.main.url(forResource: "mock_matches", withExtension: "json") else {
            print("❌ MockData: Could not find mock_matches.json in bundle")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let matches = try decoder.decode([Match].self, from: data)
            print("✅ MockData: Successfully loaded \(matches.count) mock matches")
            return matches
        } catch {
            print("❌ MockData: Failed to decode mock_matches.json - \(error)")
            return []
        }
    }
    
    // MARK: - Convenience Methods
    
    /// Get a random match
    static var randomMatch: Match {
        matches.randomElement() ?? liveMatch
    }
    
    /// Get matches by status
    static func matches(withStatus status: MatchStatus) -> [Match] {
        matches.filter { $0.status == status }
    }
    
    /// Get live matches
    static var liveMatches: [Match] {
        matches(withStatus: .inProgress)
    }
    
    /// Get upcoming matches
    static var upcomingMatches: [Match] {
        matches(withStatus: .upcoming)
    }
    
    /// Get finished matches
    static var finishedMatches: [Match] {
        matches(withStatus: .completed)
    }
}

// MARK: - Preview Helpers
extension MockData {
    
    /// Sample matches for different preview scenarios
    struct Previews {
        static let liveScenario = MockData.liveMatch
        static let upcomingScenario = MockData.upcomingMatch
        static let finishedScenario = MockData.finishedMatch
        static let highScoreScenario = MockData.highScoringMatch
        static let penaltyScenario = MockData.penaltyMatch
        
        /// All scenarios for comprehensive preview
        static let allScenarios = [
            liveScenario,
            upcomingScenario,
            finishedScenario,
            highScoreScenario,
            penaltyScenario
        ]
    }
}
