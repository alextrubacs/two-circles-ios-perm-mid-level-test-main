//
//  MatchTag.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI
import Domain

struct MatchTag: View {
    let match: Match
    
    var body: some View {
        HStack {
            teamOneScoreView
            matchTag
            teamTwoScoreView
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MatchTag(match: MockData.Previews.liveScenario)
        MatchTag(match: MockData.Previews.upcomingScenario)
        MatchTag(match: MockData.Previews.finishedScenario)
        MatchTag(match: MockData.Previews.highScoreScenario)
    }
}

// MARK: Subviews
private extension MatchTag {
    var teamOneScoreView: some View {
        Text(scoreText(for: teamOneScore))
            .font(.drukWide(.bold, size: 34))
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .padding()
            .frame(minWidth: 50)
    }

    var teamTwoScoreView: some View {
        Text(scoreText(for: teamTwoScore))
            .font(.drukWide(.bold, size: 34))
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .padding()
            .frame(minWidth: 50)
    }

    var matchTag: some View {
        Text("12'")
            .font(.selecta(.regular, size: 12))
            .padding(.horizontal, 8)
            .padding(.top, 2)
            .frame(width: 48, height: 24, alignment: .center)
            .foregroundColor(.white)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(matchTagColor)
            }
    }

    var matchTagColor: Color {
        switch match.status {
        case "L": return Color(hex: "BF1F25") // Red for live
        case "U": return Color(hex: "007AFF") // Blue for upcoming
        case "C": return Color(hex: "34C759") // Green for completed
        default: return Color(hex: "6B7280")  // Gray for unknown
        }
    }
}

// MARK: Computed properties
private extension MatchTag {

    var teamOneScore: Int? {
        guard match.teams.count > 0 else { return nil }
        return match.teams[0].score
    }

    var teamTwoScore: Int? {
        guard match.teams.count > 1 else { return nil }
        return match.teams[1].score
    }
}

// MARK: Methods
private extension MatchTag {
    func scoreText(for score: Int?) -> String {
        guard let score = score else { return "-" }
        return "\(score)"
    }
}
