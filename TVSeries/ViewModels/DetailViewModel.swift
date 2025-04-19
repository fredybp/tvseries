//
//  DetailViewModel.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

class DetailViewModel: BaseViewModel {
    let show: TVShow
    @Published private(set) var episodes: [Episode] = []
    @Published private(set) var isLoading = false
    @Published var error: TVMazeError?

    private let tvMazeService: TVMazeServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(coordinator: MainCoordinator, show: TVShow, tvMazeService: TVMazeServiceProtocol) {
        self.show = show
        self.tvMazeService = tvMazeService
        super.init(coordinator: coordinator)
    }

    public func viewDidLoad() {
        loadEpisodes()
    }

    var ratingText: String {
        if let average = show.rating?.average {
            return String(format: "%.1f", average)
        }
        return "N/A"
    }

    var genresText: String {
        show.genres.joined(separator: ", ")
    }

    var summaryText: String {
        show.summary?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            ?? "No summary available"
    }

    var imageURL: URL? {
        if let imageURL = show.image?.original {
            return URL(string: imageURL)
        }
        return nil
    }

    private func loadEpisodes() {
        isLoading = true
        tvMazeService.fetchEpisodes(for: show.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (completion: Subscribers.Completion<TVMazeError>) in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] episodes in
                self?.episodes = episodes
            }
            .store(in: &cancellables)
    }

    func didSelectEpisode(_ episode: Episode) {
        coordinator?.navigateToEpisodeDetail(episode: episode)
    }
}
