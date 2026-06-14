//
//  Asset.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 10/06/26.
//

import Foundation

struct Asset: Codable {
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

}

struct AssetResponse: Codable {
    let data: [Asset]
}
