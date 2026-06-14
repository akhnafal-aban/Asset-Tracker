//
//  HomeView.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 10/06/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        List(viewModel.assets, id: \.id) { asset in
            Text("Asset Name:" + asset.name)
        }
        .task {
            do {
                try await viewModel.fetchAsset()
            } catch {
                print("HomeView task error: \(error)")
            }
        }
    }
}

#Preview {
    HomeView()
}
