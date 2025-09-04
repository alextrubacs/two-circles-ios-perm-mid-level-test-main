import Foundation
import Domain

// MARK: - Team Section Item
struct TeamSectionItem: SectionItem {
    let id: Int
    let displayName: String
    let imageName: String
    let clubAbbr: String
    let team: Team
    
    init(team: Team) {
        self.id = team.id
        self.displayName = team.club.name
        self.imageName = team.club.name
        self.clubAbbr = team.club.abbr
        self.team = team
    }
    
    // MARK: - Hashable & Equatable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TeamSectionItem, rhs: TeamSectionItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Player Section Item
struct PlayerSectionItem: SectionItem {
    let id: Int
    let displayName: String
    let imageName: String
    let playerData: PlayerData
    
    init(playerData: PlayerData) {
        self.id = playerData.id
        self.displayName = playerData.name
        self.imageName = "person.circle.fill"
        self.playerData = playerData
    }
}

// MARK: - League Section Item
struct LeagueSectionItem: SectionItem {
    let id: Int
    let displayName: String
    let imageName: String
    let competition: Competition
    
    init(competition: Competition) {
        self.id = competition.id
        self.displayName = competition.title
        self.competition = competition
        self.imageName = Self.leagueImageName(for: competition.title)
    }
    
    private static func leagueImageName(for title: String) -> String {
        switch title {
        case "Premier League":
            return "Premier League"
        case "UEFA Champions League":
            return "Champions League"
        default:
            return "trophy.fill"
        }
    }
    
    // MARK: - Hashable & Equatable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LeagueSectionItem, rhs: LeagueSectionItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Player Data Structure
struct PlayerData: Identifiable, Hashable {
    let id: Int
    let name: String
}
