import SwiftUI

struct DashboardView: View {
    // Static mock data only
    let assets = MockAsset.samples
    @State private var showingAddAsset = false
    
    var totalValue: Double {
        assets.reduce(0) { $0 + $1.currentValue }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Summary Card
                    VStack {
                        Text("Total Portfolio Value")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(totalValue, format: .currency(code: "IDR"))
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 16))
                    .padding()
                    
                    // Recent Assets
                    VStack(alignment: .leading) {
                        Text("Recent Assets")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack {
                            ForEach(assets.prefix(3)) { asset in
                                NavigationLink(value: asset) {
                                    AssetRowView(asset: asset)
                                        .padding(.horizontal)
                                        .padding(.vertical)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: MockAsset.self) { asset in
                AssetDetailView(asset: asset)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Asset", systemImage: "plus") {
                        showingAddAsset = true
                    }
                }
            }
            .sheet(isPresented: $showingAddAsset) {
                AddAssetView()
            }
        }
    }
}
