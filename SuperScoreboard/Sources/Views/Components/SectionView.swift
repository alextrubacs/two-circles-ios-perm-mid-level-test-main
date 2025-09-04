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
                .foregroundColor(Color(hex: "255AF6"))

            Text(title)
                .font(.selecta(.medium, size: 16))
                .foregroundStyle(Color(hex: "1C1B19"))
                .textCase(nil)

            Spacer()
            
            Text("\(items.count)")
                .font(.selecta(.medium, size: 16))
                .foregroundColor(Color(hex: "255AF6"))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: "255AF6").opacity(0.1))
                .cornerRadius(6)
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
            Image("follow_heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
            
            Text("No \(title.lowercased()) yet")
                .font(.selecta(.medium, size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
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
            TeamItemView(item: item, isFavorited: true)
            TeamItemView(item: item, isFavorited: true)
            TeamItemView(item: item, isFavorited: true)
        }
    }
    .padding()
}
