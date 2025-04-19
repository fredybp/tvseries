//
//  Episode+Mock.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

@testable import TVSeries

extension Episode {
    static func mock() -> Episode {
        return Episode(
            id: 1,
            name: "Test Episode",
            season: 1,
            number: 1,
            summary: "Test episode summary",
            airdate: nil,
            runtime: 10,
            image: nil
        )
    }
}
