//
//  Episode.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation

struct Episode: Identifiable, Codable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let summary: String?
    let airdate: String?
    let runtime: Int?
    let image: ShowImage?
}

extension Episode: Equatable {
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.season == rhs.season
            && lhs.number == rhs.number && lhs.summary == rhs.summary && lhs.image == rhs.image
    }
}
