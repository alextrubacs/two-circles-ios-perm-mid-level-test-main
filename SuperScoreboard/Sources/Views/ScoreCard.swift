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
            
            // Favorites button
            Button(action: {
                Task {
                    await toggleMatchFavorite()
                }
            }) {
                Image(systemName: isMatchFavorited ? "heart.fill" : "heart")
                    .foregroundColor(isMatchFavorited ? .red : .gray)
                    .font(.title2)
            }
            .padding(.leading, 8)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
        }
        .frame(height: 96, alignment: .center)
        .task {
            await loadFavoritesService()
            await checkIfMatchIsFavorited()
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
    
    private func toggleMatchFavorite() async {
        guard let service = favoritesService else { return }
        
        do {
            if isMatchFavorited {
                try await service.removeFavorite(id: viewModel.match.id, type: .match)
            } else {
                try await service.addFavorite(id: viewModel.match.id, type: .match)
            }
            isMatchFavorited.toggle()
        } catch {
            print("Failed to toggle match favorite: \(error)")
        }
    }
    
    private func checkIfMatchIsFavorited() async {
        guard let service = favoritesService else { return }
        isMatchFavorited = await service.isFavorite(id: viewModel.match.id, type: .match)
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
