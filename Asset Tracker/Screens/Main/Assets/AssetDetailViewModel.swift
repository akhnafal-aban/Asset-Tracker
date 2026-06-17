import SwiftUI

struct AssetDetailView: View {
    let asset: Asset
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                VStack(alignment: .leading) {
                    Text("Current Value")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(asset.currentValue, format: .currency(code: "IDR"))
                        .font(.largeTitle)
                        .bold()
                    
                    HStack {
                        Image(
                            systemName: asset.isProfitable ? "arrow.up.right" : "arrow.down.right"
                        )
                        Text(
                            asset.valueChange,
                            format: 
                                    .currency(code: "IDR")
                                    .sign(strategy: .always())
                        )
                    }
                    .font(.headline)
                    .foregroundStyle(asset.isProfitable ? .green : .red)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .clipShape(.rect(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text("Asset Details")
                        .font(.headline)
                        .padding(.top)
                    
                    DetailRow(title: "Name", value: asset.name)
                    DetailRow(
                        title: "Category",
                        value: asset.category?.name ?? "Unknown"
                    )
                    DetailRow(
                        title: "Purchase Price",
                        value: asset.purchasePrice
                            .formatted(.currency(code: "IDR"))
                    )
                    DetailRow(
                        title: "Purchase Date",
                        value: asset.purchaseDate
                            .formatted(date: .abbreviated, time: .omitted)
                    )
                    
                    if !asset.description.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Notes")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(asset.description)
                                .font(.body)
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle(asset.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable micro-component for detail rows
struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .padding(.vertical)
    }
}


#Preview {
    AssetDetailView(asset: Asset(
        id: 1,
        userId: 1,
        categoryId: 1,
        name: "Emergency Fund",
        description: "Savings account in Bank Mandiri",
        purchasePrice: 2_000_000,
        currentValue: 2_500_000,
        purchaseDate: Date(),
        createdAt: Date(),
        updatedAt: Date(),
        category: AssetCategory(
            id: 1,
            name: "Cash",
            description: "Testing"
        )
    ))
}
