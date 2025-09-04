import Foundation

// MARK: - Favorites Service Factory
public class FavoritesServiceFactory {
    
    private static var _shared: FavoritesServiceProtocol?
    
    // MARK: - Shared Instance
    @MainActor
    public static var shared: FavoritesServiceProtocol {
        get async throws {
            if let existing = _shared {
                return existing
            }
            
            let service = try FavoritesService()
            _shared = service
            return service
        }
    }
    
    // MARK: - Create New Instance
    @MainActor
    public static func create() throws -> FavoritesServiceProtocol {
        return try FavoritesService()
    }
    
    // MARK: - Reset (for testing)
    public static func reset() {
        _shared = nil
    }
    
    // MARK: - Inject Mock (for testing)
    public static func inject(_ mockService: FavoritesServiceProtocol) {
        _shared = mockService
    }
}
