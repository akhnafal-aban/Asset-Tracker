//
//  Asset.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 10/06/26.
//

import Foundation

struct Asset: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let categoryId: Int
    let name: String
    let description: String
    let purchasePrice: Double
    let currentValue: Double
    let purchaseDate: Date
    let createdAt: Date
    let updatedAt: Date
    let category: AssetCategory?
}

struct AssetResponse: Codable {
    let data: [Asset]
}

struct ApiMessage: Codable {
    let message: String
}

struct CreateAssetRequest: Encodable {
    let categoryId: Int
    let name: String
    let description: String?
    let purchasePrice: Double
    let currentValue: Double
    let purchaseDate: Date
}

struct UpdateAssetRequest: Encodable, Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let currentValue: Double?
}

extension Asset {
    var valueChange: Double {
        currentValue - purchasePrice
    }
    
    var isProfitable: Bool {
        valueChange >= 0
    }
}
