//
//  ScoreCardList.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI
import Domain

struct ScoreCardList: View {
    @Environment(ScoreCardListViewModel.self) private var viewModel
    @State private var showFollowView: Bool = false
    @State private var refreshTrigger: UUID = UUID()
    
    var body: some View {
        List {
            ForEach(viewModel.groupedMatches) { section in
                Section(header: LeagueHeader(title: section.leagueName)) {
                    ForEach(section.matches, id: \.id) { match in
                        scoreCard(for: match)
                    }
                }
                .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 4, trailing: 0))
            }

            followBanner
        }
        .listStyle(.insetGrouped)
        .sheet(isPresented: $showFollowView) {
            FollowView()
        }
        .onChange(of: showFollowView) { _, isPresented in
            if !isPresented {
                // Refresh favorites and ScoreCard components when FollowView is dismissed
                Task {
                    await viewModel.refreshFavorites()
                }
                refreshTrigger = UUID()
            }
        }
    }
}

#Preview {
    ScoreCardList()
        .environment(ScoreCardListViewModel())
}

// MARK: Subviews
private extension ScoreCardList {
    func scoreCard(for match: Match) -> some View {
        ScoreCard(match: match)
            .id(refreshTrigger) // Force refresh when trigger changes
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowSpacing(0)
            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 4, trailing: 0))
    }

    var followBanner: some View {
        FollowBanner {
            showFollowView = true
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowSpacing(0)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
