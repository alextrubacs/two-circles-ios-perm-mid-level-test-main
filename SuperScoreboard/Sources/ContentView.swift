import SwiftUI

struct ContentView: View {

    let viewModel = ContentViewModel()

    var body: some View {
        List (viewModel.matches, id: \.id) { match in
            ScoreCard(match: match)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowSpacing(0)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        }
        .listStyle(.insetGrouped)
        .task {
            await viewModel.fetchMatches()
        }
    }
}

#Preview {
    ContentView()
}
