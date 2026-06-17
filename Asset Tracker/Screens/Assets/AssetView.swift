import SwiftUI

struct AssetView: View {
    let assets = MockAsset.samples
    @State private var showingAddAsset = false
    
    var body: some View {
        NavigationStack {
            List(assets) { asset in
                NavigationLink(value: asset) {
                    AssetRowView(asset: asset)
                }
            }
            .navigationTitle("All Assets")
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
