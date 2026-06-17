//
//  DashboardViewModel.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 15/06/26.
//

import Foundation
import Observation

@Observable
final class AssetViewModel {
    var assets: [Asset] = []
    var categories: [AssetCategory] = []
    
    func category(for asset: Asset) -> AssetCategory? {
        categories.first { $0.id == asset.categoryId}
    }
    
    func fetchAsset() async {
        do {
            let data = try await Api.get(endpoint: "/assets")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601

            let response = try decoder.decode(AssetResponse.self, from: data)
            assets = response.data
        } catch {
            print(error)
        }
    }
}
