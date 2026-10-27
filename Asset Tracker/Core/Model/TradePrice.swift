//
//  TradePrice.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 18/06/26.
//

import Foundation

struct TradePrice: nonisolated Decodable {
    let symbol: String
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case price = "p"
    }
}
