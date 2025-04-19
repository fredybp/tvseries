//
//  KeychainTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import XCTest

@testable import TVSeries

class KeychainTests: XCTestCase {
    private var keychain: Keychain!
    private let testKey = "test.key"
    private let testValue = "test.value"

    override func setUp() {
        super.setUp()
        keychain = Keychain.standard
        // Clear any existing value
        keychain[testKey] = nil
    }

    override func tearDown() {
        // Clean up
        keychain[testKey] = nil
        keychain = nil
        super.tearDown()
    }

    func testStoreAndRetrieveValue() {
        // Store value
        keychain[testKey] = testValue

        // Retrieve value
        let retrievedValue = keychain[testKey]

        XCTAssertEqual(retrievedValue, testValue)
    }

    func testUpdateValue() {
        // Store initial value
        keychain[testKey] = testValue

        // Update value
        let newValue = "new.value"
        keychain[testKey] = newValue

        // Retrieve updated value
        let retrievedValue = keychain[testKey]

        XCTAssertEqual(retrievedValue, newValue)
    }

    func testDeleteValue() {
        // Store value
        keychain[testKey] = testValue

        // Delete value
        keychain[testKey] = nil

        // Try to retrieve deleted value
        let retrievedValue = keychain[testKey]

        XCTAssertNil(retrievedValue)
    }

    func testStoreEmptyValue() {
        // Store empty value
        keychain[testKey] = ""

        // Retrieve value
        let retrievedValue = keychain[testKey]

        XCTAssertEqual(retrievedValue, "")
    }

    func testStoreSpecialCharacters() {
        let specialValue = "test!@#$%^&*()_+"

        // Store value with special characters
        keychain[testKey] = specialValue

        // Retrieve value
        let retrievedValue = keychain[testKey]

        XCTAssertEqual(retrievedValue, specialValue)
    }

    func testStoreLongValue() {
        let longValue = String(repeating: "a", count: 1000)

        // Store long value
        keychain[testKey] = longValue

        // Retrieve value
        let retrievedValue = keychain[testKey]

        XCTAssertEqual(retrievedValue, longValue)
    }
}
