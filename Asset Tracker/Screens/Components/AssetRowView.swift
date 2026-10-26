import SwiftUI

struct AssetRowView: View {
    @Environment(AppSettings.self) private var appSettings
    let asset: Asset
    let categoryName: String?
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon Placeholder
            Circle()
                .fill(Color.accentColor.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: iconForCategory(categoryName))
                        .foregroundStyle(Color.accentColor)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.name)
                    .font(.body)
                    .fontWeight(.semibold)
                Text(categoryName ?? "Unknown")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(asset.currentValue, format: .currency(code: appSettings.selectedCurrency))
                    .font(.callout)
                    .fontWeight(.semibold)
                
                HStack(spacing: 2) {
                    Image(systemName: asset.isProfitable ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption2.weight(.bold))
                    Text(asset.valueChange, format: .currency(code: "IDR").sign(strategy: .always()))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundStyle(asset.isProfitable ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func iconForCategory(_ name: String?) -> String {
        switch name?.lowercased() {
        case "cash": return "banknote.fill"
        case "crypto": return "bitcoinsign.circle.fill"
        case "physical": return "house.fill"
        case "stocks": return "chart.line.uptrend.xyaxis"
        default: return "tray.fill"
        }
    }
}
