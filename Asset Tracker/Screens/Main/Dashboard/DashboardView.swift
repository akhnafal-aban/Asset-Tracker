import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(AppSettings.self) var appSettings
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingAddAsset = false
    @State private var viewModel = DashboardViewModel()
    
    let performanceData: [(month: String, value: Double)] = [
        ("Jan", 15000000), ("Feb", 16200000), ("Mar", 15800000),
        ("Apr", 17500000), ("May", 19000000), ("Jun", 21500000)
    ]
    
    let allocationData: [(category: String, percentage: Double, color: Color)] = [
        ("Cash", 45, .green),
        ("Crypto", 25, .orange),
        ("Physical", 20, .blue),
        ("Stocks", 10, .purple)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Portfolio Value")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Text(viewModel.totalValue, format: .currency(code: appSettings.selectedCurrency))
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                                            
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.right.circle.fill")
                                .foregroundStyle(.green)
                            Text("+IDR 2,500,000 (12.5%)")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(.green)
                            Text("vs last month")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
                    .padding(.horizontal)
                    
                    // Portfolio Performance Chart
                    VStack(alignment: .leading) {
                        Text("Performance")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(performanceData, id: \.month) { item in
                                LineMark(
                                    x: .value("Month", item.month),
                                    y: .value("Value", item.value)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(Color.accentColor.gradient)
                                .symbol(Circle())
                                
                                AreaMark(
                                    x: .value("Month", item.month),
                                    y: .value("Value", item.value)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(LinearGradient(
                                    colors: [Color.accentColor.opacity(0.3), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                            }
                        }
                        .frame(height: 180)
                        .padding()
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Asset Allocation")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            Chart {
                                ForEach(allocationData, id: \.category) { item in
                                    SectorMark(
                                        angle: .value("Percentage", item.percentage),
                                        innerRadius: .ratio(0.65),
                                        angularInset: 1.5
                                    )
                                    .cornerRadius(4)
                                    .foregroundStyle(item.color)
                                }
                            }
                            .frame(width: 120, height: 120)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(allocationData, id: \.category) { item in
                                    HStack {
                                        Circle()
                                            .fill(item.color)
                                            .frame(width: 8, height: 8)
                                        Text(item.category)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("\(Int(item.percentage))%")
                                            .font(.subheadline)
                                            .bold()
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Quick Stats")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatCardView(tittle: "Total Assets", value: viewModel.assetsCount, unit: "Items")
                            StatCardView(tittle: "Physical", value: "3", unit: "Units")
                            StatCardView(tittle: "Liquid Cash", value: "2", unit: "Accounts")
                            StatCardView(tittle: "Investments", value: "1", unit: "Portfolio")
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Recent Assets")
                                .font(.headline)
                            Spacer()
                            NavigationLink("View All", destination: AssetView())
                                .font(.subheadline)
                                .foregroundStyle(Color.accentColor)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            if viewModel.top3HighestValueAssets.isEmpty {
                                ContentUnavailableView(
                                    "No Assets Found",
                                    systemImage: "tray.fill",
                                    description: Text("Tap + to add your first asset.")
                                )
                                .padding()
                            } else {
                                ForEach(Array(viewModel.top3HighestValueAssets.enumerated()), id: \.element.id) { index, asset in
                                    NavigationLink(value: asset) {
                                        AssetRowView(
                                            asset: asset,
                                            categoryName: asset.category?.name
                                        )
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    if index < viewModel.top3HighestValueAssets.count - 1 {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                        }
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
                .padding(.vertical)
                .task {
                    await viewModel.getAssets()
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Dashboard")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Asset", systemImage: "plus") {
                        showingAddAsset = true
                    }
                }
            }
            .navigationDestination(for: Asset.self) { asset in
                AssetDetailView(asset: asset)
            }
            .sheet(isPresented: $showingAddAsset) {
                AddAssetView()
            }
        }
    }
}

#Preview {
    DashboardView().environment(AppSettings())
}
