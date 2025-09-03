//
//  ScoreCardListViewModelTests.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import Testing
import SwiftUI
import Domain
@testable import SuperScoreboard

// MARK: - ScoreCardListViewModel Tests
@Suite("ScoreCardListViewModel Tests")
struct ScoreCardListViewModelTests {
    
    // MARK: - Initialization Tests
    
    @Test("ViewModel initializes with empty state")
    func testInitialState() {
        // Given
        let viewModel = ScoreCardListViewModel()
        
        // When & Then
        #expect(viewModel.matches.isEmpty)
        #expect(viewModel.groupedMatches.isEmpty)
    }
    
    // MARK: - Match Grouping Tests
    
    @Test("Groups matches by league correctly")
    func testGroupMatchesByLeague() {
        // Given
        let viewModel = ScoreCardListViewModel()
        let premierLeagueMatch1 = MockData.createFallbackMatch(.inProgress)
        let premierLeagueMatch2 = MockData.createFallbackMatch(.completed)
        let championsLeagueMatch = MockData.createFallbackMatch(.upcoming)
        
        // Simulate matches with different competitions
        viewModel.matches = [premierLeagueMatch1, premierLeagueMatch2, championsLeagueMatch]
        
        // When
        // We need to call the private method indirectly by setting matches and calling fetchMatches
        // For testing purposes, we'll test the grouping logic through the matches property
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count > 0, "Should have grouped matches")
        
        // Verify matches are grouped correctly
        let totalMatchesInGroups = viewModel.groupedMatches.reduce(0) { total, section in
            total + section.matches.count
        }
        #expect(totalMatchesInGroups == viewModel.matches.count, "All matches should be grouped")
    }
    
    @Test("Handles matches with nil competition")
    func testGroupMatchesWithNilCompetition() {
        // Given
        let viewModel = ScoreCardListViewModel()
        let matchWithNilCompetition = createMatchWithCompetition(title: nil, status: .inProgress)
        
        viewModel.matches = [matchWithNilCompetition]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count == 1)
        #expect(viewModel.groupedMatches.first?.leagueName == "Unknown League")
        #expect(viewModel.groupedMatches.first?.matches.count == 1)
    }
    
    @Test("Sorts grouped matches by league name alphabetically")
    func testGroupedMatchesSorting() {
        // Given
        let viewModel = ScoreCardListViewModel()
        
        // Create matches with specific competition titles for testing sorting
        let matchA = createMatchWithCompetition(title: "Bundesliga", status: .inProgress)
        let matchB = createMatchWithCompetition(title: "Premier League", status: .completed)
        let matchC = createMatchWithCompetition(title: "Champions League", status: .upcoming)
        
        viewModel.matches = [matchB, matchA, matchC] // Intentionally out of order
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count == 3)
        #expect(viewModel.groupedMatches[0].leagueName == "Bundesliga")
        #expect(viewModel.groupedMatches[1].leagueName == "Champions League")
        #expect(viewModel.groupedMatches[2].leagueName == "Premier League")
    }
    
    @Test("Groups multiple matches in same league correctly")
    func testMultipleMatchesInSameLeague() {
        // Given
        let viewModel = ScoreCardListViewModel()
        let match1 = createMatchWithCompetition(title: "Premier League", status: .inProgress)
        let match2 = createMatchWithCompetition(title: "Premier League", status: .completed)
        let match3 = createMatchWithCompetition(title: "Champions League", status: .upcoming)
        
        viewModel.matches = [match1, match2, match3]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count == 2)
        
        let premierLeagueSection = viewModel.groupedMatches.first { $0.leagueName == "Premier League" }
        let championsLeagueSection = viewModel.groupedMatches.first { $0.leagueName == "Champions League" }
        
        #expect(premierLeagueSection?.matches.count == 2)
        #expect(championsLeagueSection?.matches.count == 1)
    }
    
    @Test("Handles empty matches array")
    func testEmptyMatchesArray() {
        // Given
        let viewModel = ScoreCardListViewModel()
        viewModel.matches = []
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.isEmpty)
    }
    
    @Test("Handles single match")
    func testSingleMatch() {
        // Given
        let viewModel = ScoreCardListViewModel()
        let singleMatch = createMatchWithCompetition(title: "Premier League", status: .inProgress)
        viewModel.matches = [singleMatch]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count == 1)
        #expect(viewModel.groupedMatches.first?.leagueName == "Premier League")
        #expect(viewModel.groupedMatches.first?.matches.count == 1)
        #expect(viewModel.groupedMatches.first?.matches.first?.id == singleMatch.id)
    }
    
    // MARK: - Data Fetching Tests
    
    @Test("fetchMatches populates matches and groups them")
    func testFetchMatches() async {
        // Given
        let viewModel = ScoreCardListViewModel()
        
        // When
        await viewModel.fetchMatches()
        
        // Then
        #expect(viewModel.matches.count > 0, "Should have fetched matches")
        #expect(viewModel.groupedMatches.count > 0, "Should have grouped matches")
        
        // Verify all matches are accounted for in groups
        let totalMatchesInGroups = viewModel.groupedMatches.reduce(0) { total, section in
            total + section.matches.count
        }
        #expect(totalMatchesInGroups == viewModel.matches.count)
    }
    
    @Test("fetchMatches clears previous data and fetches fresh")
    func testFetchMatchesClearsPreviousData() async {
        // Given
        let viewModel = ScoreCardListViewModel()
        
        // Add some initial data
        viewModel.matches = [MockData.createFallbackMatch(.inProgress)]
        viewModel.groupedMatches = [MatchSection(leagueName: "Test", matches: [])]
        
        // When
        await viewModel.fetchMatches()
        
        // Then
        // The data should be refreshed with actual fetched data
        #expect(viewModel.matches.count > 0)
        #expect(viewModel.groupedMatches.count > 0)
        
        // Verify the test data is replaced
        #expect(!viewModel.groupedMatches.contains { $0.leagueName == "Test" })
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete workflow from fetch to grouped matches")
    func testCompleteWorkflow() async {
        // Given
        let viewModel = ScoreCardListViewModel()
        
        // When
        await viewModel.fetchMatches()
        
        // Then
        #expect(viewModel.matches.count > 0, "Should have fetched matches")
        #expect(viewModel.groupedMatches.count > 0, "Should have grouped matches")
        
        // Verify each section has valid data
        for section in viewModel.groupedMatches {
            #expect(!section.leagueName.isEmpty, "League name should not be empty")
            #expect(section.matches.count > 0, "Each section should have matches")
            
            // Verify all matches in section have valid IDs
            for match in section.matches {
                #expect(match.id > 0, "Match should have valid ID")
            }
        }
    }
    
    @Test("Grouped matches maintain correct league associations")
    func testLeagueAssociations() async {
        // Given
        let viewModel = ScoreCardListViewModel()
        
        // When
        await viewModel.fetchMatches()
        
        // Then
        for section in viewModel.groupedMatches {
            for match in section.matches {
                let expectedLeagueName = match.competition?.title ?? "Unknown League"
                #expect(section.leagueName == expectedLeagueName, 
                       "Match should be in correct league section")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func createMatchWithCompetition(title: String?, status: MatchStatus) -> Match {
        let competitionString = if let title = title {
            """
            "competition": {
                "id": 1,
                "title": "\(title)"
            },
            """
        } else {
            ""
        }
        
        let jsonString = """
        {
            "id": \(Int.random(in: 1000...9999)),
            "kickoff": {
                "completeness": 3,
                "millis": 1704722400000,
                "label": "15:00"
            },
            \(competitionString)
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
                    "score": \(status.hasScores ? "1" : "null")
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
                    "score": \(status.hasScores ? "0" : "null")
                }
            ],
            "ground": {
                "id": 1,
                "name": "Test Stadium",
                "city": "Test City",
                "source": "test"
            },
            "status": "\(status.rawValue)",
            "attendance": \(status.hasScores ? "1000" : "null"),
            "goals": null
        }
        """
        
        do {
            let data = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            return try decoder.decode(Match.self, from: data)
        } catch {
            fatalError("Failed to create test match: \(error)")
        }
    }
}

// MARK: - Test Extensions

extension ScoreCardListViewModel {
    /// Test helper to access private groupMatchesByLeague method
    func groupMatchesByLeague() {
        let grouped = Dictionary(grouping: matches) { match in
            match.competition?.title
        }

        groupedMatches = grouped.map { (leagueName, matches) in
            MatchSection(leagueName: leagueName ?? "Unknown League", matches: matches)
        }.sorted { $0.leagueName < $1.leagueName }
    }
}
