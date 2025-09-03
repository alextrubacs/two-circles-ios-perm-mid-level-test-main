import SwiftUI
import Domain

@Observable
class ScoreCardListViewModel {

    var matches: [Match] = []
    var groupedMatches: [MatchSection] = []
    var isLoading: Bool = true

    func fetchMatches() async {
        withAnimation {
            isLoading = true
        }
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
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
