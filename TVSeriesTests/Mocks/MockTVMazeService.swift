//
//  MockTVMazeService.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine

@testable import TVSeries

class MockTVMazeService: TVMazeService {
    var fetchShowsResult: Result<[TVShow], TVMazeError> = .success([])
    var searchShowsResult: Result<[TVShow], TVMazeError> = .success([])
    var fetchEpisodesResult: Result<[Episode], TVMazeError> = .success([])

    private(set) var fetchShowsCallCount = 0
    private(set) var searchShowsCallCount = 0
    private(set) var fetchEpisodesCallCount = 0

    private(set) var lastFetchShowsPage: Int?
    private(set) var lastSearchShowsQuery: String?
    private(set) var lastFetchEpisodesShowId: Int?

    override func fetchShows(page: Int) -> AnyPublisher<[TVShow], TVMazeError> {
        fetchShowsCallCount += 1
        lastFetchShowsPage = page
        return fetchShowsResult.publisher.eraseToAnyPublisher()
    }

    override func searchShows(query: String) -> AnyPublisher<[TVShow], TVMazeError> {
        searchShowsCallCount += 1
        lastSearchShowsQuery = query
        return searchShowsResult.publisher.eraseToAnyPublisher()
    }

    override func fetchEpisodes(for showId: Int) -> AnyPublisher<[Episode], TVMazeError> {
        fetchEpisodesCallCount += 1
        lastFetchEpisodesShowId = showId
        return fetchEpisodesResult.publisher.eraseToAnyPublisher()
    }
}
