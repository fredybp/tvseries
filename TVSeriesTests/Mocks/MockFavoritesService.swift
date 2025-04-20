//
//  MockFavoritesService.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

@testable import TVSeries

class MockFavoritesService: FavoritesServiceProtocol {

    // MARK: - Properties
    var favorites = [Int]()
    let favoritesSubject = CurrentValueSubject<Set<Int>, Never>([])

    // MARK: - Test Properties
    var toggleFavoriteCallCount = 0
    var isFavoriteCallCount = 0
    var getFavoritesCallCount = 0

    func toggleFavorite(showId: Int) {
        toggleFavoriteCallCount += 1
        if let indexToRemove = favorites.firstIndex(of: showId) {
            favorites.remove(at: indexToRemove)
        } else {
            favorites.append(showId)
        }
    }

    func isFavorite(showId: Int) -> Bool {
        isFavoriteCallCount += 1
        return favorites.contains(showId)
    }

    func getFavorites() -> [Int] {
        getFavoritesCallCount += 1
        return favorites
    }

    // MARK: - Test Helpers
    func setFavorites(_ newFavorites: [Int]) {
        favorites = newFavorites
    }

    func reset() {
        favorites = []
        toggleFavoriteCallCount = 0
        isFavoriteCallCount = 0
        getFavoritesCallCount = 0
    }
}
