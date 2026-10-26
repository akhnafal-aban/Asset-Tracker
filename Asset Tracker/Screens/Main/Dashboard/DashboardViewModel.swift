//
//  DashboardViewModel.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 15/06/26.
//

import Foundation
import Observation

@Observable
final class DashboardViewModel {
    var assets: [Asset] = []
    
    var totalValue: Double {
        assets.reduce(0) { $0 + $1.currentValue }
    }
    
    var assetsCount: String {
        String(assets.count)
    }
    
    var top3HighestValueAssets: [Asset] {
        assets
            .sorted { $0.currentValue > $1.currentValue }
            .prefix(3)
            .map { $0 }
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
