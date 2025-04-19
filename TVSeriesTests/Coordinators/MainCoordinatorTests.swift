//
//  MainCoordinatorTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import XCTest

@testable import TVSeries

class MainCoordinatorTests: XCTestCase {
    private var coordinator: MainCoordinator!
    private var mockNavigationController: MockNavigationController!
    private var mockWindow: WindowMock!
    private var mockPinService: MockPINService!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        mockWindow = WindowMock(rootViewController: mockNavigationController)
        mockPinService = MockPINService()
        coordinator = MainCoordinator(
            window: mockWindow,
            pinService: mockPinService
        )
    }

    override func tearDown() {
        coordinator = nil
        mockNavigationController = nil
        mockWindow = nil
        mockPinService = nil
        super.tearDown()
    }

    func testStartNoPinSet() {
        // When
        mockPinService.isPINSet = false
        coordinator.start()

        // Then
        XCTAssert(
            mockWindow.rootViewController is UINavigationController)
        XCTAssert((mockWindow.rootViewController as? UINavigationController)?.topViewController is HomeViewController)
        XCTAssertEqual(
            mockWindow.makeKeyAndVisibleCallCount,
            1
        )
    }
    
    func testStartPinSet() {
        // When
        mockPinService.isPINSet = true
        coordinator.start()

        // Then
        XCTAssert(
            mockWindow.rootViewController is PINViewController)
        XCTAssertEqual(
            mockWindow.makeKeyAndVisibleCallCount,
            1
        )
    }

    func testNavigateToShowDetail() {
        // Given
        let show = TVShow.mock()
        mockPinService.isPINSet = false

        // When
        coordinator.start()
        coordinator.navigateToDetail(with: show)

        // Then
//        XCTAssertEqual(mockNavigationController.pushViewControllerCallCount, 1)
//        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssert(
            (
                mockWindow.rootViewController as? UINavigationController
            )?.topViewController is DetailViewController
        )
//        XCTAssertEqual(mockNavigationController.lastPushAnimated, true)
    }

    func testNavigateToEpisodeDetail() {
        // Given
        let episode = Episode.mock()

        // When
        coordinator.navigateToEpisodeDetail(episode: episode)

        // Then
        XCTAssertEqual(mockNavigationController.pushViewControllerCallCount, 1)
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(
            mockNavigationController.pushedViewControllers.first is EpisodeDetailViewController)
        XCTAssertEqual(mockNavigationController.lastPushAnimated, true)
    }

    func testNavigateToSettings() {
        // When
        coordinator.navigateToSettings()

        // Then
        XCTAssertEqual(mockNavigationController.pushViewControllerCallCount, 1)
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(
            mockNavigationController.pushedViewControllers.first is SettingsViewController)
        XCTAssertEqual(mockNavigationController.lastPushAnimated, true)
    }
}
