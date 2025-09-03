//
//  ScoreCard.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI

struct ScoreCard: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                ClubBadge(
                    imageName: "Paris_Saint-Germain",
                    clubName: "PSG"
                )
                Text("2")
                    .font(.drukWide(.bold, size: 34))
            }
        }
    }
}

#Preview {
    ScoreCard()
}


