import Observation
import Foundation
import Domain

@Observable
class ContentViewModel {

    var matches: [Match] = []
    var groupedMatches: [MatchSection] = []

    func fetchMatches() async {
        matches = try! await DataSourceFactory.matchesDataSource().execute()
        groupMatchesByLeague()
    }
    
    private func groupMatchesByLeague() {
        let grouped = Dictionary(grouping: matches) { match in
            match.competition?.title
        }

        groupedMatches = grouped.map { (leagueName, matches) in
            MatchSection(leagueName: leagueName ?? "Unknown League", matches: matches)
        }.sorted { $0.leagueName < $1.leagueName }
    }
}
