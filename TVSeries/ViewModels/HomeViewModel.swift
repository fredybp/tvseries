//
//  HomeViewModel.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

class HomeViewModel: BaseViewModel {
    @Published private(set) var shows: [TVShow] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var hasMorePages = true
    @Published var error: TVMazeError?
    @Published var searchQuery = ""
    @Published var isSearching: Bool = false

    private let tvMazeService: TVMazeServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private var currentPage = 0
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    init(
        coordinator: MainCoordinator,
        tvMazeService: TVMazeServiceProtocol,
        favoritesService: FavoritesServiceProtocol
    ) {
        self.tvMazeService = tvMazeService
        self.favoritesService = favoritesService
        super.init(coordinator: coordinator)
        setupSearchBinding()
    }

    public func viewDidLoad() {
        loadShows()
    }

    private func setupSearchBinding() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearch(query: query)
            }
            .store(in: &cancellables)
    }

    private func handleSearch(query: String) {
        // Cancel any ongoing search
        searchCancellable?.cancel()

        if query.isEmpty {
            isSearching = false
            resetAndLoadShows()
        } else {
            isSearching = true
            searchShows(query: query)
        }
    }

    func resetAndLoadShows() {
        currentPage = 0
        hasMorePages = true
        shows = []
        loadShows()
    }

    func loadShows() {
        guard !isLoading, !isSearching, hasMorePages else { return }

        if currentPage == 0 {
            isLoading = true
        } else {
            isLoadingMore = true
        }
        error = nil

        tvMazeService.fetchShows(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                self?.isLoadingMore = false

                if case .failure(let error) = completion {
                    if error == .noMorePages {
                        self?.hasMorePages = false
                    } else {
                        self?.error = error
                    }
                }
            } receiveValue: { [weak self] newShows in
                guard let self = self else { return }

                if self.currentPage == 0 {
                    self.shows = newShows
                } else {
                    self.shows.append(contentsOf: newShows)
                }

                self.hasMorePages = newShows.count == 250
                self.currentPage += 1
            }
            .store(in: &cancellables)
    }

    func searchShows(query: String) {
        searchQuery = query
        isSearching = !query.isEmpty

        if query.isEmpty {
            resetAndLoadShows()
            return
        }

        isLoading = true
        error = nil
        hasMorePages = false  // Search results don't support pagination

        searchCancellable = tvMazeService.searchShows(query: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    if case TVMazeError.emptySearchQuery = error {
                        // Don't show error for empty search
                        self?.shows = []
                    } else {
                        self?.error = error
                    }
                default:
                    break
                }
            } receiveValue: { [weak self] shows in
                self?.shows = shows
            }
    }

    func loadMoreShows() {
        guard !isLoadingMore && hasMorePages && !isSearching else { return }
        loadShows()
    }

    func didSelectShow(_ show: TVShow) {
        coordinator?.navigateToDetail(with: show)
    }

    func openSettings() {
        coordinator?.navigateToSettings()
    }

    func toggleFavorite(showId: Int) {
        favoritesService.toggleFavorite(showId: showId)
    }

    func isFavorite(showId: Int) -> Bool {
        favoritesService.isFavorite(showId: showId)
    }
}
