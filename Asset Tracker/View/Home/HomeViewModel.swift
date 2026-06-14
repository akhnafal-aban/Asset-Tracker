//
//  HomeViewModel.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 14/06/26.
//

import Observation
import Foundation

@Observable
final class HomeViewModel {
    var assets: [Asset] = []
    
    func fetchAsset() async throws {
        let data = try await Api.get(endpoint: "/assets")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(AssetResponse.self, from: data)
        assets = response.data
    }
}
