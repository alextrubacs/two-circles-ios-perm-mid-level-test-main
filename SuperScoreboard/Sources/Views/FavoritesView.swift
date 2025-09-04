//
//  FavoritesView.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 04/09/2025.
//

import SwiftUI

struct FavoritesView: View {
    @State private var favoritesViewModel = FavoritesViewModel()
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if favoritesViewModel.isLoading {
                    loadingView
                } else {
                    favoritesScrollView
                }
            }
            .navigationTitle("Favorites")
            .font(.selecta(.medium, size: 24))
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {
                    favoritesViewModel.clearError()
                }
            } message: {
                if let errorMessage = favoritesViewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .onChange(of: favoritesViewModel.errorMessage) { _, newValue in
                showErrorAlert = newValue != nil
            }
        }
    }
}

// MARK: - Subviews
private extension FavoritesView {
    func favoritesSection(title: String, count: Int, systemImage: String) -> some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
                .font(.title2)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.selecta(.medium, size: 18))
                    .foregroundColor(.primary)

                Text("\(count) item(s)")
                    .font(.selecta(.medium, size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("\(count)")
                .font(.selecta(.medium, size: 20))
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(16)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    var loadingView: some View {
        ProgressView("Loading favorites...")
            .font(.selecta(.medium, size: 16))
    }

    var favoritesScrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                favoritesSection(
                    title: "Favorite Teams",
                    count: favoritesViewModel.favoriteTeams.count,
                    systemImage: "person.3.fill"
                )
                
                favoritesSection(
                    title: "Favorite Matches",
                    count: favoritesViewModel.favoriteMatches.count,
                    systemImage: "sportscourt.fill"
                )
                
                favoritesSection(
                    title: "Favorite Players",
                    count: favoritesViewModel.favoritePlayers.count,
                    systemImage: "person.fill"
                )
                
                if !favoritesViewModel.favoriteTeams.isEmpty ||
                   !favoritesViewModel.favoriteMatches.isEmpty ||
                   !favoritesViewModel.favoritePlayers.isEmpty {
                    
                    Button("Clear All Favorites") {
                        Task {
                            await favoritesViewModel.clearAllFavorites()
                        }
                    }
                    .foregroundColor(.red)
                    .font(.selecta(.medium, size: 16))
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    FavoritesView()
}
