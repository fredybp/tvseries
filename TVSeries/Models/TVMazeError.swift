//
//  TVMazeError.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation

enum TVMazeError: Error, Equatable {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case noMorePages
    case emptySearchQuery

    static func == (lhs: TVMazeError, rhs: TVMazeError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.invalidResponse, .invalidResponse):
            return true
        case (.emptySearchQuery, .emptySearchQuery):
            return true
        case (.noMorePages, .noMorePages):
            return true
        default:
            return false
        }
    }
}
