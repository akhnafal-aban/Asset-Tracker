import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Preferences") {
                    Text("Currency: IDR")
                    Text("Appearance")
                }
                
                Section("About") {
                    Text("Version 1.0.0")
                    Text("Privacy Policy")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
