import SwiftUI

struct AddAssetView: View {
    @Environment(\.dismiss) private var dismiss
    
    // UI State only - no actual business logic
    @State private var name = ""
    @State private var description = ""
    @State private var category = "Cash"
    @State private var purchasePrice: Double? = nil
    @State private var purchaseDate = Date.now
    
    let categories = ["Cash", "Electronics", "Investment", "Crypto", "Other"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Asset Name", text: $name)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    
                    TextField("Description (Optional)", text: $description)
                }
                
                Section("Financial Details") {
                    TextField("Purchase Price", value: $purchasePrice, format: .currency(code: "IDR"))
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
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
                        // Placeholder for save action
                        dismiss()
                    }
                    .disabled(name.isEmpty || purchasePrice == nil)
                }
            }
        }
    }
}

#Preview {
    AddAssetView()
}
