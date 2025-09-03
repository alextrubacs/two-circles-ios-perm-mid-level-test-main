//
//  MatchSection.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import Foundation
import Domain

struct MatchSection: Identifiable {
    let id = UUID()
    let leagueName: String
    let matches: [Match]
}
