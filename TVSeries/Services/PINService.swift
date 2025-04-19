//
//  PINService.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

enum PINError: Error {
    case pinMismatch
    case pinNotSet
}

protocol PINServiceProtocol {
    var isPINSet: Bool { get }
    func setPIN(_ pin: String, confirmPin: String) -> AnyPublisher<Void, PINError>
    func verifyPIN(_ pin: String) -> AnyPublisher<Bool, PINError>
    func clearPIN()
}

class PINService: PINServiceProtocol {
    private var keychain: KeychainProtocol
    private let pinKey = "com.tvseries.pin"

    var isPINSet: Bool {
        keychain[pinKey] != nil
    }

    init(keychain: KeychainProtocol = Keychain.standard) {
        self.keychain = keychain
    }

    func setPIN(_ pin: String, confirmPin: String) -> AnyPublisher<Void, PINError> {
        if pin != confirmPin {
            return Fail(error: PINError.pinMismatch).eraseToAnyPublisher()
        }

        keychain[pinKey] = pin
        return Just(()).setFailureType(to: PINError.self).eraseToAnyPublisher()
    }

    func verifyPIN(_ pin: String) -> AnyPublisher<Bool, PINError> {
        guard let storedPIN = keychain[pinKey] else {
            return Fail(error: PINError.pinNotSet).eraseToAnyPublisher()
        }

        return Just(pin == storedPIN).setFailureType(to: PINError.self).eraseToAnyPublisher()
    }

    func clearPIN() {
        keychain[pinKey] = nil
    }
}
