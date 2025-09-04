import SwiftUI

// MARK: - Generic Item View
struct GenericItemView<Item: SectionItem>: View {
    let item: Item
    let isFavorited: Bool
    
    var body: some View {
        itemImage
    }
    
    // MARK: - Item Image
    @ViewBuilder
    private var itemImage: some View {
        if let teamItem = item as? TeamSectionItem {
            teamItemView(for: teamItem)
        } else if let playerItem = item as? PlayerSectionItem {
            playerItemView(for: playerItem)
        } else if let leagueItem = item as? LeagueSectionItem {
            leagueItemView(for: leagueItem)
        } else {
            fallbackItemView
        }
    }
}

// MARK: - GenericItemView Extensions
extension GenericItemView {

    @ViewBuilder
    private func teamItemView(for teamItem: TeamSectionItem) -> some View {
        ClubBadge(
            imageName: teamItem.imageName,
            clubName: teamItem.clubAbbr
        )
    }

    @ViewBuilder
    private func playerItemView(for playerItem: PlayerSectionItem) -> some View {
        Image(systemName: playerItem.imageName)
            .font(.system(size: 40))
            .foregroundColor(Color(hex: "255AF6"))
            .overlay(alignment: .bottomTrailing) {
                if isFavorited {
                    FollowBadge()
                }
            }
    }

    @ViewBuilder
    private func leagueItemView(for leagueItem: LeagueSectionItem) -> some View {
        if leagueItem.imageName == "trophy.fill" {
            leagueTrophyView(for: leagueItem)
        } else {
            leagueAssetView(for: leagueItem)
        }
    }

    @ViewBuilder
    private func leagueTrophyView(for leagueItem: LeagueSectionItem) -> some View {
        Image(systemName: leagueItem.imageName)
            .font(.system(size: 40))
            .foregroundColor(.orange)
            .overlay(alignment: .bottomTrailing) {
                if isFavorited {
                    FollowBadge()
                }
            }
    }

    @ViewBuilder
    private func leagueAssetView(for leagueItem: LeagueSectionItem) -> some View {
        VStack {
            Image(leagueItem.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .overlay(alignment: .bottomTrailing) {
                    if isFavorited {
                        FollowBadge()
                    }
                }
            Text(leagueItem.displayName)
                .font(.selecta(.medium, size: 16))
                .foregroundStyle(Color(hex: "1C1B19"))
                .textCase(nil)
        }
    }

    @ViewBuilder
    private var fallbackItemView: some View {
        Image(systemName: "questionmark.circle")
            .font(.system(size: 40))
            .foregroundColor(.gray)
    }
}

// MARK: - Type Aliases for Convenience
typealias TeamItemView = GenericItemView<TeamSectionItem>
typealias PlayerItemView = GenericItemView<PlayerSectionItem>
typealias LeagueItemView = GenericItemView<LeagueSectionItem>

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        GenericItemView(
            item: TeamSectionItem(team: MockData.matches.first!.teams.first!.team),
            isFavorited: true
        )
        
        GenericItemView(
            item: PlayerSectionItem(playerData: PlayerData(id: 1, name: "Player 1")),
            isFavorited: false
        )
        
        GenericItemView(
            item: LeagueSectionItem(competition: MockData.matches.first!.competition!),
            isFavorited: true
        )
    }
    .padding()
}
