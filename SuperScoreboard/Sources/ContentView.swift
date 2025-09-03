import SwiftUI

struct ContentView: View {

    let viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Text(String(describing: viewModel.matches))
        }
        .padding()
        .task {
            await viewModel.fetchMatches()
        }
    }
}

#Preview {
    ContentView()
}
