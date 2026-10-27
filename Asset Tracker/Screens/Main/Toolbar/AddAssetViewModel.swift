//
//  AddAssetViewModel.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 15/06/26.
//

import Foundation

@Observable
final class AddAssetViewModel {
    var category: [AssetCategory] = []
    
    var isSuccess = false
    var errorMessage: String?
    
    func getCategories() async {
        do {
            let request = try await Api.send(
                endpoint: "/categories",
                type: AssetCategoryResponse.self
            )
            category = request.data
            print(category)
        } catch {
            print(error)
        }
    }
    
    func addAsset( categoryId: Int, name: String, description: String,
                   purchasePrice: Double, currentValue: Double, purchaseDate: Date
    ) async {
        do {
            let payload = CreateAssetRequest(categoryId: categoryId, name: name,
                                             description: description,purchasePrice: purchasePrice,
                                             currentValue: currentValue, purchaseDate: purchaseDate)
                        
            let _: Asset = try await Api.send(endpoint: "/assets", method: .post,
                                              body: payload, type: Asset.self)
            isSuccess = true
        } catch {
            errorMessage = error.localizedDescription
            print(error)
        }
    }
}
