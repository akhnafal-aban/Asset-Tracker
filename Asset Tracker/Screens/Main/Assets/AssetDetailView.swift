import SwiftUI
import Charts

struct AssetDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var appSettings

    
    @State private var viewModel = AssetDetailViewModel()
    @State private var isEditing = false
    
    let asset: Asset
    
    @State private var draftCurrentValue: Double = 0
    @State private var draftName: String = ""
    @State private var draftDescription: String = ""
    
    // Dummy depreciation/growth history data
    var historyData: [(date: String, value: Double)] {
        // Generate a simple curve based on purchase price and current value
        return [
            ("Purchase", asset.purchasePrice),
            ("Quarter 1", asset.purchasePrice + (asset.currentValue - asset.purchasePrice) * 0.3),
            ("Quarter 2", asset.purchasePrice + (asset.currentValue - asset.purchasePrice) * 0.6),
            ("Quarter 3", asset.purchasePrice + (asset.currentValue - asset.purchasePrice) * 0.8),
            ("Current", asset.currentValue)
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main Value Header
                VStack(spacing: 8) {
                    if isEditing {
                        TextField("Current Value", value: $draftCurrentValue, format: .currency(code: appSettings.selectedCurrency))
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal)
                    } else {
                        Text(draftCurrentValue, format: .currency(code: appSettings.selectedCurrency))
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                        
                        HStack(spacing: 6) {
                            Image(systemName: asset.isProfitable ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                            Text(asset.valueChange, format: .currency(code: appSettings.selectedCurrency).sign(strategy: .always()))
                        }
                        .font(.headline)
                        .foregroundStyle(asset.isProfitable ? .green : .red)
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
                
                // History/Depreciation Chart Insight
                if !isEditing {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Value History")
                            .font(.headline)
                        
                        Chart {
                            ForEach(historyData, id: \.date) { item in
                                LineMark(
                                    x: .value("Timeline", item.date),
                                    y: .value("Value", item.value)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(asset.isProfitable ? Color.green.gradient : Color.red.gradient)
                                .symbol(Circle())
                                
                                AreaMark(
                                    x: .value("Timeline", item.date),
                                    y: .value("Value", item.value)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(LinearGradient(
                                    colors: [
                                        (asset.isProfitable ? Color.green : Color.red).opacity(0.3),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                            }
                        }
                        .frame(height: 150)
                        
                        HStack {
                            Text("Total Return")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            let percentage = asset.purchasePrice > 0 ? (asset.currentValue - asset.purchasePrice) / asset.purchasePrice * 100 : 0
                            Text("\(percentage, specifier: "%.1f")%")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(asset.isProfitable ? .green : .red)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal)
                }
                
                // Asset Details Form Card
                VStack(alignment: .leading, spacing: 0) {
                    if isEditing {
                        VStack(spacing: 0) {
                            EditRow(title: "Name") {
                                TextField("Asset Name", text: $draftName)
                                    .multilineTextAlignment(.trailing)
                            }
                            Divider().padding(.leading)
                            EditRow(title: "Description") {
                                TextField("Description", text: $draftDescription)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    } else {
                        VStack(spacing: 0) {
                            DetailRow(title: "Name", value: draftName)
                            Divider().padding(.leading)
                            DetailRow(title: "Category", value: asset.category?.name ?? "Unknown")
                            Divider().padding(.leading)
                            DetailRow(title: "Purchase Price", value: asset.purchasePrice.formatted(.currency(code: "IDR")))
                            Divider().padding(.leading)
                            DetailRow(title: "Purchase Date", value: asset.purchaseDate.formatted(date: .abbreviated, time: .omitted))
                            
                            if !draftDescription.isEmpty {
                                Divider().padding(.leading)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Description")
                                        .foregroundStyle(.secondary)
                                    Text(draftDescription)
                                        .font(.body)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)
                
                // Delete Button
                if isEditing {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.deleteAsset(id: asset.id)
                            if viewModel.isSuccess {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Delete Asset")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
            }
            .padding(.bottom, 32)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(isEditing ? "Edit Asset" : asset.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            draftCurrentValue = asset.currentValue
            draftName = asset.name
            draftDescription = asset.description
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        Task {
                            await viewModel.updateAsset(
                                id: asset.id,
                                name: draftName,
                                description: draftDescription,
                                currentValue: draftCurrentValue
                            )
                            if viewModel.isSuccess {
                                isEditing = false
                            }
                        }
                    } else {
                        isEditing = true
                    }
                }
                .fontWeight(.semibold)
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
        .padding()
    }
}

struct EditRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            content
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        AssetDetailView(asset: Asset(
            id: 1,
            userId: 1,
            categoryId: 1,
            name: "Emergency Fund",
            description: "Savings account in Bank Mandiri",
            purchasePrice: 2000000,
            currentValue: 2500000,
            purchaseDate: Date(),
            createdAt: Date(),
            updatedAt: Date(),
            category: AssetCategory(
                id: 1,
                name: "Cash",
                description: "Testing"
            )
        ))
        .environment(AppSettings())
    }
}
