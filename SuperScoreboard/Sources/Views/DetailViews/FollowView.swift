import SwiftUI
import Domain

struct FollowView: View {
    @State private var viewModel = FollowViewModel()
    @State private var showErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    loadingView
                } else {
                    followScrollView
                }
            }
            .navigationTitle("Pick your favourites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.selecta(.medium, size: 16))
                    .foregroundColor(Color(hex: "255AF6"))
                }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .onChange(of: viewModel.errorMessage) { _, newValue in
                showErrorAlert = newValue != nil
            }
        }
    }
}

// MARK: - Subviews
private extension FollowView {
    
    var loadingView: some View {
        ProgressView("Loading all items...")
            .font(.selecta(.medium, size: 16))
    }
    
    var followScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Teams Section
                SectionView(
                    title: "All Teams",
                    items: viewModel.allTeams,
                    systemImage: "person.3.fill",
                    columns: 3
                ) { item in
                    GenericItemView(
                        item: item,
                        isFavorited: viewModel.isFavorite(id: item.id, type: .team)
                    )
                } onItemTap: { item in
                    Task {
                        await viewModel.toggleFavorite(id: item.id, type: .team)
                    }
                }

                // Players Section
                SectionView(
                    title: "All Players",
                    items: viewModel.allPlayers,
                    systemImage: "person.fill",
                    columns: 3
                ) { item in
                    GenericItemView(
                        item: item,
                        isFavorited: viewModel.isFavorite(id: item.id, type: .player)
                    )
                } onItemTap: { item in
                    Task {
                        await viewModel.toggleFavorite(id: item.id, type: .player)
                    }
                }
                
                // Leagues Section
                SectionView(
                    title: "All Leagues",
                    items: viewModel.allLeagues,
                    systemImage: "trophy.fill",
                    columns: 2
                ) { item in
                    GenericItemView(
                        item: item,
                        isFavorited: viewModel.isFavorite(id: item.id, type: .match) // Using match type for leagues
                    )
                } onItemTap: { item in
                    Task {
                        await viewModel.toggleFavorite(id: item.id, type: .match) // Using match type for leagues
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    FollowView()
}
