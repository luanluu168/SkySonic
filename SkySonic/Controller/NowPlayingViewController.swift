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
        self.artistImage.makeRounded(10.0)
        
        if let track = player.tracks?[player.currentIndex] {
            configurePlayer()
            songName.text = track.trackName
            player.currentTrack = track
            displayImage()
        }
    }
    
    func configurePlayer() {
        // if the player's array has the track, put the playerItem in the player's queue
        // as well as add observer to each song
        if let currentTrack = player.tracks?[player.currentIndex] {
            let previewURL = URL(string: currentTrack.previewUrl)!
            
            print("Caling play, url= \(previewURL)")
            for index in player.currentIndex...player.tracks!.count-1 {
                let playerItem = AVPlayerItem.init(url: URL(string: player.tracks![index].previewUrl)!)
                player.insert(playerItem, after: nil)
                
                // notify when a song is end so that we can increase the array's index
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlayingSong), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            }
            print("__ player's play is called")
            player.play()
            playPauseButton.setImage(UIImage(named: PAUSE_ICON_64), for: UIControl.State.normal)
            
        }
        
    }
    
    @objc func playerDidFinishPlayingSong(note: NSNotification) {
        // print("______ in the now playing finish one song, items.count: \(player.items().count)")
        player.currentIndex = (player.currentIndex + 1) % player.tracks!.count
        
        // update artist image
        displayImage()
        
        // detach observer
        if let token = player.timeObserverToken {
            player.removeTimeObserver(token)
            player.timeObserverToken = nil
        }
        
    }
    
    func displayImage() {
        print("Calling displayImage")
        
        // the case where the player's array do not have the data at the currentIndex
        guard player.tracks?[player.currentIndex] != nil else { return }
        
        // otherwise, get the current song's image and display it
        let imageURL = URL(string: player.tracks![player.currentIndex].artworkUrl)!
        
        let displayImageTask = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            // if error, display the error
            if let error = error {
                print("Error in displayImageTask: \(error)")
                return
            }
            
            // otherwise, use the main thread to display the image, change the image's view mode, and update the songName
            if let data = data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.artistImage.contentMode = UIView.ContentMode.scaleAspectFill
                    self.artistImage.image = image
                    self.songName.text = player.tracks![player.currentIndex].trackName
                }
            }
        }
        displayImageTask.resume()
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
