//
//  ScoreCard.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI
import Domain

struct ScoreCard: View {
    let match: Match

    var body: some View {
        HStack(alignment: .center) {
            ClubBadge(
                imageName: teamOneName,
                clubName: clubOneName
            )

            MatchTag(match: match)

            ClubBadge(
                imageName: teamTwoName,
                clubName: clubTwoName
            )
        }
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

// MARK: Subviews
private extension ScoreCard {

}

// MARK: Computed properties
private extension ScoreCard {
    var teamOneName: String {
        guard match.teams.count > 0 else { return "Unknown" }
        return match.teams[0].team.name
    }
    
    var teamTwoName: String {
        guard match.teams.count > 1 else { return "Unknown" }
        return match.teams[1].team.name
    }
    
    var clubOneName: String {
        guard match.teams.count > 0 else { return "UNK" }
        return match.teams[0].team.club.abbr
    }
    
    var clubTwoName: String {
        guard match.teams.count > 1 else { return "UNK" }
        return match.teams[1].team.club.abbr
    }
}
