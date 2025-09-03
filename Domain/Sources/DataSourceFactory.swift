import Foundation
import Core

public enum DataSourceFactory {

    public static func matchesDataSource() -> some DataSource<[Match]> {
        RemoteDataSource(client: URLSessionClient(), url: URL(string: "https://pyates-twocircles.github.io/two-circles-tech-test/fixtures.json")!)
    }
}
