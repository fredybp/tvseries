//
//  MockKeychain.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation

@testable import TVSeries

class MockKeychain: KeychainProtocol {
    var storedValue: String?

    subscript(key: String) -> String? {
        get { storedValue }
        set { storedValue = newValue }
    }
}
