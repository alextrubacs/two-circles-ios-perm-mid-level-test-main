import Observation
import Domain

@Observable
class ContentViewModel {

    var matches: [Match] = []

    func fetchMatches() async {
        matches = try! await DataSourceFactory.matchesDataSource().execute()
    }
}

