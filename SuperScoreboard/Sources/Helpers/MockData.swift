import Foundation
import Domain

// MARK: - Mock Data for Previews
struct MockData {
    
    // MARK: - Mock Match Objects
    static let matches: [Match] = [
        liveMatch,
        upcomingMatch,
        finishedMatch,
        highScoringMatch,
        penaltyMatch
    ]
    
    // MARK: - Individual Mock Matches
    
    /// Live match in progress
    static let liveMatch = Match(
        id: 1,
        kickoff: Kickoff(
            completeness: 3,
            millis: Date().timeIntervalSince1970Milliseconds,
            label: "Live"
        ),
        competition: premierLeague,
        teams: [
            MatchTeam(team: psg, score: 2),
            MatchTeam(team: arsenal, score: 1)
        ],
        ground: parcDesPrinces,
        status: "L",
        attendance: 47929,
        clock: Clock(secs: 720, label: "12'"),
        goals: nil
    )
    
    /// Upcoming match
    static let upcomingMatch = Match(
        id: 2,
        kickoff: Kickoff(
            completeness: 3,
            millis: Date().addingTimeInterval(3600).timeIntervalSince1970Milliseconds,
            label: "15:00"
        ),
        competition: premierLeague,
        teams: [
            MatchTeam(team: manchester, score: nil),
            MatchTeam(team: liverpool, score: nil)
        ],
        ground: oldTrafford,
        status: "U",
        attendance: nil,
        clock: nil,
        goals: nil
    )
    
    /// Finished match
    static let finishedMatch = Match(
        id: 3,
        kickoff: Kickoff(
            completeness: 3,
            millis: Date().addingTimeInterval(-7200).timeIntervalSince1970Milliseconds,
            label: "FT"
        ),
        competition: championsLeague,
        teams: [
            MatchTeam(team: barcelona, score: 3),
            MatchTeam(team: realMadrid, score: 2)
        ],
        ground: campNou,
        status: "C",
        attendance: 99354,
        clock: Clock(secs: 5400, label: "FT"),
        goals: nil
    )
    
    /// High scoring match
    static let highScoringMatch = Match(
        id: 4,
        kickoff: Kickoff(
            completeness: 3,
            millis: Date().timeIntervalSince1970Milliseconds,
            label: "Live"
        ),
        competition: premierLeague,
        teams: [
            MatchTeam(team: manchester, score: 127),
            MatchTeam(team: arsenal, score: 99)
        ],
        ground: oldTrafford,
        status: "L",
        attendance: 76000,
        clock: Clock(secs: 2700, label: "45'"),
        goals: nil
    )
    
    /// Penalty shootout match
    static let penaltyMatch = Match(
        id: 5,
        kickoff: Kickoff(
            completeness: 3,
            millis: Date().addingTimeInterval(-1800).timeIntervalSince1970Milliseconds,
            label: "Pens"
        ),
        competition: championsLeague,
        teams: [
            MatchTeam(team: psg, score: 1),
            MatchTeam(team: barcelona, score: 1)
        ],
        ground: parcDesPrinces,
        status: "C",
        attendance: 47929,
        clock: Clock(secs: 6300, label: "Pens"),
        goals: nil
    )
}

// MARK: - Mock Teams
private extension MockData {
    
    static let psg = Team(
        id: 1,
        name: "Paris Saint-Germain",
        shortName: "PSG",
        teamType: "FIRST",
        club: Club(
            id: 1,
            name: "Paris Saint-Germain",
            abbr: "PSG",
            shortName: "Paris SG"
        ),
        altIds: AltIds(opta: "t1")
    )
    
    static let arsenal = Team(
        id: 2,
        name: "Arsenal",
        shortName: "ARS",
        teamType: "FIRST",
        club: Club(
            id: 2,
            name: "Arsenal",
            abbr: "ARS",
            shortName: "Arsenal"
        ),
        altIds: AltIds(opta: "t2")
    )
    
    static let manchester = Team(
        id: 3,
        name: "Manchester United",
        shortName: "MAN",
        teamType: "FIRST",
        club: Club(
            id: 3,
            name: "Manchester United",
            abbr: "MAN",
            shortName: "Man Utd"
        ),
        altIds: AltIds(opta: "t3")
    )
    
    static let liverpool = Team(
        id: 4,
        name: "Liverpool",
        shortName: "LIV",
        teamType: "FIRST",
        club: Club(
            id: 4,
            name: "Liverpool",
            abbr: "LIV",
            shortName: "Liverpool"
        ),
        altIds: AltIds(opta: "t4")
    )
    
    static let barcelona = Team(
        id: 5,
        name: "FC Barcelona",
        shortName: "BAR",
        teamType: "FIRST",
        club: Club(
            id: 5,
            name: "FC Barcelona",
            abbr: "BAR",
            shortName: "Barcelona"
        ),
        altIds: AltIds(opta: "t5")
    )
    
    static let realMadrid = Team(
        id: 6,
        name: "Real Madrid",
        shortName: "RMA",
        teamType: "FIRST",
        club: Club(
            id: 6,
            name: "Real Madrid",
            abbr: "RMA",
            shortName: "Real Madrid"
        ),
        altIds: AltIds(opta: "t6")
    )
}

// MARK: - Mock Competitions
private extension MockData {
    
    static let premierLeague = Competition(
        id: 1,
        title: "Premier League"
    )
    
    static let championsLeague = Competition(
        id: 2,
        title: "UEFA Champions League"
    )
}

// MARK: - Mock Grounds
private extension MockData {
    
    static let parcDesPrinces = Ground(
        id: 1,
        name: "Parc des Princes",
        city: "Paris",
        source: "opta"
    )
    
    static let oldTrafford = Ground(
        id: 2,
        name: "Old Trafford",
        city: "Manchester",
        source: "opta"
    )
    
    static let campNou = Ground(
        id: 3,
        name: "Camp Nou",
        city: "Barcelona",
        source: "opta"
    )
}

// MARK: - Date Extension for Milliseconds
private extension Date {
    var timeIntervalSince1970Milliseconds: Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
}
