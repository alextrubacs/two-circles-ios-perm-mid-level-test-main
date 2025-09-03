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
        matches.first { $0.status == .inProgress && $0.id == 1 } ?? 
        matches.first { $0.status == .inProgress } ?? 
        matches.first ?? createFallbackMatch(.inProgress)
    }
    
    static var upcomingMatch: Match {
        matches.first { $0.status == .upcoming } ?? 
        matches.first ?? createFallbackMatch(.upcoming)
    }
    
    static var finishedMatch: Match {
        matches.first { $0.status == .completed && $0.id == 3 } ?? 
        matches.first { $0.status == .completed } ?? 
        matches.first ?? createFallbackMatch(.completed)
    }
    
    static var highScoringMatch: Match {
        matches.first { $0.id == 4 } ?? 
        matches.first ?? createFallbackMatch(.inProgress)
    }
    
    static var penaltyMatch: Match {
        matches.first { $0.clock?.label == "Pens" } ?? 
        matches.first ?? createFallbackMatch(.completed)
    }
    
    // MARK: - Fallback Match Creation
    static func createFallbackMatch(_ status: MatchStatus = .inProgress) -> Match {
        let statusValue = status.rawValue
        let hasScores = status.hasScores
        let scoreValue = hasScores ? "1" : "null"
        let clockValue = status.isActive ? """
            "clock": {
                "secs": 1800,
                "label": "30'"
            },
        """ : ""
        
        let jsonString = """
        {
            "id": 999,
            "kickoff": {
                "completeness": 3,
                "millis": 1704722400000,
                "label": "\(status == .upcoming ? "15:00" : "Live")"
            },
            "competition": {
                "id": 1,
                "title": "Test League"
            },
            "teams": [
                {
                    "team": {
                        "id": 1,
                        "name": "Team A",
                        "shortName": "TEA",
                        "teamType": "FIRST",
                        "club": {
                            "id": 1,
                            "name": "Team A",
                            "abbr": "TEA",
                            "shortName": "Team A"
                        },
                        "altIds": {
                            "opta": "t1"
                        }
                    },
                    "score": \(scoreValue)
                },
                {
                    "team": {
                        "id": 2,
                        "name": "Team B",
                        "shortName": "TEB",
                        "teamType": "FIRST",
                        "club": {
                            "id": 2,
                            "name": "Team B",
                            "abbr": "TEB",
                            "shortName": "Team B"
                        },
                        "altIds": {
                            "opta": "t2"
                        }
                    },
                    "score": 0
                }
            ],
            "ground": {
                "id": 1,
                "name": "Test Stadium",
                "city": "Test City",
                "source": "test"
            },
            "status": "\(statusValue)",
            \(clockValue)
            "attendance": \(hasScores ? "1000" : "null"),
            "goals": null
        }
        """
        
        do {
            let data = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            return try decoder.decode(Match.self, from: data)
        } catch {
            print("❌ MockData: Failed to create fallback match - \(error)")
            // If even this fails, we have a serious problem
            // Return the first match from the array if it exists, otherwise crash intentionally
            // This should never happen in practice
            fatalError("Unable to create fallback match: \(error)")
        }
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
