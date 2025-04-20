//
//  HomeViewModelTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import XCTest

@testable import TVSeries

class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!
    private var mockTVMazeService: MockTVMazeService!
    private var mockCoordinator: MockMainCoordinator!
    private var mockFavoritesService: MockFavoritesService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockTVMazeService = MockTVMazeService()
        mockFavoritesService = MockFavoritesService()
        mockCoordinator = MockMainCoordinator()
        sut = HomeViewModel(
            coordinator: mockCoordinator,
            tvMazeService: mockTVMazeService,
            favoritesService: mockFavoritesService
        )
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockTVMazeService = nil
        mockFavoritesService = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Initial State Tests
    func testInitialState() {
        XCTAssertTrue(sut.shows.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertFalse(sut.isSearching)
        XCTAssertNil(sut.error)
        XCTAssertTrue(sut.hasMorePages)
    }

    // MARK: - Load Shows Tests
    func testLoadShowsSuccess() {
        // Given
        let expectedShows = [TVShow.loadingPlaceholderData()]
        mockTVMazeService.fetchShowsResult = .success(expectedShows)

        // When
        sut.viewDidLoad()

        // Then
        XCTAssertNil(sut.error)
        XCTAssertEqual(mockTVMazeService.fetchShowsCallCount, 1)
        XCTAssertEqual(mockTVMazeService.lastFetchShowsPage, 0)
    }

    // MARK: - Favorites Tests
    func testToggleFavorite() {
        // Given
        let showId = 1

        // When
        sut.toggleFavorite(showId: showId)

        // Then
        XCTAssertEqual(mockFavoritesService.toggleFavoriteCallCount, 1)
    }

    func testIsFavorite() {
        // Given
        let showId = 1
        mockFavoritesService.setFavorites([showId])

        // When
        let isFavorite = sut.isFavorite(showId: showId)

        // Then
        XCTAssertTrue(isFavorite)
        XCTAssertEqual(mockFavoritesService.isFavoriteCallCount, 1)
    }

    // MARK: - Navigation Tests
    func testOpenSettings() {
        // When
        sut.openSettings()

        // Then
        XCTAssertEqual(mockCoordinator.navigateToSettingsCallCount, 1)
    }

    func testDidSelectShow() {
        // Given
        let show = TVShow.loadingPlaceholderData()

        // When
        sut.didSelectShow(show)

        // Then
        XCTAssertEqual(mockCoordinator.navigateToDetailCallCount, 1)
        XCTAssertEqual(mockCoordinator.lastSelectedShow, show)
    }
}
