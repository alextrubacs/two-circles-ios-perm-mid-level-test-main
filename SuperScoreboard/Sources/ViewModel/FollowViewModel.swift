import Foundation
import SwiftUI
import Domain

@MainActor
@Observable
class FollowViewModel {
    
    // MARK: - Properties
    private var favoritesService: FavoritesServiceProtocol?
    
    // State
    var allTeams: [TeamSectionItem] = []
    var allPlayers: [PlayerSectionItem] = []
    var allLeagues: [LeagueSectionItem] = []
    var favoriteTeamIds: Set<Int> = []
    var favoritePlayerIds: Set<Int> = []
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Initialization
    
    init() {
        Task {
            await initializeFavoritesService()
            await loadAllData()
        }
    }
    
    // MARK: - Service Setup
    
    private func initializeFavoritesService() async {
        do {
            favoritesService = try await FavoritesServiceFactory.shared
        } catch {
            errorMessage = "Failed to initialize favorites service: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Public Methods
    
    func toggleFavorite(id: Int, type: FavoriteType) async {
        guard let service = favoritesService else { return }
        
        if isFavorite(id: id, type: type) {
            do {
                try await service.removeFavorite(id: id, type: type)
            } catch {
                errorMessage = error.localizedDescription
            }
        } else {
            do {
                try await service.addFavorite(id: id, type: type)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func isFavorite(id: Int, type: FavoriteType) -> Bool {
        switch type {
        case .team:
            return favoriteTeamIds.contains(id)
        case .player:
            return favoritePlayerIds.contains(id)
        case .match:
            return false // Not used in this view
        }
    }
    
    func loadAllData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load all available data from matches
            let allMatches = MockData.matches
            
            // Process teams
            let allTeamsFromMatches = allMatches.flatMap { $0.teams.map { $0.team } }
            let uniqueTeamIds = Set(allTeamsFromMatches.map { $0.id })
            let uniqueTeams = uniqueTeamIds.compactMap { id in
                allTeamsFromMatches.first { $0.id == id }
            }.sorted { $0.club.name < $1.club.name }
            
            allTeams = uniqueTeams.map { TeamSectionItem(team: $0) }
            
            // Process players
            let allGoals = allMatches.compactMap { $0.goals }.flatMap { $0 }
            let uniquePlayerIds = Set(allGoals.map { $0.personId })
            let uniquePlayers = uniquePlayerIds.map { id in 
                PlayerData(id: id, name: "Player \(id)") 
            }.sorted { $0.name < $1.name }
            
            allPlayers = uniquePlayers.map { PlayerSectionItem(playerData: $0) }
            
            // Process leagues
            let allLeaguesFromMatches = allMatches.compactMap { $0.competition }
            let uniqueLeagueIds = Set(allLeaguesFromMatches.map { $0.id })
            let uniqueLeagues = uniqueLeagueIds.compactMap { id in
                allLeaguesFromMatches.first { $0.id == id }
            }.sorted { $0.title < $1.title }
            
            allLeagues = uniqueLeagues.map { LeagueSectionItem(competition: $0) }
            
            // Update favorite status for all items
            await updateFavoriteStatus()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    private func updateFavoriteStatus() async {
        guard let service = favoritesService else { return }
        
        do {
            favoriteTeamIds = Set(try await service.getFavorites(of: .team))
            favoritePlayerIds = Set(try await service.getFavorites(of: .player))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
