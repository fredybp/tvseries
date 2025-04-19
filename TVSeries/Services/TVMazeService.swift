//
//  TVMazeService.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

enum TVMazeError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case noMorePages
    case emptySearchQuery
}

class TVMazeService {
    private let baseURL = "https://api.tvmaze.com"
    private let pageSize = 250  // TVMaze's default page size

    func fetchShows(page: Int = 0) -> AnyPublisher<[TVShow], TVMazeError> {
        let endpoint = "/shows"
        let urlString = "\(baseURL)\(endpoint)?page=\(page)"

        guard let url = URL(string: urlString) else {
            return Fail(error: TVMazeError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { TVMazeError.networkError($0) }
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw TVMazeError.invalidResponse
                }

                // Check if we've reached the end of available pages
                if httpResponse.statusCode == 404 {
                    throw TVMazeError.noMorePages
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    throw TVMazeError.invalidResponse
                }

                return data
            }
            .decode(type: [TVShow].self, decoder: JSONDecoder())
            .mapError { TVMazeError.decodingError($0) }
            .eraseToAnyPublisher()
    }

    func searchShows(query: String) -> AnyPublisher<[TVShow], TVMazeError> {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return Fail(error: TVMazeError.emptySearchQuery).eraseToAnyPublisher()
        }

        let endpoint = "/search/shows"
        let encodedQuery =
            query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)\(endpoint)?q=\(encodedQuery)"

        guard let url = URL(string: urlString) else {
            return Fail(error: TVMazeError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { TVMazeError.networkError($0) }
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode)
                else {
                    throw TVMazeError.invalidResponse
                }
                return data
            }
            .decode(type: [SearchResult].self, decoder: JSONDecoder())
            .map { $0.map { $0.show } }
            .mapError { TVMazeError.decodingError($0) }
            .eraseToAnyPublisher()
    }
}

struct SearchResult: Codable {
    let show: TVShow
    let score: Double
}
