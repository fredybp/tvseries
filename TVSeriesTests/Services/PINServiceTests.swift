//
//  PINServiceTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import XCTest

@testable import TVSeries

class PINServiceTests: XCTestCase {
    private var keychain: MockKeychain!
    private var pinService: PINService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        keychain = MockKeychain()
        pinService = PINService(keychain: keychain)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        keychain = nil
        pinService = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertFalse(pinService.isPINSet)
    }

    func testSetPINSuccess() {
        let expectation = XCTestExpectation(description: "Set PIN completed")

        pinService.setPIN("1234", confirmPin: "1234")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not fail")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(pinService.isPINSet)
        XCTAssertEqual(keychain.storedValue, "1234")
    }

    func testSetPINMismatch() {
        let expectation = XCTestExpectation(description: "Set PIN failed")

        pinService.setPIN("1234", confirmPin: "5678")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, PINError.pinMismatch)
                    } else {
                        XCTFail("Should fail with pinMismatch")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(pinService.isPINSet)
        XCTAssertNil(keychain.storedValue)
    }

    func testVerifyPINSuccess() {
        keychain.storedValue = "1234"

        let expectation = XCTestExpectation(description: "Verify PIN completed")

        pinService.verifyPIN("1234")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not fail")
                    }
                    expectation.fulfill()
                },
                receiveValue: { isValid in
                    XCTAssertTrue(isValid)
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testVerifyPINFailure() {
        keychain.storedValue = "1234"

        let expectation = XCTestExpectation(description: "Verify PIN failed")

        pinService.verifyPIN("5678")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not fail")
                    }
                    expectation.fulfill()
                },
                receiveValue: { isValid in
                    XCTAssertFalse(isValid)
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testClearPIN() {
        keychain.storedValue = "1234"

        pinService.clearPIN()

        XCTAssertFalse(pinService.isPINSet)
        XCTAssertNil(keychain.storedValue)
    }
}
