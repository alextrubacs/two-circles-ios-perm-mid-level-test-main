import Foundation

// MARK: - App Error Types
public enum AppError: LocalizedError, Sendable {
    case networkFailure(String)
    case dataParsingError(String)
    case missingRequiredData(String)
    case unknownError(String)
    
    // MARK: - LocalizedError Conformance
    
    public var errorDescription: String? {
        switch self {
        case .networkFailure(let message):
            return message
        case .dataParsingError(let message):
            return message
        case .missingRequiredData(let message):
            return message
        case .unknownError(let message):
            return message
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .networkFailure:
            return "Please check your internet connection and try again."
        case .dataParsingError:
            return "The data format is invalid. Please contact support."
        case .missingRequiredData:
            return "Some required information is missing. Please try refreshing."
        case .unknownError:
            return "An unexpected error occurred. Please try again later."
        }
    }
}
