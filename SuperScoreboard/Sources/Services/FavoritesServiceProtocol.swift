//
//  FavoritesView.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 04/09/2025.
//

import Foundation

public enum FavoriteType: String, CaseIterable, Sendable {
    case team = "team"
    case match = "match"
    case player = "player"
}

public protocol FavoritesServiceProtocol: Sendable {
    func addFavorite(id: Int, type: FavoriteType) async throws
    func removeFavorite(id: Int, type: FavoriteType) async throws
    func isFavorite(id: Int, type: FavoriteType) async -> Bool

    func getFavorites(of type: FavoriteType) async throws -> [Int]
    func getAllFavorites() async throws -> [FavoriteItem]

    func clearFavorites(of type: FavoriteType) async throws
    func clearAllFavorites() async throws
}

public struct FavoriteItem: Identifiable, Sendable {
    public let id: UUID
    public let itemId: Int
    public let type: FavoriteType
    public let dateAdded: Date
    
    public init(itemId: Int, type: FavoriteType, dateAdded: Date = Date()) {
        self.id = UUID()
        self.itemId = itemId
        self.type = type
        self.dateAdded = dateAdded
    }
}
