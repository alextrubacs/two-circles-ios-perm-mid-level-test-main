//
//  FavoriteDataModel.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 04/09/2025.
//

import Foundation
import SwiftData

@Model
public class FavoriteDataModel {
    public var itemId: Int
    public var type: String
    public var dateAdded: Date
    public var id: UUID
    
    public init(itemId: Int, type: FavoriteType, dateAdded: Date = Date()) {
        self.itemId = itemId
        self.type = type.rawValue
        self.dateAdded = dateAdded
        self.id = UUID()
    }

    public var favoriteType: FavoriteType {
        return FavoriteType(rawValue: type) ?? .team
    }
    
    public func toFavoriteItem() -> FavoriteItem {
        return FavoriteItem(
            itemId: itemId,
            type: favoriteType,
            dateAdded: dateAdded
        )
    }
}
