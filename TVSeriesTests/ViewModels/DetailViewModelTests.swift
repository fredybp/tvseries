//
//  DetailViewModelTests.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import Combine
import XCTest

@testable import TVSeries

class DetailViewModelTests: XCTestCase {
    private var viewModel: DetailViewModel!
    private var mockService: MockTVMazeService!
    private var mockCoordinator: MockMainCoordinator!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockTVMazeService()
        mockCoordinator = MockMainCoordinator()
        let mockShow = TVShow.mock()
        viewModel = DetailViewModel(
            coordinator: mockCoordinator,
            show: mockShow,
            tvMazeService: mockService
        )
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(mockService.fetchEpisodesCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToEpisodeDetailCallCount, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.episodes.isEmpty)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.show, TVShow.mock())
    }

    func testLoadEpisodesSuccess() {
        // Given
        XCTAssertEqual(mockService.fetchEpisodesCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToEpisodeDetailCallCount, 0)
        let expectedEpisodes = [Episode.mock(), Episode.mock()]
        mockService.fetchEpisodesResult = .success(expectedEpisodes)

        let expectation = XCTestExpectation(description: "Episodes loaded")

        // When
        viewModel.$episodes
            .dropFirst()
            .sink { episodes in
                XCTAssertEqual(episodes, expectedEpisodes)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.viewDidLoad()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(mockService.fetchEpisodesCallCount, 1)
        XCTAssertEqual(mockService.lastFetchEpisodesShowId, viewModel.show.id)
    }

    func testLoadEpisodesFailure() {
        // Given
        XCTAssertEqual(mockService.fetchEpisodesCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToEpisodeDetailCallCount, 0)
        let expectedError = TVMazeError.networkError(NSError(domain: "", code: 0))
        mockService.fetchEpisodesResult = .failure(expectedError)

        let expectation = XCTestExpectation(description: "Error received")

        // When
        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, expectedError)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.viewDidLoad()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.episodes.isEmpty)
        XCTAssertEqual(mockService.fetchEpisodesCallCount, 1)
    }

    func testComputedProperties() {
        // Given
        XCTAssertEqual(mockService.fetchEpisodesCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToEpisodeDetailCallCount, 0)
        let show = TVShow.mock()
        viewModel = DetailViewModel(
            coordinator: mockCoordinator, show: show, tvMazeService: mockService)

        // Then
        XCTAssertEqual(viewModel.ratingText, "8.5")
        XCTAssertEqual(viewModel.genresText, "Drama")
        XCTAssertEqual(viewModel.summaryText, "Test summary")
        XCTAssertNil(viewModel.imageURL)
    }
}
