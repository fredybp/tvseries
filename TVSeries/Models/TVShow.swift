//
//  TVShow.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation

struct TVShow: Identifiable, Codable {
    let id: Int
    let name: String
    let summary: String?
    let image: ShowImage?
    let premiered: String?
    let rating: Rating?
    let genres: [String]
    let status: String?
    let schedule: Schedule?
    let network: Network?

    var formattedPremiered: String? {
        guard let premiered = premiered else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: premiered) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }

    var displayRating: String {
        guard let rating = rating?.average else { return "N/A" }
        return String(format: "%.1f", rating)
    }

    var scheduleText: String {
        let days = schedule?.days.joined(separator: ", ") ?? "N/A"
        let time = schedule?.time ?? "N/A"
        return "\(days) at \(time)"
    }
}

struct Rating: Codable {
    let average: Double?
}

struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct Network: Codable {
    let name: String
    let country: Country?
}

struct Country: Codable {
    let name: String
    let code: String
    let timezone: String
}
