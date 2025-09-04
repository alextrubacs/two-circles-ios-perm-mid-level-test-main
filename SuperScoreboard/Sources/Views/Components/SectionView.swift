import SwiftUI

// MARK: - Generic Section View Protocol
protocol SectionItem: Identifiable, Hashable {
    var id: Int { get }
    var displayName: String { get }
    var imageName: String { get }
}

// MARK: - Generic Section View
struct SectionView<Item: SectionItem, ItemView: View>: View {
    let title: String
    let items: [Item]
    let systemImage: String
    let columns: Int
    let itemView: (Item) -> ItemView
    let onItemTap: (Item) -> Void
    
    init(
        title: String,
        items: [Item],
        systemImage: String,
        columns: Int = 3,
        @ViewBuilder itemView: @escaping (Item) -> ItemView,
        onItemTap: @escaping (Item) -> Void = { _ in }
    ) {
        self.title = title
        self.items = items
        self.systemImage = systemImage
        self.columns = columns
        self.itemView = itemView
        self.onItemTap = onItemTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader
            
            if items.isEmpty {
                emptyStateView
            } else {
                gridView
            }
        }
    }
    
    // MARK: - Section Header
    
    private var sectionHeader: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
                .font(.title2)
            
            Text(title)
                .font(.selecta(.medium, size: 18))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(items.count)")
                .font(.selecta(.medium, size: 16))
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
        }
    }
    
    // MARK: - Grid View
    
    private var gridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: columns),
            spacing: 16
        ) {
            ForEach(items, id: \.id) { item in
                itemView(item)
                    .onTapGesture {
                        onItemTap(item)
                    }
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart")
                .font(.system(size: 30))
                .foregroundColor(.gray)
            
            Text("No \(title.lowercased()) yet")
                .font(.selecta(.medium, size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview
#Preview {
    VStack {
        SectionView(
            title: "Sample Teams",
            items: [TeamSectionItem(team: MockData.matches.first!.teams.first!.team)],
            systemImage: "person.3.fill",
            columns: 3
        ) { item in
            Text(item.displayName)
        }
    }
    .padding()
}
