//
//  DrivingModeViewController.swift
//  SkySonic
//
//  Created by Luan Luu on 11/10/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import AVFoundation
import UIKit

class DrivingModeViewController: UIViewController {

    var player: Player!
    var songPlayingTimer: Time! = Time(hours: 0, minutes: 0, seconds: 0)
    var songDurationTimer: Time! = Time(hours: 0, minutes: 0, seconds: 0)
    
    // top view
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songCurrentTimeLabel: UILabel!
    
    // middle view
    @IBOutlet weak var playPauseButton: UIButton!
    
    // bottom view
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let track = self.player.tracks?[self.player.currentIndex] {
            songName.text  = track.trackName
            configurePlayer()
            self.player.currentTrack = track
            playPauseButton.setImage(UIImage(named: PAUSE_ICON_96), for: UIControl.State.normal)
        }
    }
    
    func configurePlayer() {
        guard self.player.tracks?[self.player.currentIndex] != nil else { return }
        
        // if the player's array has the track, put the playerItem in the player's queue
        // as well as add observer to each song
        if let currentTrack = self.player.tracks?[self.player.currentIndex] {
            let previewURL = URL(string: currentTrack.previewUrl)!
            
            print("Caling play, url= \(previewURL)")
            for index in self.player.currentIndex...self.player.tracks!.count-1 {
                let playerItem = AVPlayerItem.init(url: URL(string: self.player.tracks![index].previewUrl)!)
                self.player.insert(playerItem, after: nil)
                
                // notify when a song is end so that we can increase the array's index
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlayingSong), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            }
        }
        
        // display the player's current song's playing time
        displayPlayingTime()
    }
    
    func displayPlayingTime() {
        let interval = CMTime(value: 1, timescale: 2)
        self.player.timeObserverToken = self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: {
            [weak self] (progressTime) in
           let totalSeconds: Float64 = CMTimeGetSeconds(progressTime)
            // update the song's duration time
            let duration = self?.player.currentItem?.duration.seconds ?? 0
            self?.songDurationTimer!.updateTime(inputSeconds: duration)
            // update the song's playing time
            self?.songPlayingTimer!.updateTime(inputSeconds: totalSeconds)

            let currentPlayingTimeString = "\(self?.songPlayingTimer!.getMinutesInStringFormat() ?? "--"):\(self?.songPlayingTimer!.getSecondsInStringFormat() ?? "--")"
            let durationTimeString = "\(self?.songDurationTimer.getMinutesInStringFormat() ?? "--"):\(self?.songDurationTimer.getSecondsInStringFormat() ?? "--")"
            self?.songCurrentTimeLabel.text = "\(currentPlayingTimeString) / \(durationTimeString)"
        })
    }
    
    @objc func playerDidFinishPlayingSong(note: NSNotification) {
        // print("______ in the now playing finish one song, items.count: \(player.items().count)")
         self.player.currentIndex = (self.player.currentIndex + 1) % self.player.tracks!.count
            
            
            
         if (self.player.tracks!.count == 1) {
             // detach all songs' observer
             if let token = self.player.timeObserverToken {
                     self.player.removeTimeObserver(token)
                     self.player.timeObserverToken = nil
             }
         }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
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
