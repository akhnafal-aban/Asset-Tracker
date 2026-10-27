import SwiftUI

struct SettingsView: View {
    @Environment(AppSettings.self) private var appSettings
    
    var body: some View {
        @Bindable var settings = appSettings
        NavigationStack {
            List {
                Section("Preferences") {
                    Picker("Currency", selection: $settings.selectedCurrency){
                        Text("IDR").tag("IDR")
                        Text("USD").tag("USD")
                    }
                    .pickerStyle(.segmented)
                    Text("Appearance")
                }
                
                Section("About") {
                    Text("Version 1.0.0")
                    Text("Privacy Policy")
                }
            }
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inlineLarge)

        }
    }
}

#Preview {
    SettingsView()
        .environment(AppSettings())
}
