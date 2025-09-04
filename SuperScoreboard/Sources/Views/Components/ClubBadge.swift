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
    let isFavourite: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .overlay(alignment: .bottomTrailing) {
                    if isFavourite {
                        FollowBadge()
                    }
                }
            
            if !clubName.isEmpty {
                Text(clubName)
                    .font(.selecta(.medium, size: 14))
                    .opacity(0.88)
                    .foregroundStyle(Color(hex: "3C3C43"))
            }
        }
    }
}

#Preview {
    ClubBadge(
        imageName: "Paris_Saint-Germain",
        clubName: "PSG",
        isFavourite: true
    )
}
