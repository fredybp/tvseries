//
//  MainCoordinator.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = HomeViewModel(coordinator: self, tvMazeService: TVMazeService())
        let homeVC = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(homeVC, animated: false)
    }

    func navigateToDetail(with show: TVShow) {
        let viewModel = DetailViewModel(
            coordinator: self, show: show, tvMazeService: TVMazeService())
        let detailVC = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }

    func navigateToSettings() {
        let viewModel = SettingsViewModel(coordinator: self)
        let settingsVC = SettingsViewController(viewModel: viewModel)
        navigationController.pushViewController(settingsVC, animated: true)
    }
}
