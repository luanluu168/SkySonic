//
//  itunes.swift
//  SkySonic
//
//  Created by Luan Luu on 11/7/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import UIKit

struct Track: Codable {
    let artistName: String
    let trackName: String
    let artworkUrl: String
    let previewUrl: String
    let collectionName: String?
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case trackName = "trackName"
        case artworkUrl = "artworkUrl100"
        case previewUrl = "previewUrl"
        case collectionName = "collectionName"
        case price = "trackPrice"
    }
}

// JsonDecoder
struct Result: Codable {
    let resultCount: Int
    let results: [Track]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}

// iTune base URL
let itunesBaseURL = URL(string: "https://itunes.apple.com/search")!

// make an extension to create a URL with some queries as a parameter
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map{ URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

func createURL(artistName: String) -> URL? {
    let itunesQuery: [String: String] = [
        "term": artistName,
        "media": "music",
        "lang": "en_us",
        "limit": "12"
    ]
    return itunesBaseURL.withQueries(itunesQuery)
}
