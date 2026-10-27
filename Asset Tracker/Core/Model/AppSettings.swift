//
//  AppSetting.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 20/06/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
class AppSettings {
    var selectedCurrency: String {
        didSet {
            UserDefaults.standard.set(selectedCurrency, forKey: "selectedCurrency")
            if AppConfig.baseURL == "local" {
                print("selectedCurrency: \(selectedCurrency)")
            }
        }
    }
    
    init() {
        self.selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "IDR"
    }
}
