//
//  ScoreCard.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI
import Domain

struct ScoreCard: View {
    @State private var viewModel: ScoreCardViewModel
    
    init(match: Match) {
        self._viewModel = State(initialValue: ScoreCardViewModel(match: match))
    }

    var body: some View {
        HStack(alignment: .center) {
            ClubBadge(
                imageName: viewModel.teamOneName,
                clubName: viewModel.shouldShowClubNames ? viewModel.clubOneName : ""
            )

            MatchTag()
                .environment(viewModel)

            ClubBadge(
                imageName: viewModel.teamTwoName,
                clubName: viewModel.shouldShowClubNames ? viewModel.clubTwoName : ""
            )
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
        }
        .frame(height: 96, alignment: .center)
    }
}

#Preview {
    VStack(spacing: 20) {
        ScoreCard(match: MockData.Previews.liveScenario)
        ScoreCard(match: MockData.Previews.upcomingScenario)
        ScoreCard(match: MockData.Previews.finishedScenario)
        ScoreCard(match: MockData.Previews.highScoreScenario)
    }
    .padding()
}
