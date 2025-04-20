//
//  UserDefaultsProtocol.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation

protocol UserDefaultsProtocol {
    func array(forKey defaultName: String) -> [Any]?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}
