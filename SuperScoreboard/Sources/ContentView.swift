import SwiftUI

struct ContentView: View {
    
    @State var viewModel = ScoreCardListViewModel()

    var body: some View {
        ScoreCardList(groupedMatches: viewModel.groupedMatches)
            .task {
                await viewModel.fetchMatches()
            }
    }
}

#Preview {
    ContentView()
}
