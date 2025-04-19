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
    let image: Image?
    let premiered: String?
    let rating: Rating
    let genres: [String]
    let status: String
    let schedule: Schedule
    let network: Network?
    let webChannel: Network?

    var formattedPremieredDate: String {
        guard let premiered = premiered else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: premiered) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        return premiered
    }

    var displayNetwork: String {
        if let network = network {
            return network.name
        } else if let webChannel = webChannel {
            return webChannel.name
        }
        return "N/A"
    }

    var scheduleText: String {
        let days = schedule.days.joined(separator: ", ")
        let time = schedule.time
        return "\(days) at \(time)"
    }
}

struct Image: Codable {
    let medium: String?
    let original: String?
}

struct Rating: Codable {
    let average: Double?
}

struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct Network: Codable {
    let id: Int
    let name: String
    let country: Country?
}

struct Country: Codable {
    let name: String
    let code: String
    let timezone: String
}
