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
    var songDurationTimer: Time! = Time(hours: 0, minutes: 0, seconds: 0)
    var songPlayingTimer: Time!   = Time(hours: 0, minutes: 0, seconds: 0)
    var isSegueFromFavorite: Bool = false
    
    // top area
    @IBOutlet weak var artistImage: UIImageView!
    // end top area
    
    // middle area
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var drivingModeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func handleMoreFeaturesButtonIsPressed(_ sender: UIButton) {
        self.drivingModeButton.isHidden = !self.drivingModeButton.isHidden
        self.favoriteButton.isHidden        = !self.favoriteButton.isHidden
    }
    @IBAction func handleAdjustVolumeButtonIsPressed(_ sender: UIButton) {
        self.volumeSlider.isHidden = !self.volumeSlider.isHidden
    }
    @IBAction func handleVolumeSliderChange(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    @IBAction func handleAddToFavoriteButtonIsPressed(_ sender: UIButton) {
        if let track = player.tracks?[player.currentIndex] {
            player.currentTrack = track
            let isDuplicated = checkDuplicate(trackToAdd: track)
            if (!isDuplicated) { // if the current track is not duplicated
                favorites.append(track)
            }
        }
    }
    // end middle area
    
    // bottom area
    @IBOutlet weak var songSlider: UISlider!
    @IBOutlet weak var songCurrentTimeLabel: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBAction func handlePlayPauseButtonIsPressed(_ sender: UIButton) {
        // if the player is playing, then pause the player and set the button image to the pause icon
        if ( player.isPlaying() ) {
            player.pause()
            playPauseButton.setImage(UIImage(named: PLAY_ICON_64), for: UIControl.State.normal)
            return
        }
        
        // otherwise, play the player and set the button image to the play icon
        player.play()
        playPauseButton.setImage(UIImage(named: PAUSE_ICON_64), for: UIControl.State.normal)
    }
    @IBAction func handleBackwardButtonIsPressed(_ sender: UIButton) {
        if (player.currentIndex > 0) {
            player.currentIndex -= 1
            displayImage()
            player.removeAllItems()
            configurePlayer()
        }
    }
    @IBAction func handleForwardButtonIsPressed(_ sender: UIButton) {
        // if the currentIndex is smaller than the array's last index
        if (player.currentIndex < (player.tracks!.count - 1) ) {
            player.currentIndex += 1
            displayImage()
            player.advanceToNextItem()
        }
    }
    // end bottom area
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print("in the now playing view, calling view did load \(player.tracks!.count)")
        // print("___________________ check player.currentIndex = \(player.currentIndex)")
        // hide volume slider, driving mode button and favorite button
        self.volumeSlider.isHidden = true
        self.drivingModeButton.isHidden = true
        self.favoriteButton.isHidden = true
        // change the thumbImage of the song slider to a smaller circle image
        self.songSlider.setThumbImage(UIImage(named: RED_ICON_16), for: .normal)
        // change the thumbImage of the volume slider to a smaller circle image
        self.volumeSlider.setThumbImage(UIImage(named: BLUE_ICON_16), for: .normal)
        // make the artist image rounded corner
        self.artistImage.makeRounded(10.0)
        // turn the volume slider to vertical
        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2) )
        
        if isSegueFromFavorite {
            player.removeAllItems()
            player.currentIndex = 0
            player.tracks = [ ]
            player.tracks!.append(self.curTrack!)
        }
        
        // if the element at currentIndex of the player's array contains data
        if let track = player.tracks?[player.currentIndex] {
            configurePlayer()
            songName.text = track.trackName
            player.currentTrack = track
            displayImage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // print("$$$$$$$$$$$$$$$$$$$$$$$$ NowPlaying view will appear is called")
        
        guard let tracks = player.tracks else { return }
        if tracks.count > 0 {
            player.play()
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
            
            // synchonize the song slider with the player's current song
            let interval = CMTime(value: 1, timescale: 2)
            player.timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: {
                [weak self] (progressTime) in
                
                let totalSeconds: Float64 = CMTimeGetSeconds(progressTime)
                // update the song's playing time and its label
                self?.songPlayingTimer!.updateTime(inputSeconds: totalSeconds)
                self?.songCurrentTimeLabel.text = "\(self?.songPlayingTimer!.getMinutesInStringFormat() ?? "--"):\(self?.songPlayingTimer!.getSecondsInStringFormat() ?? "--")"
                
                // move the playhead
                if let currentSongDuration = player.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(currentSongDuration)
                    self?.songSlider.value = Float(totalSeconds / durationSeconds)
                }
                
                // to only update and display the songDurationLabel's text once
                if self?.songDurationLabel.text == "00:00" {
                    print("songDurationLabel is updated")
                    self?.displayDuration()
                }
            })
            print("__ player's play is called")
            player.play()
            self.updateSongSlider()
            playPauseButton.setImage(UIImage(named: PAUSE_ICON_64), for: UIControl.State.normal)
            
        }
        
    }
    
    func displayDuration() {
        let duration = player.currentItem?.duration.seconds ?? 0
        let playDuration = self.formatDurationTime(totalseconds: duration)
        self.songDurationLabel.text = playDuration
    }
    
    func formatDurationTime(totalseconds: Double) -> String {
        // if the totalseconds is not a number, return 00:00 as a default string
        if totalseconds.isNaN { return "00:00" }
        
        // otherwise, return the song's duration
        self.songDurationTimer!.updateTime(inputSeconds: totalseconds)
        return "\(self.songDurationTimer!.getMinutesInStringFormat()):\(self.songDurationTimer!.getSecondsInStringFormat())"
    }
    
    @objc func playerDidFinishPlayingSong(note: NSNotification) {
        // print("______ in the now playing finish one song, items.count: \(player.items().count)")
        player.currentIndex = (player.currentIndex + 1) % player.tracks!.count
        
        // update artist image and new song's duration
        displayImage()
        displayDuration()
        
        if player.tracks!.count == 1 {
            // detach all songs' observer
            if let token = player.timeObserverToken {
                player.removeTimeObserver(token)
                player.timeObserverToken = nil
            }
            configurePlayer()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DrivingModeViewController
        // print("________________________________________ nowplaying prepare is called, player.currentIndex = \(player.currentIndex)")
        
        if destination.player == nil {
            destination.player = Player()
            destination.player.currentIndex = player.currentIndex
            destination.player.tracks = player.tracks
        } else {
            destination.player.currentIndex = player.currentIndex
            destination.player.tracks = player.tracks
        }
    }
    
    func updateSongSlider() {
        songSlider.addTarget(self, action: #selector(handleSongSliderChange), for: .valueChanged)
    }
    
    @objc func handleSongSliderChange() {
        // print("Song slider value: \(songSlider.value)")
        if let duration = player.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let currentValue = Float64(songSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(currentValue), timescale: 1)
            player.seek(to: seekTime, completionHandler: {
                (completionHandler) in /* do nothing */ })
        }
    }
    
    func displayImage() {
        // print("Calling displayImage")
        
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

}
