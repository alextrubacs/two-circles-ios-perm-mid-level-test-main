//
//  ClubBadge.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI

struct ClubBadge: View {
    let imageName: String
    let clubName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .renderingMode(.original)

            Text(clubName)
                .font(.selecta(.medium, size: 14))
        }
        .padding()
    }
}

#Preview {
    ClubBadge(
        imageName: "Paris_Saint-Germain",
        clubName: "PSG"
    )
}
