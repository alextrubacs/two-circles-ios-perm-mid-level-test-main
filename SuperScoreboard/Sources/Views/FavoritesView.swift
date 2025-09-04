import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
                .opacity(0.6)
            
            Text("Favorites")
                .font(.selecta(.medium, size: 24))
                .foregroundColor(.primary)
            
            Text("Your favorite matches will appear here")
                .font(.selecta(.medium, size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Coming Soon")
                .font(.selecta(.medium, size: 14))
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    FavoritesView()
}
