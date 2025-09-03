import SwiftUI

struct ContentView: View {

    let viewModel = ContentViewModel()

    var body: some View {
        List (viewModel.matches, id: \.id) { match in
            ScoreCard()
        }
        .task {
            await viewModel.fetchMatches()
        }
    }
}

#Preview {
    ContentView()
}
