import SwiftUI

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
    RetryingView(error: .networkFailure("Connection lost"))
        .padding()
}
