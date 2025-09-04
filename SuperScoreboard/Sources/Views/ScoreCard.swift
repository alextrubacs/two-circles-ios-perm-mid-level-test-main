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
    @State private var favoritesService: FavoritesServiceProtocol?
    @State private var isMatchFavorited = false
    
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
        .task {
            await loadFavoritesService()
        }
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func loadFavoritesService() async {
        do {
            favoritesService = try await FavoritesServiceFactory.shared
        } catch {
            print("Failed to load favorites service: \(error)")
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
