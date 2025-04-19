//
//  MockNavigationController.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import UIKit

@testable import TVSeries

class MockNavigationController: UINavigationController {
    // Call counts
    private(set) var pushViewControllerCallCount = 0
    private(set) var presentCallCount = 0

    // Parameters
    private(set) var pushedViewControllers: [UIViewController] = []
    private(set) var presentedViewControllers: [UIViewController] = []
    private(set) var lastPushAnimated: Bool?
    private(set) var lastPresentAnimated: Bool?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCallCount += 1
        pushedViewControllers.append(viewController)
        lastPushAnimated = animated
        super.pushViewController(viewController, animated: animated)
    }

    override func present(
        _ viewControllerToPresent: UIViewController, animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        presentCallCount += 1
        presentedViewControllers.append(viewControllerToPresent)
        lastPresentAnimated = flag
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
