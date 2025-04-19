//
//  SettingsViewModel.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

class SettingsViewModel: BaseViewModel {
    @Published var settings: [String: Bool] = [
        "Enable Notifications": true,
        "Dark Mode": false,
        "Auto-Refresh": true,
    ]

    func updateSetting(key: String, value: Bool) {
        settings[key] = value
    }
}
