import SwiftUI

struct ErrorView: View {
    let error: AppError
    let isRetrying: Bool
    let onRetry: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: errorIcon)
                .font(.system(size: 48))
                .foregroundColor(.red)

            Text(errorTitle)
                .font(.selecta(.medium, size: 18))
                .foregroundColor(.primary)

            Text(error.errorDescription ?? "An error occurred")
                .font(.selecta(.medium, size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(.selecta(.medium, size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Action Buttons
            HStack(spacing: 12) {
                if !isRetrying {
                    Button("Retry") {
                        onRetry()
                    }
                    .font(.selecta(.medium, size: 16))
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                }
                
                Button("Dismiss") {
                    onDismiss()
                }
                .font(.selecta(.medium, size: 16))
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 8)
        )
    }
    
    // MARK: - Computed Properties
    
    private var errorIcon: String {
        switch error {
        case .networkFailure:
            return "wifi.slash"
        case .dataParsingError:
            return "doc.badge.xmark"
        case .missingRequiredData:
            return "exclamationmark.triangle"
        case .unknownError:
            return "questionmark.circle"
        }
    }
    
    private var errorTitle: String {
        switch error {
        case .networkFailure:
            return "Connection Error"
        case .dataParsingError:
            return "Data Error"
        case .missingRequiredData:
            return "Missing Data"
        case .unknownError:
            return "Unexpected Error"
        }
    }
}

// MARK: - Retrying View
struct RetryingView: View {
    let error: AppError
    
    var body: some View {
        VStack(spacing: 16) {
            // Loading Indicator
            ProgressView()
                .scaleEffect(1.2)
                .tint(.blue)
            
            // Retrying Message
            Text("Retrying...")
                .font(.selecta(.medium, size: 18))
                .foregroundColor(.primary)
            
            // Error Context
            Text(error.errorDescription ?? "An error occurred")
                .font(.selecta(.medium, size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 8)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        ErrorView(
            error: .networkFailure("No internet connection"),
            isRetrying: false,
            onRetry: {},
            onDismiss: {}
        )
        
        ErrorView(
            error: .dataParsingError("Invalid JSON format"),
            isRetrying: false,
            onRetry: {},
            onDismiss: {}
        )
        
        RetryingView(error: .networkFailure("Connection lost"))
    }
    .padding()
}
