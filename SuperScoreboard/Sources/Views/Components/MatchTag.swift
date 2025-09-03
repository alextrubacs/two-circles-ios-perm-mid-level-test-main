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
        HStack(spacing: 10) {
            if viewModel.shouldShowScores {
                teamOneScoreView
                matchTag
                teamTwoScoreView
            } else {
                teamOneAbbr
                kickoffTimeView
                teamTwoAbbr
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
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
        teamDisplayView(
            text: viewModel.scoreText(for: viewModel.teamOneScore),
            fontSize: 34
        )
    }

    var teamTwoScoreView: some View {
        teamDisplayView(
            text: viewModel.scoreText(for: viewModel.teamTwoScore),
            fontSize: 34
        )
    }

    var teamOneAbbr: some View {
        teamDisplayView(
            text: viewModel.clubOneName,
            fontSize: 16
        )
    }

    var teamTwoAbbr: some View {
        teamDisplayView(
            text: viewModel.clubTwoName,
            fontSize: 16
        )
    }
    
    // MARK: - Reusable Components
    func teamDisplayView(text: String, fontSize: CGFloat) -> some View {
        Text(text)
            .font(.drukWide(.bold, size: fontSize))
            .minimumScaleFactor(0.3)
            .lineLimit(1)
            .frame(width: 61, height: 61)
    }

    var matchTag: some View {
        tagView(
            text: viewModel.matchTagText,
            textColor: .white,
            backgroundColor: viewModel.matchTagColor
        )
    }
    
    var kickoffTimeView: some View {
        tagView(
            text: viewModel.kickoffTimeText,
            textColor: .black,
            backgroundColor: viewModel.matchTagColor
        )
    }
    
    // MARK: - Reusable Tag Component
    func tagView(text: String, textColor: Color, backgroundColor: Color) -> some View {
        Text(text)
            .font(.selecta(.regular, size: 12))
            .padding(.horizontal, 8)
            .padding(.top, 2)
            .frame(width: 48, height: 24, alignment: .center)
            .foregroundColor(textColor)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(backgroundColor)
            }
    }
}
