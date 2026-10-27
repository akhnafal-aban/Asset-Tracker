import SwiftUI

struct AssetView: View {
    @State private var viewModel = AssetViewModel()
    @State private var showingAddAsset = false
    @State private var searchText = ""
    
    var filteredAssets: [Asset] {
        if searchText.isEmpty {
            return viewModel.assets
        } else {
            return viewModel.assets.filter { asset in
                asset.name.localizedStandardContains(searchText) ||
                (asset.category?.name ?? "").localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredAssets) { asset in
                NavigationLink(value: asset) {
                    AssetRowView(
                        asset: asset,
                        categoryName: asset.category?.name
                    )
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("All Assets")
            .navigationDestination(for: Asset.self) { asset in
                AssetDetailView(asset: asset)
            }
            .searchable(text: $searchText, prompt: "Search by name or category")
            .overlay {
                if filteredAssets.isEmpty && !viewModel.assets.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else if viewModel.assets.isEmpty {
                    ContentUnavailableView(
                        "No Assets Found",
                        systemImage: "tray.fill",
                        description: Text("Tap + to add your first asset.")
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Asset", systemImage: "plus") {
                        showingAddAsset = true
                    }
                }
            }
            .toolbarTitleDisplayMode(.inlineLarge)
            .sheet(isPresented: $showingAddAsset) {
                AddAssetView()
            }
            .task {
                await viewModel.getAssets()
            }
        }
    }
}

#Preview {
    AssetView()
        .environment(AppSettings())
}
