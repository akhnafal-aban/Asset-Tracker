//
//  Asset_TrackerApp.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 14/06/26.
//

import SwiftUI

@main
struct AssetTrackerApp: App {
    @State private var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            AppRootView().environment(appSettings)
        }
    }
}
