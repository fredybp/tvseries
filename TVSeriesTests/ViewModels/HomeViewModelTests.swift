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
    private var viewModel: HomeViewModel!
    private var mockService: MockTVMazeService!
    private var mockCoordinator: MockMainCoordinator!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockTVMazeService()
        mockCoordinator = MockMainCoordinator()
        viewModel = HomeViewModel(coordinator: mockCoordinator, tvMazeService: mockService)
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
        XCTAssertEqual(mockService.fetchShowsCallCount, 0)
        XCTAssertEqual(mockService.searchShowsCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToDetailCallCount, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadingMore)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertTrue(viewModel.shows.isEmpty)
        XCTAssertNil(viewModel.error)
    }

    func testLoadShowsSuccess() {
        // Given
        XCTAssertEqual(mockService.fetchShowsCallCount, 0)
        XCTAssertEqual(mockService.searchShowsCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToDetailCallCount, 0)
        let expectedShows = [TVShow.mock(), TVShow.mock()]
        mockService.fetchShowsResult = .success(expectedShows)

        let expectation = XCTestExpectation(description: "Shows loaded")

        // When
        viewModel.$shows
            .dropFirst()
            .sink { shows in
                XCTAssertEqual(shows, expectedShows)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.viewDidLoad()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(mockService.fetchShowsCallCount, 1)
        XCTAssertEqual(mockService.lastFetchShowsPage, 0)
    }

    func testLoadShowsFailure() {
        // Given
        XCTAssertEqual(mockService.fetchShowsCallCount, 0)
        XCTAssertEqual(mockService.searchShowsCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToDetailCallCount, 0)
        let expectedError = TVMazeError.networkError(NSError(domain: "", code: 0))
        mockService.fetchShowsResult = .failure(expectedError)

        let expectation = XCTestExpectation(description: "Error received")

        // When
        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, expectedError)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.searchQuery = ""
        viewModel.viewDidLoad()

        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.shows.isEmpty)
        XCTAssertEqual(mockService.fetchShowsCallCount, 1)
        XCTAssertEqual(mockService.searchShowsCallCount, 0)
    }

    func testSearchShowsSuccess() {
        // Given
        XCTAssertEqual(mockService.fetchShowsCallCount, 0)
        XCTAssertEqual(mockService.searchShowsCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToDetailCallCount, 0)
        let expectedShows = [TVShow.mock(), TVShow.mock()]
        mockService.searchShowsResult = .success(expectedShows)
        let searchQuery = "test"

        let expectation = XCTestExpectation(description: "Search results loaded")

        // When
        viewModel.$shows
            .dropFirst()
            .sink { shows in
                XCTAssertEqual(shows, expectedShows)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.searchQuery = searchQuery

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(mockService.searchShowsCallCount, 1)
        XCTAssertEqual(mockService.lastSearchShowsQuery, searchQuery)
    }

    func testLoadMoreShows() {
        // Given
        XCTAssertEqual(mockService.fetchShowsCallCount, 0)
        XCTAssertEqual(mockService.searchShowsCallCount, 0)
        XCTAssertEqual(mockCoordinator.navigateToDetailCallCount, 0)
        let initialShows = Array(repeating: TVShow.mock(), count: 250)
        let moreShows = Array(repeating: TVShow.mock(), count: 250)
        mockService.fetchShowsResult = .success(initialShows)

        let expectation = XCTestExpectation(description: "More shows loaded")

        // When
        viewModel.viewDidLoad()

        mockService.fetchShowsResult = .success(moreShows)

        viewModel.$shows
            .dropFirst(2)
            .sink { shows in
                XCTAssertEqual(shows, initialShows + moreShows)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadMoreShows()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoadingMore)
        XCTAssertEqual(mockService.fetchShowsCallCount, 2)
        XCTAssertEqual(mockService.lastFetchShowsPage, 1)
    }
}
