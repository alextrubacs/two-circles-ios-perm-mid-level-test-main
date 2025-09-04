//
//  ScoreCardList.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI
import Domain

struct ScoreCardList: View {
    @State private var showFollowView: Bool = false
    @State private var refreshTrigger: UUID = UUID()
    let groupedMatches: [MatchSection]
    
    var body: some View {
        List {
            ForEach(groupedMatches) { section in
                Section(header: LeagueHeader(title: section.leagueName)) {
                    ForEach(section.matches, id: \.id) { match in
                        ScoreCard(match: match)
                            .id(refreshTrigger) // Force refresh when trigger changes
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowSpacing(0)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 4, trailing: 0))
                    }
                }
                .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 4, trailing: 0))
            }

            FollowBanner {
                showFollowView = true
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowSpacing(0)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.insetGrouped)
        .sheet(isPresented: $showFollowView) {
            FollowView()
        }
        .onChange(of: showFollowView) { _, isPresented in
            if !isPresented {
                // Refresh ScoreCard components when FollowView is dismissed
                refreshTrigger = UUID()
            }
        }
    }
}

#Preview {
    ScoreCardList(groupedMatches: [
        MatchSection(
            leagueName: "Premier League",
            matches: [
                MockData.Previews.liveScenario,
                MockData.Previews.upcomingScenario
            ]
        ),
        MatchSection(
            leagueName: "Champions League",
            matches: [
                MockData.Previews.finishedScenario,
                MockData.Previews.highScoreScenario
            ]
        )
    ])
}
