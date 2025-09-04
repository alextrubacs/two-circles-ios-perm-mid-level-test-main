import Foundation
import SwiftUI

@MainActor
@Observable
class FavoritesViewModel {
    
    private var favoritesService: FavoritesServiceProtocol?
    
    // State
    var favoriteTeams: [Int] = []
    var favoriteMatches: [Int] = []
    var favoritePlayers: [Int] = []
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Initialization
    
    init() {
        Task {
            await initializeFavoritesService()
            await loadAllFavorites()
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
    
    func addToFavorites(id: Int, type: FavoriteType) async {
        guard let service = favoritesService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await service.addFavorite(id: id, type: type)
            await updateLocalState(id: id, type: type, isAdding: true)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func removeFromFavorites(id: Int, type: FavoriteType) async {
        guard let service = favoritesService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await service.removeFavorite(id: id, type: type)
            await updateLocalState(id: id, type: type, isAdding: false)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func isFavorite(id: Int, type: FavoriteType) -> Bool {
        switch type {
        case .team:
            return favoriteTeams.contains(id)
        case .match:
            return favoriteMatches.contains(id)
        case .player:
            return favoritePlayers.contains(id)
        }
    }
    
    func loadAllFavorites() async {
        guard let service = favoritesService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            favoriteTeams = try await service.getFavorites(of: .team)
            favoriteMatches = try await service.getFavorites(of: .match)
            favoritePlayers = try await service.getFavorites(of: .player)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearAllFavorites() async {
        guard let service = favoritesService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await service.clearAllFavorites()
            favoriteTeams.removeAll()
            favoriteMatches.removeAll()
            favoritePlayers.removeAll()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    private func updateLocalState(id: Int, type: FavoriteType, isAdding: Bool) async {
        switch type {
        case .team:
            if isAdding {
                if !favoriteTeams.contains(id) {
                    favoriteTeams.append(id)
                }
            } else {
                favoriteTeams.removeAll { $0 == id }
            }
        case .match:
            if isAdding {
                if !favoriteMatches.contains(id) {
                    favoriteMatches.append(id)
                }
            } else {
                favoriteMatches.removeAll { $0 == id }
            }
        case .player:
            if isAdding {
                if !favoritePlayers.contains(id) {
                    favoritePlayers.append(id)
                }
            } else {
                favoritePlayers.removeAll { $0 == id }
            }
        }
    }
}
