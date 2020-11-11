//
//  Favorites.swift
//  SkySonic
//
//  Created by Luan Luu on 11/11/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import Foundation

var favorites = [Track]()

func checkDuplicate(trackToAdd: Track?) -> Bool {
    print("check duplicate is called")
    // if the track is nil, then return true to indicate that no needs to add the track to the favorites array
    guard trackToAdd != nil else { return true }
    
    // otherwise, check if the track is an element of the favorites array or not
    return favorites.contains{$0.artistName == trackToAdd!.artistName && $0.trackName == trackToAdd!.trackName}
}
