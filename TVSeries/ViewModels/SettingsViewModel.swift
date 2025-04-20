//
//  SettingsViewModel.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

class SettingsViewModel: BaseViewModel {

    @Published private(set) var isPINEnabled: Bool
    @Published private(set) var error: PINError?

    private let pinService: PINServiceProtocol

    init(coordinator: MainCoordinator, pinService: PINServiceProtocol) {
        self.pinService = pinService
        self.isPINEnabled = pinService.isPINSet
        super.init(coordinator: coordinator)
    }

    func togglePIN() {
        if isPINEnabled {
            pinService.clearPIN()
            isPINEnabled = false
        } else {
            coordinator?.navigateToPINSetup()
        }
    }

    func changePIN() {
        coordinator?.navigateToPINSetup()
    }
}
