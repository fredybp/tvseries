//
//  MockTVMazeService.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

@testable import TVSeries

class MockTVMazeService: TVMazeServiceProtocol {
    var fetchShowsResult: Result<[TVShow], TVMazeError> = .success([])
    var searchShowsResult: Result<[TVShow], TVMazeError> = .success([])
    var fetchEpisodesResult: Result<[Episode], TVMazeError> = .success([])

    var fetchShowsCallCount = 0
    var searchShowsCallCount = 0
    var fetchEpisodesCallCount = 0
    var lastFetchShowsPage: Int?
    var lastSearchShowsQuery: String?
    var lastFetchEpisodesShowId: Int?

    func fetchShows(page: Int) -> AnyPublisher<[TVShow], TVMazeError> {
        fetchShowsCallCount += 1
        lastFetchShowsPage = page
        return fetchShowsResult.publisher.eraseToAnyPublisher()
    }

    func searchShows(query: String) -> AnyPublisher<[TVShow], TVMazeError> {
        searchShowsCallCount += 1
        lastSearchShowsQuery = query
        return searchShowsResult.publisher.eraseToAnyPublisher()
    }

    func fetchEpisodes(for showId: Int) -> AnyPublisher<[Episode], TVMazeError> {
        fetchEpisodesCallCount += 1
        lastFetchEpisodesShowId = showId
        return fetchEpisodesResult.publisher.eraseToAnyPublisher()
    }
}
