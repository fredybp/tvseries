//
//  PINViewModelTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import XCTest

@testable import TVSeries

class PINViewModelTests: XCTestCase {
    private var coordinator: MockMainCoordinator!
    private var pinService: MockPINService!
    private var viewModel: PINViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        coordinator = MockMainCoordinator()
        pinService = MockPINService()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        coordinator = nil
        pinService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testSetupModeInitialState() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .setup, pinService: pinService)

        XCTAssertEqual(viewModel.mode, .setup)
        XCTAssertEqual(viewModel.pin, "")
        XCTAssertEqual(viewModel.confirmPin, "")
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isVerified)
    }

    func testVerifyModeInitialState() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .verify, pinService: pinService)

        XCTAssertEqual(viewModel.mode, .verify)
        XCTAssertEqual(viewModel.pin, "")
        XCTAssertEqual(viewModel.confirmPin, "")
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isVerified)
    }

    func testUpdatePIN() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .setup, pinService: pinService)

        viewModel.updatePIN("1234")
        XCTAssertEqual(viewModel.pin, "1234")
    }

    func testUpdateConfirmPIN() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .setup, pinService: pinService)

        viewModel.updateConfirmPIN("1234")
        XCTAssertEqual(viewModel.confirmPin, "1234")
    }

    func testSetupSuccess() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .setup, pinService: pinService)

        let expectation = XCTestExpectation(description: "Setup completed")

        viewModel.$isVerified
            .dropFirst()
            .sink { isVerified in
                XCTAssertTrue(isVerified)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.updatePIN("1234")
        viewModel.updateConfirmPIN("1234")
        viewModel.setup()

        wait(for: [expectation], timeout: 1)
    }

    func testSetupFailure() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .setup, pinService: pinService)

        let expectation = XCTestExpectation(description: "Setup failed")

        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.updatePIN("1234")
        viewModel.updateConfirmPIN("5678")
        viewModel.setup()

        wait(for: [expectation], timeout: 1)
    }

    func testVerifySuccess() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .verify, pinService: pinService)

        let expectation = XCTestExpectation(description: "Verify completed")

        viewModel.$isVerified
            .dropFirst()
            .sink { isVerified in
                XCTAssertTrue(isVerified)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.updatePIN("1234")
        viewModel.verify()

        wait(for: [expectation], timeout: 1)
    }

    func testVerifyFailure() {
        viewModel = PINViewModel(coordinator: coordinator, mode: .verify, pinService: pinService)

        let expectation = XCTestExpectation(description: "Verify failed")

        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.updatePIN("5678")
        viewModel.verify()

        wait(for: [expectation], timeout: 1)
    }
}


