import SwiftUI

struct ContentView: View {
    
    @State var viewModel = ScoreCardListViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else {
                ScoreCardList(groupedMatches: viewModel.groupedMatches)
            }
        }
        .task {
            await viewModel.fetchMatches()
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
    }
}

#Preview {
    ContentView()
}
