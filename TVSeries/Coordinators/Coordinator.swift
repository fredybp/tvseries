//
//  Coordinator.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }

    func start()
}
