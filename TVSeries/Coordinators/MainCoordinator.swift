//
//  MainCoordinator.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    private let window: WindowProtocol
    private let pinService: PINServiceProtocol
    private var currentViewController: UIViewController?

    init(window: WindowProtocol, pinService: PINServiceProtocol = PINService()) {
        self.window = window
        self.pinService = pinService
        super.init()
    }

    func start() {
        if pinService.isPINSet {
            showPINVerification()
        } else {
            showHome()
        }
    }

    private func showPINVerification() {
        let viewModel = PINViewModel(coordinator: self, mode: .verify, pinService: pinService)
        let viewController = PINViewController(viewModel: viewModel)
        currentViewController = viewController
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    private func showHome() {
        let homeViewModel = HomeViewModel(coordinator: self, tvMazeService: TVMazeService())
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        currentViewController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func pinVerified() {
        showHome()
    }

    func navigateToDetail(with show: TVShow) {
        guard let navigationController = currentViewController as? UINavigationController else {
            return
        }
        let viewModel = DetailViewModel(
            coordinator: self, show: show, tvMazeService: TVMazeService())
        let viewController = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func navigateToEpisodeDetail(episode: Episode) {
        guard let navigationController = currentViewController as? UINavigationController else {
            return
        }
        let viewController = EpisodeDetailViewController(episode: episode)
        navigationController.pushViewController(viewController, animated: true)
    }

    func navigateToSettings() {
        guard let navigationController = currentViewController as? UINavigationController else {
            return
        }
        let viewModel = SettingsViewModel(coordinator: self, pinService: pinService)
        let viewController = SettingsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func navigateToPINSetup() {
        guard let navigationController = currentViewController as? UINavigationController else {
            return
        }
        let viewModel = PINViewModel(coordinator: self, mode: .setup, pinService: pinService)
        let viewController = PINViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
