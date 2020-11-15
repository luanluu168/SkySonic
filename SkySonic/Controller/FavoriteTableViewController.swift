//
//  FavoriteTableViewController.swift
//  SkySonic
//
//  Created by Luan Luu on 11/11/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    var currentFavoriteIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // display an Edit button in the navigation bar for this view controller
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // change table background color
        self.tableView.backgroundColor = UIColor.systemGray
        
        // change the navigation bar's image
        self.changeNavigationBarBackButtonImage()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTrackCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        // Configure the cell...
        cell.textLabel?.text = "#\(indexPath.row + 1). \(favorites[indexPath.row].trackName)"
        cell.detailTextLabel?.text = favorites[indexPath.row].artistName
        // change the font and text color
        cell.textLabel?.font = UIFont(name: TIMES_NEW_ROMAN_FONT, size: 17)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // print("Calling favorite delete \(indexPath.row)")
        favorites.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("Calling favorite didselectRowAt: \(indexPath.row)")
        currentFavoriteIndex = indexPath.row
        performSegue(withIdentifier: "favoriteToNowPlayingSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // print("Calling prepare inside favorite")
        if let destination = segue.destination as? NowPlayingViewController {
            destination.curTrack = favorites[currentFavoriteIndex]
            destination.isSegueFromFavorite = true
        }
    }
    
    func changeNavigationBarBackButtonImage() {
        let backArrowImage = UIImage(named: NAVIGATION_BACK_ARROW_ICON)
        self.navigationController?.navigationBar.backIndicatorImage = backArrowImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrowImage
    }

}
