//
//  MockPINService.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation
import Combine

@testable import TVSeries

class MockPINService: PINServiceProtocol {
    var isPINSet = true
    var storedPIN = "1234"

    func setPIN(_ pin: String, confirmPin: String) -> AnyPublisher<Void, PINError> {
        if pin == confirmPin {
            storedPIN = pin
            return Just(()).setFailureType(to: PINError.self).eraseToAnyPublisher()
        } else {
            return Fail(error: PINError.pinMismatch).eraseToAnyPublisher()
        }
    }

    func verifyPIN(_ pin: String) -> AnyPublisher<Bool, PINError> {
        if pin == storedPIN {
            return Just(true).setFailureType(to: PINError.self).eraseToAnyPublisher()
        } else {
            return Just(false).setFailureType(to: PINError.self).eraseToAnyPublisher()
        }
    }

    func clearPIN() {
        storedPIN = ""
        isPINSet = false
    }
}
