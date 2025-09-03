//
//  FollowBanner.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI

struct FollowBanner: View {
    var body: some View {
        TrapezoidShape()
            .foregroundStyle(Color(hex: "255AF6"))
            .frame(height: 96)
    }
}

#Preview {
    FollowBanner()
        .padding()
}
