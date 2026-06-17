import SwiftUI

struct AssetRowView: View {
    let asset: Asset
    let categoryName: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(asset.name)
                    .font(.headline)
                Text(categoryName ?? "Unknown")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(asset.currentValue, format: .currency(code: "IDR"))
                    .bold()
                
                Text(asset.valueChange, format: .currency(code: "IDR").sign(strategy: .always()))
                    .font(.caption)
                    .foregroundStyle(asset.isProfitable ? .green : .red)
            }
        }
    }
}
