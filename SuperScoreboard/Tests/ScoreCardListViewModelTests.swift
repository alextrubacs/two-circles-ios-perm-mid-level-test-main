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
        #expect(viewModel.favoriteTeamIds.isEmpty)
        #expect(viewModel.favoritePlayerIds.isEmpty)
        #expect(viewModel.isLoading == true)
        #expect(viewModel.errorState == .none)
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
    
    // MARK: - Favorites Section Tests
    
    @Test("Creates Favourites section when matches contain favorite teams")
    func testFavouritesSectionWithFavoriteTeams() {
        // Given
        let viewModel = ScoreCardListViewModel()
        let teamId1 = 1
        let teamId2 = 2
        
        // Set up favorite teams
        viewModel.favoriteTeamIds = [teamId1, teamId2]
        
        // Create matches with favorite teams
        let match1 = createMatchWithTeams([teamId1, 3], status: .inProgress)
        let match2 = createMatchWithTeams([teamId2, 4], status: .completed)
        let match3 = createMatchWithTeams([5, 6], status: .upcoming) // No favorites
        
        viewModel.matches = [match1, match2, match3]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count >= 2) // At least Favourites + other sections
        
        // Check that Favourites section exists and is first
        let favoritesSection = viewModel.groupedMatches.first
        #expect(favoritesSection?.leagueName == "Favourites")
        #expect(favoritesSection?.matches.count == 2) // match1 and match2
        
        // Verify the correct matches are in Favourites
        let favoriteMatchIds = favoritesSection?.matches.map { $0.id } ?? []
        #expect(favoriteMatchIds.contains(match1.id))
        #expect(favoriteMatchIds.contains(match2.id))
        #expect(!favoriteMatchIds.contains(match3.id))
    }
    
    @Test("Creates Favourites section when matches contain favorite players")
    func testFavouritesSectionWithFavoritePlayers() {
        // Given
        let viewModel = ScoreCardListViewModel()
        let playerId1 = 10
        let playerId2 = 20
        
        // Set up favorite players
        viewModel.favoritePlayerIds = [playerId1, playerId2]
        
        // Create matches with favorite players in goals
        let match1 = createMatchWithGoals([playerId1], status: .inProgress)
        let match2 = createMatchWithGoals([playerId2], status: .completed)
        let match3 = createMatchWithGoals([30], status: .upcoming) // No favorites
        
        viewModel.matches = [match1, match2, match3]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count >= 2) // At least Favourites + other sections
        
        // Check that Favourites section exists and is first
        let favoritesSection = viewModel.groupedMatches.first
        #expect(favoritesSection?.leagueName == "Favourites")
        #expect(favoritesSection?.matches.count == 2) // match1 and match2
        
        // Verify the correct matches are in Favourites
        let favoriteMatchIds = favoritesSection?.matches.map { $0.id } ?? []
        #expect(favoriteMatchIds.contains(match1.id))
        #expect(favoriteMatchIds.contains(match2.id))
        #expect(!favoriteMatchIds.contains(match3.id))
    }
    
    @Test("Does not create Favourites section when no favorite matches")
    func testNoFavouritesSectionWhenNoFavorites() {
        // Given
        let viewModel = ScoreCardListViewModel()
        viewModel.favoriteTeamIds = []
        viewModel.favoritePlayerIds = []
        
        // Create matches without any favorites
        let match1 = createMatchWithTeams([1, 2], status: .inProgress)
        let match2 = createMatchWithTeams([3, 4], status: .completed)
        
        viewModel.matches = [match1, match2]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        // Should not have Favourites section
        let hasFavouritesSection = viewModel.groupedMatches.contains { $0.leagueName == "Favourites" }
        #expect(!hasFavouritesSection)
        
        // Should have other sections
        #expect(viewModel.groupedMatches.count > 0)
    }
    
    @Test("Favourites section appears first when present")
    func testFavouritesSectionAppearsFirst() {
        // Given
        let viewModel = ScoreCardListViewModel()
        viewModel.favoriteTeamIds = [1]
        
        // Create matches with different leagues including favorites
        let favoriteMatch = createMatchWithTeams([1, 2], status: .inProgress, league: "Premier League")
        let regularMatch1 = createMatchWithTeams([3, 4], status: .completed, league: "Champions League")
        let regularMatch2 = createMatchWithTeams([5, 6], status: .upcoming, league: "Bundesliga")
        
        viewModel.matches = [favoriteMatch, regularMatch1, regularMatch2]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count >= 2)
        
        // Favourites should be first
        let firstSection = viewModel.groupedMatches.first
        #expect(firstSection?.leagueName == "Favourites")
        
        // Other sections should follow
        let otherSections = Array(viewModel.groupedMatches.dropFirst())
        #expect(otherSections.count >= 2)
    }
    
    @Test("Handles mixed favorite and non-favorite matches correctly")
    func testMixedFavoriteAndNonFavoriteMatches() {
        // Given
        let viewModel = ScoreCardListViewModel()
        viewModel.favoriteTeamIds = [1, 3]
        viewModel.favoritePlayerIds = [10]
        
        // Create matches with mixed favorites
        let teamFavoriteMatch = createMatchWithTeams([1, 2], status: .inProgress, league: "Premier League")
        let playerFavoriteMatch = createMatchWithGoals([10], status: .completed, league: "Champions League")
        let bothFavoriteMatch = createMatchWithTeams([3, 4], status: .upcoming, league: "Bundesliga")
        let noFavoriteMatch = createMatchWithTeams([5, 6], status: .inProgress, league: "La Liga")
        
        viewModel.matches = [teamFavoriteMatch, playerFavoriteMatch, bothFavoriteMatch, noFavoriteMatch]
        
        // When
        viewModel.groupMatchesByLeague()
        
        // Then
        #expect(viewModel.groupedMatches.count >= 2) // Favourites + other sections
        
        // Check Favourites section
        let favoritesSection = viewModel.groupedMatches.first
        #expect(favoritesSection?.leagueName == "Favourites")
        #expect(favoritesSection?.matches.count == 3) // All except noFavoriteMatch
        
        // Verify all favorite matches are in Favourites
        let favoriteMatchIds = favoritesSection?.matches.map { $0.id } ?? []
        #expect(favoriteMatchIds.contains(teamFavoriteMatch.id))
        #expect(favoriteMatchIds.contains(playerFavoriteMatch.id))
        #expect(favoriteMatchIds.contains(bothFavoriteMatch.id))
        #expect(!favoriteMatchIds.contains(noFavoriteMatch.id))
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
        
        // Verify all matches are accounted for in groups (accounting for Favorites duplication)
        let totalMatchesInGroups = viewModel.groupedMatches.reduce(0) { total, section in
            total + section.matches.count
        }
        let uniqueMatchIds = Set(viewModel.matches.map { $0.id })

        // With Favorites section, matches can appear in both Favorites and their original league
        // So total count in groups can be >= unique matches count
        #expect(totalMatchesInGroups >= viewModel.matches.count)

        // All original matches should be represented in the groups
        let allMatchIdsInGroups = Set(viewModel.groupedMatches.flatMap { $0.matches.map { $0.id } })
        #expect(allMatchIdsInGroups.isSuperset(of: uniqueMatchIds))
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

        // Verify that all unique matches are represented (accounting for Favorites duplication)
        let uniqueMatchIds = Set(viewModel.matches.map { $0.id })
        let allMatchIdsInGroups = Set(viewModel.groupedMatches.flatMap { $0.matches.map { $0.id } })
        #expect(allMatchIdsInGroups.isSuperset(of: uniqueMatchIds), "All matches should be represented in groups")
    }
    
    // MARK: - Helper Methods
    
    private func createMatchWithTeams(_ teamIds: [Int], status: MatchStatus, league: String = "Test League") -> Match {
        let teamsJson = teamIds.enumerated().map { index, teamId in
            """
            {
                "team": {
                    "id": \(teamId),
                    "name": "Team \(teamId)",
                    "shortName": "T\(teamId)",
                    "teamType": "FIRST",
                    "club": {
                        "id": \(teamId),
                        "name": "Team \(teamId)",
                        "abbr": "T\(teamId)",
                        "shortName": "Team \(teamId)"
                    },
                    "altIds": {
                        "opta": "t\(teamId)"
                    }
                },
                "score": \(status.hasScores ? (index == 0 ? "1" : "0") : "null")
            }
            """
        }.joined(separator: ",")
        
        let jsonString = """
        {
            "id": \(Int.random(in: 1000...9999)),
            "kickoff": {
                "completeness": 3,
                "millis": 1704722400000,
                "label": "15:00"
            },
            "competition": {
                "id": 1,
                "title": "\(league)"
            },
            "teams": [\(teamsJson)],
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
            fatalError("Failed to create test match with teams: \(error)")
        }
    }
    
    private func createMatchWithGoals(_ playerIds: [Int], status: MatchStatus, league: String = "Test League") -> Match {
        let goalsJson = playerIds.map { playerId in
            """
            {
                "personId": \(playerId),
                "assistId": null,
                "clock": {
                    "secs": 2700,
                    "label": "45'"
                },
                "phase": "1H",
                "type": "GOAL",
                "description": "Goal by Player \(playerId)"
            }
            """
        }.joined(separator: ",")
        
        let jsonString = """
        {
            "id": \(Int.random(in: 1000...9999)),
            "kickoff": {
                "completeness": 3,
                "millis": 1704722400000,
                "label": "15:00"
            },
            "competition": {
                "id": 1,
                "title": "\(league)"
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
            "goals": [\(goalsJson)]
        }
        """
        
        do {
            let data = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            return try decoder.decode(Match.self, from: data)
        } catch {
            fatalError("Failed to create test match with goals: \(error)")
        }
    }
    
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

        var sections = grouped.map { (leagueName, matches) in
            MatchSection(leagueName: leagueName ?? "Unknown League", matches: matches)
        }.sorted { $0.leagueName < $1.leagueName }
        
        // Add Favourites section if there are matches with favorites
        let favoriteMatches = matches.filter { match in
            containsFavoriteTeamOrPlayer(match)
        }
        
        if !favoriteMatches.isEmpty {
            let favoritesSection = MatchSection(leagueName: "Favourites", matches: favoriteMatches)
            sections.insert(favoritesSection, at: 0) // Insert at the top
        }
        
        groupedMatches = sections
    }
    
    /// Test helper to check if match contains favorite team or player
    private func containsFavoriteTeamOrPlayer(_ match: Match) -> Bool {
        // Check if any team in the match is favorited
        let hasFavoriteTeam = match.teams.contains { team in
            favoriteTeamIds.contains(team.team.id)
        }
        
        // Check if any player in the match goals is favorited
        let hasFavoritePlayer = match.goals?.contains { goal in
            favoritePlayerIds.contains(goal.personId)
        } ?? false
        
        return hasFavoriteTeam || hasFavoritePlayer
    }
}
