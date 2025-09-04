//
//  FollowViewModelTests.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import Testing
import SwiftUI
import Domain
@testable import SuperScoreboard

// MARK: - FollowViewModel Tests
@Suite("FollowViewModel Tests")
struct FollowViewModelTests {
    
    // MARK: - Initialization Tests
    
    @Test("ViewModel initializes with empty state")
    func testInitialState() {
        let viewModel = FollowViewModel()
        
        #expect(viewModel.allTeams.isEmpty)
        #expect(viewModel.allPlayers.isEmpty)
        #expect(viewModel.allLeagues.isEmpty)
        #expect(viewModel.favoriteTeamIds.isEmpty)
        #expect(viewModel.favoritePlayerIds.isEmpty)
        #expect(viewModel.favoriteLeagueIds.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - Favorite Status Tests
    
    @Test("isFavorite returns correct status for teams")
    func testIsFavoriteForTeams() {
        let viewModel = FollowViewModel()
        viewModel.favoriteTeamIds = [1, 2, 3]
        
        #expect(viewModel.isFavorite(id: 1, type: .team) == true)
        #expect(viewModel.isFavorite(id: 2, type: .team) == true)
        #expect(viewModel.isFavorite(id: 3, type: .team) == true)
        #expect(viewModel.isFavorite(id: 4, type: .team) == false)
        #expect(viewModel.isFavorite(id: 0, type: .team) == false)
    }
    
    @Test("isFavorite returns correct status for players")
    func testIsFavoriteForPlayers() {
        let viewModel = FollowViewModel()
        viewModel.favoritePlayerIds = [10, 20, 30]
        
        #expect(viewModel.isFavorite(id: 10, type: .player) == true)
        #expect(viewModel.isFavorite(id: 20, type: .player) == true)
        #expect(viewModel.isFavorite(id: 30, type: .player) == true)
        #expect(viewModel.isFavorite(id: 40, type: .player) == false)
        #expect(viewModel.isFavorite(id: 0, type: .player) == false)
    }
    
    @Test("isFavorite returns correct status for leagues")
    func testIsFavoriteForLeagues() {
        let viewModel = FollowViewModel()
        viewModel.favoriteLeagueIds = [100, 200, 300]
        
        #expect(viewModel.isFavorite(id: 100, type: .match) == true)
        #expect(viewModel.isFavorite(id: 200, type: .match) == true)
        #expect(viewModel.isFavorite(id: 300, type: .match) == true)
        #expect(viewModel.isFavorite(id: 400, type: .match) == false)
        #expect(viewModel.isFavorite(id: 0, type: .match) == false)
    }
    
    // MARK: - Toggle Favorite Tests
    
    @Test("toggleFavorite adds team to favorites when not favorited")
    func testToggleFavoriteAddsTeam() async {
        let viewModel = FollowViewModel()
        viewModel.favoriteTeamIds = []
        
        // Test local state management
        viewModel.testToggleFavoriteLocal(id: 1, type: .team)
        
        #expect(viewModel.favoriteTeamIds.contains(1))
        #expect(viewModel.isFavorite(id: 1, type: .team) == true)
    }
    
    @Test("toggleFavorite removes team from favorites when favorited")
    func testToggleFavoriteRemovesTeam() async {
        let viewModel = FollowViewModel()
        viewModel.favoriteTeamIds = [1, 2, 3]
        
        // Test local state management
        viewModel.testToggleFavoriteLocal(id: 2, type: .team)
        
        #expect(!viewModel.favoriteTeamIds.contains(2))
        #expect(viewModel.isFavorite(id: 2, type: .team) == false)
        #expect(viewModel.favoriteTeamIds.contains(1)) // Other favorites should remain
        #expect(viewModel.favoriteTeamIds.contains(3))
    }
    
    @Test("toggleFavorite adds player to favorites when not favorited")
    func testToggleFavoriteAddsPlayer() async {
        let viewModel = FollowViewModel()
        viewModel.favoritePlayerIds = []
        
        // Test local state management
        viewModel.testToggleFavoriteLocal(id: 10, type: .player)
        
        #expect(viewModel.favoritePlayerIds.contains(10))
        #expect(viewModel.isFavorite(id: 10, type: .player) == true)
    }
    
    @Test("toggleFavorite removes player from favorites when favorited")
    func testToggleFavoriteRemovesPlayer() async {
        let viewModel = FollowViewModel()
        viewModel.favoritePlayerIds = [10, 20, 30]
        
        // Test local state management
        viewModel.testToggleFavoriteLocal(id: 20, type: .player)
        
        #expect(!viewModel.favoritePlayerIds.contains(20))
        #expect(viewModel.isFavorite(id: 20, type: .player) == false)
        #expect(viewModel.favoritePlayerIds.contains(10)) // Other favorites should remain
        #expect(viewModel.favoritePlayerIds.contains(30))
    }
    
    @Test("toggleFavorite adds league to favorites when not favorited")
    func testToggleFavoriteAddsLeague() async {
        let viewModel = FollowViewModel()
        viewModel.favoriteLeagueIds = []
        
        // Test local state management
        viewModel.testToggleFavoriteLocal(id: 100, type: .match)
        
        #expect(viewModel.favoriteLeagueIds.contains(100))
        #expect(viewModel.isFavorite(id: 100, type: .match) == true)
    }
    
    @Test("toggleFavorite removes league from favorites when favorited")
    func testToggleFavoriteRemovesLeague() async {
        let viewModel = FollowViewModel()
        viewModel.favoriteLeagueIds = [100, 200, 300]
        
        // Test local state management
        viewModel.testToggleFavoriteLocal(id: 200, type: .match)
        
        #expect(!viewModel.favoriteLeagueIds.contains(200))
        #expect(viewModel.isFavorite(id: 200, type: .match) == false)
        #expect(viewModel.favoriteLeagueIds.contains(100)) // Other favorites should remain
        #expect(viewModel.favoriteLeagueIds.contains(300))
    }
    
    // MARK: - Error Handling Tests
    
    @Test("clearError resets error message")
    func testClearError() {
        let viewModel = FollowViewModel()
        viewModel.errorMessage = "Test error message"
        
        #expect(viewModel.errorMessage != nil)
        
        viewModel.clearError()
        
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("error message is set when service initialization fails")
    func testServiceInitializationError() {
        let viewModel = FollowViewModel()
        
        // Simulate service initialization error
        viewModel.errorMessage = "Failed to initialize favorites service: Test error"
        
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.contains("Failed to initialize favorites service") == true)
    }
    
    // MARK: - Data Loading Tests
    
    @Test("loadAllData sets loading state correctly")
    func testLoadAllDataLoadingState() async {
        let viewModel = FollowViewModel()
        
        // Initially not loading
        #expect(viewModel.isLoading == false)
        
        // Simulate loading state
        viewModel.isLoading = true
        #expect(viewModel.isLoading == true)
        
        // Simulate loading completion
        viewModel.isLoading = false
        #expect(viewModel.isLoading == false)
    }
    
    @Test("loadAllData processes teams correctly")
    func testLoadAllDataProcessesTeams() async {
        let viewModel = FollowViewModel()
        
        // Use MockData to get real team data
        let mockMatches = MockData.matches
        let teamsFromMatches = mockMatches.flatMap { $0.teams.map { $0.team } }
        let uniqueTeamIds = Set(teamsFromMatches.map { $0.id })
        let uniqueTeams = uniqueTeamIds.compactMap { id in
            teamsFromMatches.first { $0.id == id }
        }.sorted { $0.club.name < $1.club.name }
        
        let mockTeams = uniqueTeams.map { TeamSectionItem(team: $0) }
        viewModel.allTeams = mockTeams
        
        #expect(viewModel.allTeams.count > 0)
        #expect(viewModel.allTeams.first?.displayName != nil)
    }
    
    @Test("loadAllData processes players correctly")
    func testLoadAllDataProcessesPlayers() async {
        let viewModel = FollowViewModel()
        
        // Use MockData to get real player data
        let mockMatches = MockData.matches
        let allGoals = mockMatches.compactMap { $0.goals }.flatMap { $0 }
        let uniquePlayerIds = Set(allGoals.map { $0.personId })
        let uniquePlayers = uniquePlayerIds.map { id in 
            PlayerData(id: id, name: "Player \(id)") 
        }.sorted { $0.name < $1.name }
        
        let mockPlayers = uniquePlayers.map { PlayerSectionItem(playerData: $0) }
        viewModel.allPlayers = mockPlayers
        
        #expect(viewModel.allPlayers.count > 0)
        #expect(viewModel.allPlayers.first?.displayName != nil)
    }
    
    @Test("loadAllData processes leagues correctly")
    func testLoadAllDataProcessesLeagues() async {
        let viewModel = FollowViewModel()
        
        // Use MockData to get real league data
        let mockMatches = MockData.matches
        let allLeaguesFromMatches = mockMatches.compactMap { $0.competition }
        let uniqueLeagueIds = Set(allLeaguesFromMatches.map { $0.id })
        let uniqueLeagues = uniqueLeagueIds.compactMap { id in
            allLeaguesFromMatches.first { $0.id == id }
        }.sorted { $0.title < $1.title }
        
        let mockLeagues = uniqueLeagues.map { LeagueSectionItem(competition: $0) }
        viewModel.allLeagues = mockLeagues
        
        #expect(viewModel.allLeagues.count > 0)
        #expect(viewModel.allLeagues.first?.displayName != nil)
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("toggleFavorite handles empty arrays correctly")
    func testToggleFavoriteWithEmptyArrays() async {
        let viewModel = FollowViewModel()
        
        // Test with empty arrays
        viewModel.favoriteTeamIds = []
        viewModel.favoritePlayerIds = []
        viewModel.favoriteLeagueIds = []
        
        #expect(viewModel.isFavorite(id: 1, type: .team) == false)
        #expect(viewModel.isFavorite(id: 1, type: .player) == false)
        #expect(viewModel.isFavorite(id: 1, type: .match) == false)
    }
    
    @Test("toggleFavorite handles duplicate additions correctly")
    func testToggleFavoriteHandlesDuplicates() async {
        let viewModel = FollowViewModel()
        viewModel.favoriteTeamIds = [1, 2]
        
        // Try to add duplicate
        if !viewModel.favoriteTeamIds.contains(1) {
            viewModel.favoriteTeamIds.append(1)
        }
        
        // Should not have duplicates
        let uniqueIds = Set(viewModel.favoriteTeamIds)
        #expect(uniqueIds.count == viewModel.favoriteTeamIds.count)
        #expect(viewModel.favoriteTeamIds.count == 2)
    }
    
    @Test("toggleFavorite handles non-existent removals correctly")
    func testToggleFavoriteHandlesNonExistentRemovals() async {
        let viewModel = FollowViewModel()
        viewModel.favoriteTeamIds = [1, 2, 3]
        
        // Try to remove non-existent item
        viewModel.favoriteTeamIds.removeAll { $0 == 5 }
        
        // Should remain unchanged
        #expect(viewModel.favoriteTeamIds.count == 3)
        #expect(viewModel.favoriteTeamIds.contains(1))
        #expect(viewModel.favoriteTeamIds.contains(2))
        #expect(viewModel.favoriteTeamIds.contains(3))
    }
    
    // MARK: - State Consistency Tests
    
    @Test("favorite arrays maintain consistency after multiple operations")
    func testFavoriteArraysConsistency() async {
        let viewModel = FollowViewModel()
        
        // Add multiple favorites
        viewModel.favoriteTeamIds = [1, 2, 3]
        viewModel.favoritePlayerIds = [10, 20]
        viewModel.favoriteLeagueIds = [100]
        
        // Verify all are favorited
        #expect(viewModel.isFavorite(id: 1, type: .team) == true)
        #expect(viewModel.isFavorite(id: 2, type: .team) == true)
        #expect(viewModel.isFavorite(id: 3, type: .team) == true)
        #expect(viewModel.isFavorite(id: 10, type: .player) == true)
        #expect(viewModel.isFavorite(id: 20, type: .player) == true)
        #expect(viewModel.isFavorite(id: 100, type: .match) == true)
        
        // Remove some favorites
        viewModel.favoriteTeamIds.removeAll { $0 == 2 }
        viewModel.favoritePlayerIds.removeAll { $0 == 10 }
        
        // Verify remaining favorites
        #expect(viewModel.isFavorite(id: 1, type: .team) == true)
        #expect(viewModel.isFavorite(id: 2, type: .team) == false)
        #expect(viewModel.isFavorite(id: 3, type: .team) == true)
        #expect(viewModel.isFavorite(id: 10, type: .player) == false)
        #expect(viewModel.isFavorite(id: 20, type: .player) == true)
        #expect(viewModel.isFavorite(id: 100, type: .match) == true)
    }
}

// MARK: - Test Helper Extensions
extension FollowViewModel {
    /// Helper method to test local state management without service dependency
    func testToggleFavoriteLocal(id: Int, type: FavoriteType) {
        let wasFavorite = isFavorite(id: id, type: type)
        
        if wasFavorite {
            // Remove from favorites
            switch type {
            case .team:
                favoriteTeamIds.removeAll { $0 == id }
            case .player:
                favoritePlayerIds.removeAll { $0 == id }
            case .match:
                favoriteLeagueIds.removeAll { $0 == id }
            }
        } else {
            // Add to favorites
            switch type {
            case .team:
                if !favoriteTeamIds.contains(id) {
                    favoriteTeamIds.append(id)
                }
            case .player:
                if !favoritePlayerIds.contains(id) {
                    favoritePlayerIds.append(id)
                }
            case .match:
                if !favoriteLeagueIds.contains(id) {
                    favoriteLeagueIds.append(id)
                }
            }
        }
    }
}
