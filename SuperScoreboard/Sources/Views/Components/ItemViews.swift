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
            ClubBadge(
                imageName: teamItem.imageName,
                clubName: teamItem.clubAbbr
            )
        } else if let playerItem = item as? PlayerSectionItem {
            Image(systemName: playerItem.imageName)
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "255AF6"))
                .overlay(alignment: .bottomTrailing) {
                    if isFavorited {
                        FollowBadge()
                    }
                }
        } else if let leagueItem = item as? LeagueSectionItem {
            if leagueItem.imageName == "trophy.fill" {
                Image(systemName: leagueItem.imageName)
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                    .overlay(alignment: .bottomTrailing) {
                        if isFavorited {
                            FollowBadge()
                        }
                    }
            } else {
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
        } else {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
        }
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
