//
//  AssetCategory.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 10/06/26.
//

import Foundation

struct AssetCategory: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
}

struct AssetCategoryResponse: Codable {
    let data: [AssetCategory]
}
