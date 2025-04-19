//
//  BaseCoordinator.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation

class BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []

    init() {}

    func addChildCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
