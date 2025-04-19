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
