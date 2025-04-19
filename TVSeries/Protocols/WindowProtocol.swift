//
//  WindowProtocol.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

protocol WindowProtocol: AnyObject {
    var rootViewController: UIViewController? { get set }
    var isKeyWindow: Bool { get }
    func makeKeyAndVisible()
}

extension UIWindow: WindowProtocol {}
