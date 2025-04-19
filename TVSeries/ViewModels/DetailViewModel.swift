//
//  DetailViewModel.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

class DetailViewModel: BaseViewModel {
    @Published var show: TVShow
    @Published var isLoading: Bool = false
    @Published var error: TVMazeError?

    private let tvMazeService: TVMazeService
    private var cancellables = Set<AnyCancellable>()

    init(coordinator: MainCoordinator, show: TVShow, tvMazeService: TVMazeService) {
        self.show = show
        self.tvMazeService = tvMazeService
        super.init(coordinator: coordinator)
    }

    var ratingText: String {
        if let average = show.rating.average {
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
}
