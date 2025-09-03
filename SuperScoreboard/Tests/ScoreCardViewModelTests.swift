//
//  ScoreCardViewModelTests.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import Testing
import SwiftUI
import Domain
@testable import SuperScoreboard

// MARK: - ScoreCardViewModel Tests
@Suite("ScoreCardViewModel Tests")
struct ScoreCardViewModelTests {
    
    // MARK: - Team Information Tests
    
    @Test("Team names are extracted correctly")
    func testTeamNames() {
        // Given - Use real mock data from MockData
        let match = MockData.liveMatch // PSG vs Arsenal
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.teamOneName == "Paris Saint-Germain")
        #expect(viewModel.teamTwoName == "Arsenal")
        #expect(viewModel.clubOneName == "PSG")
        #expect(viewModel.clubTwoName == "ARS")
    }
    
    @Test("Team names handle fallback scenario")
    func testTeamNamesWithFallback() {
        // Given - Use fallback match that MockData creates when JSON fails
        let match = MockData.createFallbackMatch(.inProgress)
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.teamOneName == "Team A")
        #expect(viewModel.teamTwoName == "Team B")
        
        #expect(viewModel.clubOneName == "TEA")
        #expect(viewModel.clubTwoName == "TEB")
    }
    
    // MARK: - Score Information Tests
    
    @Test("Scores are extracted correctly")
    func testScores() {
        // Given - Use live match with scores (PSG 2-1 Arsenal)
        let match = MockData.liveMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.teamOneScore == 2)
        #expect(viewModel.teamTwoScore == 1)
        #expect(viewModel.scoreText(for: 2) == "2")
        #expect(viewModel.scoreText(for: 1) == "1")
        #expect(viewModel.scoreText(for: nil) == "-")
    }
    
    @Test("High scoring match test")
    func testHighScoringMatch() {
        // Given - Use high scoring match (127-99)
        let match = MockData.highScoringMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.teamOneScore == 127)
        #expect(viewModel.teamTwoScore == 99)
        #expect(viewModel.scoreText(for: 127) == "127")
        #expect(viewModel.scoreText(for: 99) == "99")
    }
    
    // MARK: - Display Logic Tests
    
    @Test("Display logic for upcoming matches")
    func testUpcomingMatchDisplayLogic() {
        // Given - Use upcoming match from MockData
        let match = MockData.upcomingMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.shouldShowScores == false)
        #expect(viewModel.shouldShowClubNames == false)
        #expect(viewModel.shouldShowKickoffTime == true)
        #expect(viewModel.isUpcoming == true)
        #expect(viewModel.isActive == false)
        #expect(viewModel.isCompleted == false)
    }
    
    @Test("Display logic for in-progress matches")
    func testInProgressMatchDisplayLogic() {
        // Given - Use live match from MockData
        let match = MockData.liveMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.shouldShowScores == true)
        #expect(viewModel.shouldShowClubNames == true)
        #expect(viewModel.shouldShowKickoffTime == false)
        #expect(viewModel.isUpcoming == false)
        #expect(viewModel.isActive == true)
        #expect(viewModel.isCompleted == false)
    }
    
    @Test("Display logic for completed matches")
    func testCompletedMatchDisplayLogic() {
        // Given - Use finished match from MockData
        let match = MockData.finishedMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.shouldShowScores == true)
        #expect(viewModel.shouldShowClubNames == true)
        #expect(viewModel.shouldShowKickoffTime == false)
        #expect(viewModel.isUpcoming == false)
        #expect(viewModel.isActive == false)
        #expect(viewModel.isCompleted == true)
    }
    
    // MARK: - Match Tag Tests
    
    @Test("Match tag text for active match")
    func testMatchTagTextForActiveMatch() {
        // Given - Use live match with clock (PSG vs Arsenal, 12')
        let match = MockData.liveMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.matchTagText == "12'")
    }
    
    @Test("Match tag text for active match without clock")
    func testMatchTagTextForActiveMatchWithoutClock() {
        // Given - Use fallback match without clock
        let match = MockData.createFallbackMatch(.inProgress)
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.matchTagText == "30'")
    }
    
    @Test("Match tag text for upcoming match")
    func testMatchTagTextForUpcomingMatch() {
        // Given - Use upcoming match from MockData
        let match = MockData.upcomingMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        // This should return formatted time from millis
        #expect(viewModel.matchTagText.isEmpty == false)
    }
    
    @Test("Match tag text for completed match with extra time")
    func testMatchTagTextForCompletedMatchWithExtraTime() {
        // Given - Use penalty match which has 6300 seconds (105 minutes = 15 minutes extra)
        let match = MockData.penaltyMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.matchTagText == "+15'00")
    }
    
    @Test("Match tag text for completed match without extra time")
    func testMatchTagTextForCompletedMatchWithoutExtraTime() {
        // Given - Use finished match with exactly 90 minutes (5400 seconds)
        let match = MockData.finishedMatch // Barcelona vs Real Madrid, 5400 seconds
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.matchTagText == "FT")
    }
    
    @Test("Match tag text for completed match without clock")
    func testMatchTagTextForCompletedMatchWithoutClock() {
        // Given - Use fallback completed match without clock
        let match = MockData.createFallbackMatch(.completed)
        let viewModel = ScoreCardViewModel(match: match)
        
        // When & Then
        #expect(viewModel.matchTagText == "FT")
    }
    
    // MARK: - Match Tag Color Tests
    
    @Test("Match tag colors are correct")
    func testMatchTagColors() {
        // Given - Use actual mock data
        let upcomingMatch = MockData.upcomingMatch
        let inProgressMatch = MockData.liveMatch
        let completedMatch = MockData.finishedMatch
        
        let upcomingViewModel = ScoreCardViewModel(match: upcomingMatch)
        let inProgressViewModel = ScoreCardViewModel(match: inProgressMatch)
        let completedViewModel = ScoreCardViewModel(match: completedMatch)
        
        // When & Then
        #expect(upcomingViewModel.matchTagColor == Color(hex: "787880").opacity(0.2))
        #expect(inProgressViewModel.matchTagColor == Color(hex: "BF1F25"))
        #expect(completedViewModel.matchTagColor == Color.green)
    }
    
    // MARK: - Extra Time Calculation Tests
    
    @Test("Extra time calculation with real data")
    func testExtraTimeCalculationWithRealData() {
        // Given - Use penalty match (6300 seconds = 105 minutes = +15 minutes)
        let penaltyMatch = MockData.penaltyMatch
        let penaltyViewModel = ScoreCardViewModel(match: penaltyMatch)
        
        // When & Then
        #expect(penaltyViewModel.matchTagText == "+15'00")
        
        // Given - Use finished match (5400 seconds = exactly 90 minutes)
        let finishedMatch = MockData.finishedMatch
        let finishedViewModel = ScoreCardViewModel(match: finishedMatch)
        
        // When & Then
        #expect(finishedViewModel.matchTagText == "FT")
    }
    
    @Test("Extra time calculation with fallback matches")
    func testExtraTimeCalculationWithFallbackMatches() {
        // Test different scenarios using fallback matches
        let testCases: [(MatchStatus, String)] = [
            (.upcoming, "3:00 PM"), // Will be formatted time from millis
            (.inProgress, "30'"),   // Clock label from fallback
            (.completed, "FT")      // No extra time in fallback
        ]
        
        for (status, _) in testCases {
            // Given
            let match = MockData.createFallbackMatch(status)
            let viewModel = ScoreCardViewModel(match: match)
            
            // When & Then
            #expect(viewModel.matchTagText.isEmpty == false, "Failed for \(status) status")
            
            // Verify status-specific behavior
            switch status {
            case .upcoming:
                #expect(viewModel.isUpcoming == true)
            case .inProgress:
                #expect(viewModel.isActive == true)
            case .completed:
                #expect(viewModel.isCompleted == true)
            @unknown default:
                #expect(Bool(false), "Unknown match status encountered")
            }
        }
    }
    
    // MARK: - Kickoff Time Tests
    
    @Test("Kickoff time extraction from real data")
    func testKickoffTimeExtractionFromRealData() {
        // Given - Use upcoming match from MockData
        let match = MockData.upcomingMatch
        let viewModel = ScoreCardViewModel(match: match)
        
        // When
        let kickoffTime = viewModel.kickoffTimeText
        
        // Then
        // The exact format will depend on the device's locale, but it should contain time information
        #expect(kickoffTime.isEmpty == false)
        #expect(viewModel.isUpcoming == true)
    }
    
    @Test("Comprehensive match data validation")
    func testComprehensiveMatchDataValidation() {
        // Test all available mock matches
        let allMatches = MockData.matches
        
        for match in allMatches {
            let viewModel = ScoreCardViewModel(match: match)
            
            // Basic validation - all matches should have valid data
            #expect(viewModel.teamOneName.isEmpty == false, "Team one name should not be empty for match \(match.id)")
            #expect(viewModel.teamTwoName.isEmpty == false, "Team two name should not be empty for match \(match.id)")
            #expect(viewModel.clubOneName.isEmpty == false, "Club one name should not be empty for match \(match.id)")
            #expect(viewModel.clubTwoName.isEmpty == false, "Club two name should not be empty for match \(match.id)")
            #expect(viewModel.matchTagText.isEmpty == false, "Match tag text should not be empty for match \(match.id)")
            
            // Status-specific validation
            switch match.status {
            case .upcoming:
                #expect(viewModel.shouldShowScores == false)
                #expect(viewModel.shouldShowClubNames == false)
                #expect(viewModel.shouldShowKickoffTime == true)
            case .inProgress:
                #expect(viewModel.shouldShowScores == true)
                #expect(viewModel.shouldShowClubNames == true)
                #expect(viewModel.shouldShowKickoffTime == false)
            case .completed:
                #expect(viewModel.shouldShowScores == true)
                #expect(viewModel.shouldShowClubNames == true)
                #expect(viewModel.shouldShowKickoffTime == false)
            @unknown default:
                #expect(Bool(false), "Unknown match status encountered")
            }
        }
    }
}
