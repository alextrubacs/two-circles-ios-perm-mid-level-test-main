//
//  MatchTag.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI
import Domain

struct MatchTag: View {
    @Environment(ScoreCardViewModel.self) private var viewModel
    
    var body: some View {
        HStack {
            if viewModel.shouldShowScores {
                teamOneScoreView
                matchTag
                teamTwoScoreView
            } else {
                teamOneScoreView
                kickoffTimeView
                teamTwoScoreView
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MatchTag()
            .environment(ScoreCardViewModel(match: MockData.Previews.liveScenario))
        
        MatchTag()
            .environment(ScoreCardViewModel(match: MockData.Previews.upcomingScenario))
        
        MatchTag()
            .environment(ScoreCardViewModel(match: MockData.Previews.finishedScenario))
        
        MatchTag()
            .environment(ScoreCardViewModel(match: MockData.Previews.highScoreScenario))
    }
}

// MARK: Subviews
private extension MatchTag {
    var teamOneScoreView: some View {
        Text(viewModel.scoreText(for: viewModel.teamOneScore))
            .font(.drukWide(.bold, size: 34))
            .minimumScaleFactor(0.3)
            .lineLimit(1)
            .frame(width: 61, height: 61)
    }

    var teamTwoScoreView: some View {
        Text(viewModel.scoreText(for: viewModel.teamTwoScore))
            .font(.drukWide(.bold, size: 34))
            .minimumScaleFactor(0.3)
            .lineLimit(1)
            .frame(width: 61, height: 61)
    }

    var matchTag: some View {
        Text(viewModel.matchTagText)
            .font(.selecta(.regular, size: 12))
            .padding(.horizontal, 8)
            .padding(.top, 2)
            .frame(width: 48, height: 24, alignment: .center)
            .foregroundColor(.white)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(viewModel.matchTagColor)
            }
    }
    
    var kickoffTimeView: some View {
        Text(viewModel.kickoffTimeText)
            .font(.selecta(.regular, size: 12))
            .padding(.horizontal, 8)
            .padding(.top, 2)
            .frame(width: 48, height: 24, alignment: .center)
            .foregroundColor(.white)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(viewModel.matchTagColor)
            }
    }
}
