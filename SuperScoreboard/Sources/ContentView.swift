import SwiftUI

struct ContentView: View {

    @State var viewModel = ScoreCardListViewModel()

    var body: some View {
        NavigationStack {
            matchesView
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension ContentView {
    var matchesView: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else {
                ScoreCardList(groupedMatches: viewModel.groupedMatches)
                    .transition(.blurReplace)
            }
        }
        .task {
            await viewModel.fetchMatches()
        }
        .overlay {
            errorOverlay
        }
    }
}

// MARK: - Loading View
private extension ContentView {
    var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.primary)
            
            Text("Loading matches...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .transition(.blurReplace)
    }
    
    @ViewBuilder
    var errorOverlay: some View {
        switch viewModel.errorState {
        case .none:
            EmptyView()
        case .error(let error):
            ErrorView(
                error: error,
                isRetrying: false,
                onRetry: {
                    Task {
                        await viewModel.retryFetch()
                    }
                },
                onDismiss: {
                    viewModel.dismissError()
                }
            )
            .transition(.opacity.combined(with: .scale))
        case .retrying(let error):
            RetryingView(error: error)
                .transition(.opacity.combined(with: .scale))
        }
    }
}

#Preview {
    ContentView()
}
