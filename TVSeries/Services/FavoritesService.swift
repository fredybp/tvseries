//
//  FavoritesService.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

protocol FavoritesServiceProtocol {
    var favorites: [Int] { get }
    func toggleFavorite(showId: Int)
    func isFavorite(showId: Int) -> Bool
}

class FavoritesService: FavoritesServiceProtocol {
    static let shared = FavoritesService()
    private let userDefaults: UserDefaultsProtocol
    private let favoritesKey = "com.tvseries.favorites"

    var favorites: [Int] {
        userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
    }

    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func toggleFavorite(showId: Int) {
        var currentFavorites = favorites
        let isFavorite = currentFavorites.contains(showId)

        if isFavorite {
            currentFavorites.removeAll { $0 == showId }
        } else {
            currentFavorites.append(showId)
        }

        userDefaults.set(currentFavorites, forKey: favoritesKey)
    }

    func isFavorite(showId: Int) -> Bool {
        favorites.contains(showId)
    }
}
