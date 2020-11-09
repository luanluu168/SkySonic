//
//  NowPlayingViewController.swift
//  SkySonic
//
//  Created by Luan Luu on 11/8/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import AVFoundation
import UIKit

class NowPlayingViewController: UIViewController {

    var curTrack: Track?
    
    // top area
    @IBOutlet weak var artistImage: UIImageView!
    
    // middle area
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var drivingModeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // bottom area
    @IBOutlet weak var songSlider: UISlider!
    @IBOutlet weak var songCurrentTimeLabel: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("in the now playing view, calling view did load")
        print("___________________ check player.currentIndex = \(player.currentIndex)")
        // hide volume slider, driving mode button and favorite button
        self.volumeSlider.isHidden = true
        self.drivingModeButton.isHidden = true
        self.favoriteButton.isHidden = true
        // change the thumbImage of the song slider to a smaller circle image
        self.songSlider.setThumbImage(UIImage(named: RED_ICON_16), for: .normal)
        // make the artist image rounded corner
        self.artistImage.makeRounded(10)
        
        if let track = player.tracks?[player.currentIndex] {
            songName.text = track.trackName
            configurePlayer()
        }
    }
    
    func configurePlayer() {
        if let currentTrack = player.tracks?[player.currentIndex] {
            let previewURL = URL(string: currentTrack.previewUrl)!
            
            print("Caling play, url= \(previewURL)")
            for index in player.currentIndex...player.tracks!.count-1 {
                let playerItem = AVPlayerItem.init(url: URL(string: player.tracks![index].previewUrl)!)
                player.insert(playerItem, after: nil)
                
            }
            print("__ player's play is called")
            player.play()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
