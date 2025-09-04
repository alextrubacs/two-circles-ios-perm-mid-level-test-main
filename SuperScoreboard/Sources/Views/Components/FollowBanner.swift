//
//  FollowBanner.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI

struct FollowBanner: View {
    let isFavoritesEmpty: Bool
    let buttonPressed: () -> Void
    
    var body: some View {
        background
            .overlay(alignment: .leading) {
                content
                    .padding(.horizontal, 24)
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        FollowBanner(isFavoritesEmpty: true) {
            print("Start following tapped!")
        }
        
        FollowBanner(isFavoritesEmpty: false) {
            print("Pick favourites tapped!")
        }
    }
    .padding()
}

private extension FollowBanner {
    var background: some View {
        ZStack {
            // Background trapezoid shape
            TrapezoidShape()
                .foregroundStyle(Color(hex: "255AF6"))
                .frame(height: 86)

            TrapezoidShape()
                .foregroundStyle(.white.opacity(0.1))
                .frame(height: 86)
                .mask(alignment: .trailing, {
                    Image("faceoff")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 170, height: 170)
                })
        }
    }

    var content: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Follow your favourites")
                    .font(.selecta(.bold, size: 16))

                Text("Add your favourite athletes,\nteams & competitions to see the\nscores you care about")
                    .font(.selecta(.regular, size: 12))
            }
            .foregroundStyle(.white)

            Spacer()

             Button {
                 buttonPressed()
             } label: {
                Text(isFavoritesEmpty ? "Start following" : "Pick favourites")
                    .font(.selecta(.medium, size: 13))
                    .foregroundStyle(Color(hex: "1C1B19"))
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.white)
        }
    }
}
