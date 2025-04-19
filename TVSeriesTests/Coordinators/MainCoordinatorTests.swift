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

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        coordinator = MainCoordinator(navigationController: mockNavigationController)
    }

    override func tearDown() {
        coordinator = nil
        mockNavigationController = nil
        super.tearDown()
    }

    func testStart() {
        // When
        coordinator.start()

        // Then
        XCTAssertEqual(mockNavigationController.pushViewControllerCallCount, 1)
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers.first is HomeViewController)
        XCTAssertEqual(mockNavigationController.lastPushAnimated, false)
    }

    func testNavigateToShowDetail() {
        // Given
        let show = TVShow.mock()

        // When
        coordinator.navigateToDetail(with: show)

        // Then
        XCTAssertEqual(mockNavigationController.pushViewControllerCallCount, 1)
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers.first is DetailViewController)
        XCTAssertEqual(mockNavigationController.lastPushAnimated, true)
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
