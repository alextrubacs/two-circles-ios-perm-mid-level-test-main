import Foundation
import SwiftData

@MainActor
public class FavoritesService: FavoritesServiceProtocol {
    
    private let modelContainer: ModelContainer
    private var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    public init() throws {
        let schema = Schema([FavoriteDataModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            throw FavoritesServiceError.initializationFailed(error.localizedDescription)
        }
    }

    public func addFavorite(id: Int, type: FavoriteType) async throws {
        // Check if already exists
        if await isFavorite(id: id, type: type) {
            throw FavoritesServiceError.alreadyExists
        }
        
        let favorite = FavoriteDataModel(itemId: id, type: type)
        modelContext.insert(favorite)
        
        do {
            try modelContext.save()
        } catch {
            throw FavoritesServiceError.saveFailed(error.localizedDescription)
        }
    }

    public func removeFavorite(id: Int, type: FavoriteType) async throws {
        let typeString = type.rawValue
        let predicate = #Predicate<FavoriteDataModel> { favorite in
            favorite.itemId == id && favorite.type == typeString
        }
        
        let descriptor = FetchDescriptor<FavoriteDataModel>(predicate: predicate)
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            for favorite in favorites {
                modelContext.delete(favorite)
            }
            try modelContext.save()
        } catch {
            throw FavoritesServiceError.deleteFailed(error.localizedDescription)
        }
    }

    public func isFavorite(id: Int, type: FavoriteType) async -> Bool {
        let typeString = type.rawValue
        let predicate = #Predicate<FavoriteDataModel> { favorite in
            favorite.itemId == id && favorite.type == typeString
        }
        
        var descriptor = FetchDescriptor<FavoriteDataModel>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            return !favorites.isEmpty
        } catch {
            return false
        }
    }

    public func getFavorites(of type: FavoriteType) async throws -> [Int] {
        let typeString = type.rawValue
        let predicate = #Predicate<FavoriteDataModel> { favorite in
            favorite.type == typeString
        }
        
        let descriptor = FetchDescriptor<FavoriteDataModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            return favorites.map { $0.itemId }
        } catch {
            throw FavoritesServiceError.fetchFailed(error.localizedDescription)
        }
    }
    
    public func getAllFavorites() async throws -> [FavoriteItem] {
        let descriptor = FetchDescriptor<FavoriteDataModel>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            return favorites.map { $0.toFavoriteItem() }
        } catch {
            throw FavoritesServiceError.fetchFailed(error.localizedDescription)
        }
    }
    
    public func clearFavorites(of type: FavoriteType) async throws {
        let typeString = type.rawValue
        let predicate = #Predicate<FavoriteDataModel> { favorite in
            favorite.type == typeString
        }
        
        let descriptor = FetchDescriptor<FavoriteDataModel>(predicate: predicate)
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            for favorite in favorites {
                modelContext.delete(favorite)
            }
            try modelContext.save()
        } catch {
            throw FavoritesServiceError.deleteFailed(error.localizedDescription)
        }
    }
    
    public func clearAllFavorites() async throws {
        let descriptor = FetchDescriptor<FavoriteDataModel>()
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            for favorite in favorites {
                modelContext.delete(favorite)
            }
            try modelContext.save()
        } catch {
            throw FavoritesServiceError.deleteFailed(error.localizedDescription)
        }
    }
}

// MARK: - Favorites Service Errors
public enum FavoritesServiceError: LocalizedError, Sendable {
    case initializationFailed(String)
    case alreadyExists
    case saveFailed(String)
    case fetchFailed(String)
    case deleteFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .initializationFailed(let message):
            return "Failed to initialize favorites service: \(message)"
        case .alreadyExists:
            return "This item is already in your favorites"
        case .saveFailed(let message):
            return "Failed to save favorite: \(message)"
        case .fetchFailed(let message):
            return "Failed to fetch favorites: \(message)"
        case .deleteFailed(let message):
            return "Failed to delete favorite: \(message)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .initializationFailed:
            return "Please restart the app and try again."
        case .alreadyExists:
            return "This item is already saved to your favorites."
        case .saveFailed, .deleteFailed:
            return "Please try again later."
        case .fetchFailed:
            return "Please check your device storage and try again."
        }
    }
}
