//
//  User.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 10/06/26.
//

import SwiftUI
import Foundation

struct User: Codable, Identifiable, Hashable{
    let id: Int
    let name: String
    let email: String
}

struct UserResponse: Codable {
    let data: [User]
}
