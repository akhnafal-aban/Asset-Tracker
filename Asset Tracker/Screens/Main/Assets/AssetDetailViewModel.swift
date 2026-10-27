import Foundation

final class AssetDetailViewModel {
    var isSuccess = false
    var errorMessage: String?
    
    func updateAsset(
        id: Int,
        name: String,
        description: String,
        currentValue: Double
    ) async {
        do {
            let payload = UpdateAssetRequest(
                id: id,
                name: name,
                description: description,
                currentValue: currentValue
            )
            
            let _: Asset = try await Api.send(
                endpoint: "/assets/\(id)",
                method: .put,
                body: payload,
                type: Asset.self
            )

            isSuccess = true
            print("Berhasil update asset: \(isSuccess)")
        } catch {
            errorMessage = error.localizedDescription
            print(error)
        }
    }
    
    func deleteAsset(id: Int) async {
        do {
            _ = try await Api.request(
                endpoint: "/assets/\(id)",
                method: .delete
            )
            
            isSuccess = true
            print("Berhasil delete asset: \(isSuccess)")
        } catch {
            errorMessage = error.localizedDescription
            print(error)
        }
    }
}
