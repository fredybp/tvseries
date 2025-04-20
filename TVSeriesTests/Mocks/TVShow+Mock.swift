//
//  TVShow+Mock.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

@testable import TVSeries

extension TVShow {
    static func mock(id: Int = 1) -> TVShow {
        return TVShow(
            id: id,
            name: "Test Show",
            summary: "Test summary",
            image: nil,
            premiered: "2024-01-01",
            rating: Rating(average: 8.5),
            genres: ["Drama"],
            status: "Running",
            schedule: Schedule(time: "20:00", days: ["Monday"]),
            network: Network(id: 1, name: "Test Network", country: nil)
        )
    }
}
