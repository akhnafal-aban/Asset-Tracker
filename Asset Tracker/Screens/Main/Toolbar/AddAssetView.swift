import SwiftUI



struct AddAssetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddAssetViewModel()
    
    @State private var selectedCategoryId: Int = 1
    @State private var name = ""
    @State private var description = ""
    @State private var purchasePrice: Double? = nil
    @State private var currentValue: Double? = nil
    @State private var purchaseDate = Date.now
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Asset Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategoryId) {
                        ForEach(viewModel.category, id: \.self) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                    
                    TextField("Description (Optional)", text: $description)
                }
                
                Section("Financial Details") {
                    TextField(
                        "Purchase Price",
                        value: $purchasePrice,
                        format: .currency(code: "IDR")
                    )
                    .keyboardType(.decimalPad)
                    
                    DatePicker(
                        "Purchase Date",
                        selection: $purchaseDate,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("New Asset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.addAsset(
                                categoryId: selectedCategoryId,
                                name: name,
                                description: description,
                                purchasePrice: purchasePrice ?? 0,
                                currentValue: purchasePrice ?? 0,
                                purchaseDate: purchaseDate
                            )
                        }
                    }
                    .disabled(name.isEmpty || purchasePrice == nil)
                }
            }
        }
        .task {
            await viewModel.getCategories()
        }
    }
}

#Preview {
    AddAssetView()
}
