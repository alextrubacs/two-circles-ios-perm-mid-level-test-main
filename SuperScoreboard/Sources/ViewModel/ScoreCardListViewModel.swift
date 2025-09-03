import SwiftUI
import Domain

// MARK: - Error State Enum
enum ErrorState: Equatable {
    case none
    case error(AppError)
    case retrying(AppError)
}

@Observable
class ScoreCardListViewModel {

    // MARK: - Properties
    var matches: [Match] = []
    var groupedMatches: [MatchSection] = []
    var isLoading: Bool = true
    var errorState: ErrorState = .none
    
    // MARK: - Error Recovery Properties
    var retryCount = 0
    var maxRetries = 3
    internal var lastSuccessfulFetch: [Match] = []
    
    // MARK: - Public Methods
    
    func fetchMatches() async {
        await fetchFreshData()
    }
    
    func retryFetch() async {
        errorState = .retrying(errorState.error ?? .unknownError("Unknown error"))
        await fetchFreshData()
    }
    
    func dismissError() {
        errorState = .none
    }
    
    // MARK: - Private Methods
    
    internal func fetchFreshData() async {
        isLoading = true
        errorState = .none
        
        defer {
            isLoading = false
        }
        
        do {
            let freshMatches = try await DataSourceFactory.matchesDataSource().execute()
            
            // Validate the fetched data
            guard !freshMatches.isEmpty else {
                throw AppError.missingRequiredData("No match data received from server")
            }
            
            // Validate each match has required data
            for match in freshMatches {
                try validateMatch(match)
            }
            
            // Update state with successful data
            matches = freshMatches
            lastSuccessfulFetch = freshMatches
            retryCount = 0
            groupMatchesByLeague()
            
        } catch {
            await handleFetchError(error)
        }
    }
    
    internal func handleFetchError(_ error: Error) async {
        let appError = convertToAppError(error)
        
        // If we have cached data, show error but keep data
        if !lastSuccessfulFetch.isEmpty {
            errorState = .error(appError)
            return
        }
        
        // If we can retry, do so
        if retryCount < maxRetries {
            retryCount += 1
            errorState = .retrying(appError)
            
            // Exponential backoff
            let delay = TimeInterval(pow(2.0, Double(retryCount - 1)))
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            
            await fetchFreshData()
        } else {
            // Max retries reached, show error
            errorState = .error(appError)
        }
    }
    
    private func validateMatch(_ match: Match) throws {
        guard !match.teams.isEmpty else {
            throw AppError.missingRequiredData("Match missing team data")
        }
        
        for team in match.teams {
            guard !team.team.club.name.isEmpty else {
                throw AppError.missingRequiredData("Team missing club name")
            }
        }
    }
    
    private func convertToAppError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        
        // Convert common errors to AppError
        switch error {
        case let urlError as URLError:
            return .networkFailure("Failed to fetch match data: \(urlError.localizedDescription)")
        case let decodingError as DecodingError:
            return .dataParsingError("Failed to parse match data: \(decodingError.localizedDescription)")
        default:
            return .unknownError("Failed to fetch match data: \(error.localizedDescription)")
        }
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

// MARK: - Error State Extension
extension ErrorState {
    var error: AppError? {
        switch self {
        case .none:
            return nil
        case .error(let error), .retrying(let error):
            return error
        }
    }
    
    var isRetrying: Bool {
        switch self {
        case .retrying:
            return true
        case .none, .error:
            return false
        }
    }
}
