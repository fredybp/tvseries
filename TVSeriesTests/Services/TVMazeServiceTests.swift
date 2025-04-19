//
//  TVMazeServiceTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import XCTest

@testable import TVSeries

class TVMazeServiceTests: XCTestCase {
    private var service: TVMazeService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        service = TVMazeService()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        service = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchShowsSuccess() {
        let expectation = XCTestExpectation(description: "Fetch shows completed")

        service.fetchShows(page: 0)
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not fail")
                    }
                    expectation.fulfill()
                },
                receiveValue: { shows in
                    XCTAssertFalse(shows.isEmpty)
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testFetchShowsInvalidPage() {
        let expectation = XCTestExpectation(description: "Fetch shows failed")

        service.fetchShows(page: -1)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, TVMazeError.invalidURL)
                    } else {
                        XCTFail("Should fail with invalidURL")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testSearchShowsSuccess() {
        let expectation = XCTestExpectation(description: "Search shows completed")

        service.searchShows(query: "game")
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not fail")
                    }
                    expectation.fulfill()
                },
                receiveValue: { shows in
                    XCTAssertFalse(shows.isEmpty)
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testSearchShowsEmptyQuery() {
        let expectation = XCTestExpectation(description: "Search shows failed")

        service.searchShows(query: "")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, TVMazeError.emptySearchQuery)
                    } else {
                        XCTFail("Should fail with emptySearchQuery")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testFetchEpisodesSuccess() {
        let expectation = XCTestExpectation(description: "Fetch episodes completed")

        // Using a known show ID (e.g., Game of Thrones)
        service.fetchEpisodes(for: 82)
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Should not fail")
                    }
                    expectation.fulfill()
                },
                receiveValue: { episodes in
                    XCTAssertFalse(episodes.isEmpty)
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testFetchEpisodesInvalidShowId() {
        let expectation = XCTestExpectation(description: "Fetch episodes failed")

        service.fetchEpisodes(for: -1)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(
                            error,
                            TVMazeError
                                .decodingError(TVMazeError.invalidResponse)
                        )
                    } else {
                        XCTFail("Should fail with invalidURL")
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
}
