//
//  UserDefaultsMock.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Foundation

class UserDefaultsMock: UserDefaultsProtocol {
    private var storage: [String: Any] = [:]
    private(set) var arrayCallCount = 0
    private(set) var setCallCount = 0
    private(set) var lastSetKey: String?
    private(set) var lastSetValue: Any?

    func array(forKey defaultName: String) -> [Any]? {
        arrayCallCount += 1
        return storage[defaultName] as? [Any]
    }

    func set(_ value: Any?, forKey defaultName: String) {
        setCallCount += 1
        lastSetKey = defaultName
        lastSetValue = value
        storage[defaultName] = value
    }

    func reset() {
        storage.removeAll()
        arrayCallCount = 0
        setCallCount = 0
        lastSetKey = nil
        lastSetValue = nil
    }
    
    init(initialData storage: [String: Any] = [:]) {
        self.storage = storage
    }
}
