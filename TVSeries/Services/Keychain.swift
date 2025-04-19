//
//  Keychain.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation
import Security

protocol KeychainProtocol {
    subscript(key: String) -> String? { get set }
}

class Keychain: KeychainProtocol {
    static let standard = Keychain()

    private init() {}

    subscript(key: String) -> String? {
        get {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true,
            ]

            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)

            guard status == errSecSuccess,
                let data = result as? Data,
                let value = String(data: data, encoding: .utf8)
            else {
                return nil
            }

            return value
        }
        set {
            if let value = newValue {
                let data = value.data(using: .utf8)!

                var query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: key,
                    kSecValueData as String: data,
                ]

                let status = SecItemAdd(query as CFDictionary, nil)

                if status == errSecDuplicateItem {
                    let updateQuery: [String: Any] = [
                        kSecClass as String: kSecClassGenericPassword,
                        kSecAttrAccount as String: key,
                    ]

                    let updateAttributes: [String: Any] = [
                        kSecValueData as String: data
                    ]

                    SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)
                }
            } else {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: key,
                ]

                SecItemDelete(query as CFDictionary)
            }
        }
    }
}
