//
//  LeagueHeader.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI

struct LeagueHeader: View {
    let title: String
    var body: some View {
        HStack {
            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            Text(title.capitalized)
                .font(.selecta(.medium, size: 16))
                .foregroundStyle(Color(hex: "1C1B19"))
                .textCase(nil)

            Spacer()

            Image("Chevron")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    LeagueHeader(title: "PREMIER LEAGUE")
}
