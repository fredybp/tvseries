//
//  SettingsViewModelTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import XCTest

@testable import TVSeries

class SettingsViewModelTests: XCTestCase {
    private var coordinator: MockMainCoordinator!
    private var pinService: MockPINService!
    private var viewModel: SettingsViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        coordinator = MockMainCoordinator()
        pinService = MockPINService()
        viewModel = SettingsViewModel(coordinator: coordinator, pinService: pinService)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        coordinator = nil
        pinService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.isPINEnabled, pinService.isPINSet)
        XCTAssertNil(viewModel.error)
    }

    func testTogglePINWhenEnabled() {
        pinService.isPINSet = true
        viewModel = SettingsViewModel(coordinator: coordinator, pinService: pinService)

        viewModel.togglePIN()

        XCTAssertFalse(viewModel.isPINEnabled)
        XCTAssertFalse(pinService.isPINSet)
    }

    func testTogglePINWhenDisabled() {
        pinService.isPINSet = false
        viewModel = SettingsViewModel(coordinator: coordinator, pinService: pinService)

        viewModel.togglePIN()

        XCTAssertEqual(coordinator.navigateToPINSetupCallCount, 1)
    }

    func testChangePIN() {
        viewModel.changePIN()

        XCTAssertEqual(coordinator.navigateToPINSetupCallCount, 1)
    }
}
