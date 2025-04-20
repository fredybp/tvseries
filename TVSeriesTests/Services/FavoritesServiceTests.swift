//
//  FavoritesServiceTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import XCTest

@testable import TVSeries

class FavoritesServiceTests: XCTestCase {
    private var favoritesService: FavoritesService!
    private var userDefaultsMock: UserDefaultsMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        userDefaultsMock = UserDefaultsMock()
        favoritesService = FavoritesService(userDefaults: userDefaultsMock)
        cancellables = []
    }

    override func tearDown() {
        favoritesService = nil
        userDefaultsMock = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        // Then
        XCTAssertEqual(userDefaultsMock.arrayCallCount, 0)
        XCTAssertEqual(favoritesService.favorites, [])
    }

    func testToggleFavorite_AddsShow() {
        // Given
        let showId = 123

        // When
        favoritesService.toggleFavorite(showId: showId)

        // Then
        XCTAssertTrue(favoritesService.isFavorite(showId: showId))
        XCTAssertEqual(self.userDefaultsMock.setCallCount, 1)
        XCTAssertEqual(self.userDefaultsMock.lastSetKey, "com.tvseries.favorites")
        XCTAssertEqual(self.userDefaultsMock.lastSetValue as? [Int], [showId])
        XCTAssertTrue(self.favoritesService.isFavorite(showId: showId))
    }

    func testToggleFavorite_RemovesShow() {
        // Given
        let showId = 123
        userDefaultsMock = UserDefaultsMock(
            initialData: ["com.tvseries.favorites": [showId]]
        )
        favoritesService = FavoritesService(userDefaults: userDefaultsMock)

        // When
        favoritesService.toggleFavorite(showId: showId)
        
        // Then
        XCTAssertEqual(userDefaultsMock.setCallCount, 1)
        XCTAssertEqual(userDefaultsMock.lastSetKey, "com.tvseries.favorites")
        XCTAssertEqual(userDefaultsMock.lastSetValue as? [Int], [])
        XCTAssertFalse(favoritesService.isFavorite(showId: showId))
    }

    func testMultipleFavorites() {
        // Given
        let showIds = [123, 456, 789]

        // When
        for showId in showIds {
            favoritesService.toggleFavorite(showId: showId)
        }

        // Then
        XCTAssertEqual(userDefaultsMock.setCallCount, 3)
        XCTAssertEqual(favoritesService.favorites.sorted(), showIds)
        for showId in showIds {
            XCTAssertTrue(favoritesService.isFavorite(showId: showId))
        }
    }

    func testIsFavorite_WithNoFavorites() {
        // Given
        let showId = 123

        // When
        let isFavorite = favoritesService.isFavorite(showId: showId)

        // Then
        XCTAssertFalse(isFavorite)
        XCTAssertEqual(userDefaultsMock.arrayCallCount, 1)
    }

    func testIsFavorite_WithExistingFavorites() {
        // Given
        let showId = 123
        userDefaultsMock = UserDefaultsMock(
            initialData: ["com.tvseries.favorites": [showId]]
        )
        favoritesService = FavoritesService(userDefaults: userDefaultsMock)

        // When
        let isFavorite = favoritesService.isFavorite(showId: showId)

        // Then
        XCTAssertTrue(isFavorite)
        XCTAssertEqual(userDefaultsMock.arrayCallCount, 1)
    }
}
