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

        // change table background color
        self.tableView.backgroundColor = UIColor.systemGray
        
        // change the navigation bar's image
//        self.changeNavigationBarBackButtonImage()
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
        
        return cell
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
