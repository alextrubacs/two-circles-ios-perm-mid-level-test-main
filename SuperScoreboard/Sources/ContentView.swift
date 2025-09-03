import SwiftUI

struct ContentView: View {

    @State var viewModel = ContentViewModel()

    var body: some View {
        List {
            ForEach(viewModel.groupedMatches) { section in
                Section(header: LeagueHeader(title: section.leagueName)) {
                    ForEach(section.matches, id: \.id) { match in
                        ScoreCard(match: match)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowSpacing(0)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 4, trailing: 0))
                    }
                }
                .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 4, trailing: 0))
            }

            FollowBanner {

            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowSpacing(0)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
