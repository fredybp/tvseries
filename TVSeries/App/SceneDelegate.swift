//
//  SceneDelegate.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }

        coordinator = MainCoordinator(
            window: window,
            pinService: PINService(keychain: Keychain.standard)
        )
        coordinator?.start()
    }
}
