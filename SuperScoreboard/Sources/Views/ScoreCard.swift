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
    @State private var isTeamOneFavorited = false
    @State private var isTeamTwoFavorited = false
    
    init(match: Match) {
        self._viewModel = State(initialValue: ScoreCardViewModel(match: match))
    }

    var body: some View {
        HStack(alignment: .center) {
            ClubBadge(
                imageName: viewModel.teamOneName,
                clubName: viewModel.shouldShowClubNames ? viewModel.clubOneName : "",
                isFavourite: isTeamOneFavorited
            )

            MatchTag()
                .environment(viewModel)

            ClubBadge(
                imageName: viewModel.teamTwoName,
                clubName: viewModel.shouldShowClubNames ? viewModel.clubTwoName : "",
                isFavourite: isTeamTwoFavorited
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
            await checkTeamFavoriteStatus()
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
    
    @MainActor
    private func checkTeamFavoriteStatus() async {
        guard let service = favoritesService else { return }
        isTeamOneFavorited = await service.isFavorite(id: viewModel.teamOneId, type: .team)
        isTeamTwoFavorited = await service.isFavorite(id: viewModel.teamTwoId, type: .team)
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
