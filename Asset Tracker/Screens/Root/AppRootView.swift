import SwiftUI

struct AppRootView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "chart.pie.fill") {
                DashboardView()
            }
            
            Tab("Assets", systemImage: "list.bullet.rectangle.portrait") {
                AssetView()
            }
            
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
            
            Tab("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
                CryptoDashboardView()
            }
        }
    }
}

#Preview {
    AppRootView()
        .environment(AppSettings())
}
