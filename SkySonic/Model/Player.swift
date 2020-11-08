//
//  Player.swift
//  SkySonic
//
//  Created by Luan Luu on 11/8/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import AVFoundation
import UIKit

class Player: AVQueuePlayer {
    var currentIndex: Int = 0
    var player: AVQueuePlayer!
    var tracks: [Track]?
    var currentTrack: Track?
    var receivedSongName: String?
    
    override init() {
        super.init()
    }
}

var player = Player()
