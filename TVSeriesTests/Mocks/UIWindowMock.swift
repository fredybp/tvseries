//
//  WindowMock.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

@testable import TVSeries

class WindowMock: WindowProtocol {
    private(set) var makeKeyAndVisibleCallCount = 0
    var rootViewController: UIViewController?
    private(set) var isKeyWindow = false

    func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount += 1
        isKeyWindow = true
    }

    func reset() {
        makeKeyAndVisibleCallCount = 0
        rootViewController = nil
        isKeyWindow = false
    }
    
    init(rootViewController: UIViewController? = nil) {
        self.rootViewController = rootViewController
    }
}
