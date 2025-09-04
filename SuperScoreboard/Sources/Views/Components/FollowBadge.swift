//
//  FollowBadge.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 04/09/2025.
//

import SwiftUI

struct FollowBadge: View {
    var body: some View {
        Image("follow_badge")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .offset(x: 5, y: 5)
            .transition(.scale)
    }
}

#Preview {
    VStack {
        Image("Premier League")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .overlay(alignment: .bottomTrailing) {
                    FollowBadge()
            }
        Text("Premier League")
            .font(.selecta(.medium, size: 16))
            .foregroundStyle(Color(hex: "1C1B19"))
            .textCase(nil)
    }
}
