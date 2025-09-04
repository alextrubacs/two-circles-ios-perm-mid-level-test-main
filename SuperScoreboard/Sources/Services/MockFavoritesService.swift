import Foundation

// MARK: - Mock Favorites Service for Testing
@MainActor
public final class MockFavoritesService: FavoritesServiceProtocol {

    private var favorites: [FavoriteItem] = []
    private let shouldSimulateError: Bool
    
    // MARK: - Initialization
    public init(shouldSimulateError: Bool = false) {
        self.shouldSimulateError = shouldSimulateError
    }
    
    // MARK: - Add Favorites
    public func addFavorite(id: Int, type: FavoriteType) async throws {
        if shouldSimulateError {
            throw FavoritesServiceError.saveFailed("Mock error")
        }
        
        // Check if already exists
        if await isFavorite(id: id, type: type) {
            throw FavoritesServiceError.alreadyExists
        }
        
        let favorite = FavoriteItem(itemId: id, type: type)
        favorites.append(favorite)
    }
    
    // MARK: - Remove Favorites
    public func removeFavorite(id: Int, type: FavoriteType) async throws {
        if shouldSimulateError {
            throw FavoritesServiceError.deleteFailed("Mock error")
        }
        
        favorites.removeAll { $0.itemId == id && $0.type == type }
    }
    
    // MARK: - Check if Favorite
    public func isFavorite(id: Int, type: FavoriteType) async -> Bool {
        return favorites.contains { $0.itemId == id && $0.type == type }
    }
    
    // MARK: - Get Favorites
    public func getFavorites(of type: FavoriteType) async throws -> [Int] {
        if shouldSimulateError {
            throw FavoritesServiceError.fetchFailed("Mock error")
        }
        
        return favorites
            .filter { $0.type == type }
            .sorted { $0.dateAdded > $1.dateAdded }
            .map { $0.itemId }
    }
    
    public func getAllFavorites() async throws -> [FavoriteItem] {
        if shouldSimulateError {
            throw FavoritesServiceError.fetchFailed("Mock error")
        }
        
        return favorites.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    // MARK: - Clear Favorites
    public func clearFavorites(of type: FavoriteType) async throws {
        if shouldSimulateError {
            throw FavoritesServiceError.deleteFailed("Mock error")
        }
        
        favorites.removeAll { $0.type == type }
    }
    
    public func clearAllFavorites() async throws {
        if shouldSimulateError {
            throw FavoritesServiceError.deleteFailed("Mock error")
        }
        
        favorites.removeAll()
    }
    
    // MARK: - Test Helpers
    public func getFavoritesCount() -> Int {
        return favorites.count
    }
    
    public func addMockFavorites(_ items: [FavoriteItem]) {
        favorites.append(contentsOf: items)
    }
}
