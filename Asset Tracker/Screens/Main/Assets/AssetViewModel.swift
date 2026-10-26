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
    
    func getAssets() async {
        do {
            let response = try await Api.send(
                endpoint: "/assets",
                type: AssetResponse.self
            )
            
            assets = response.data
        } catch {
            print(error)
        }
    }
}
