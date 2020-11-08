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

struct Result: Codable {
    let resultCount: Int
    let results: [Track]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}
