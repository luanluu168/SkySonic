//
//  SearchSongTableViewController.swift
//  SkySonic
//
//  Created by Luan Luu on 11/7/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import UIKit

class SearchSongTableViewController: UITableViewController, UISearchBarDelegate {

    var artistName: String?
    var searchData: [Track]?
    var textToBeSent: String?
    var selectedIndex: Int?
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // delegate search bar
        searchBar.delegate = self
        
        // change background color to gray
        self.tableView.backgroundColor = UIColor.systemGray
        
        // change search icon image
        searchBar.setImage(UIImage(named: SEARCH_POINTER_ICON_24), for: .search, state: .normal)
        
        // change the navigation bar's back button image
        self.changeNavigationBarBackButtonImage()
    }
        
    func changeNavigationBarBackButtonImage() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: NAVIGATION_BACK_ARROW_ICON)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: NAVIGATION_BACK_ARROW_ICON)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if the search data is empty retur 0. Otherwise, return the search data array's length
        guard let currentData = searchData else { return 0 }
        return currentData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchSongCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clear
        
        if let currentSearchData = searchData {
            // check to see if the index is actually valid. If it is not valid just return the original cell
            let isValidIndex = currentSearchData.indices.contains(indexPath.row)
            if !isValidIndex {
                return cell
            }
            
            // update the text label and detail text label
            cell.textLabel?.text = "#\(indexPath.row + 1). \(currentSearchData[indexPath.row].trackName)"
            cell.detailTextLabel?.text = currentSearchData[indexPath.row].artistName + " - $\(currentSearchData[indexPath.row].price)"
            // display album image
            let imageURL = URL(string: currentSearchData[indexPath.row].artworkUrl)!
            let getImageTask = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Error in getting image: \(error)")
                    return
                }
                
                if let data = data,
                    let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // use main thread to set the image for each row
                        cell.imageView?.image = image.resizeImageToSmaller(80.0)
                        cell.imageView?.makeRounded(4.0)
                    }
                }
            }
            getImageTask.resume()
            
            // modify the font and color of the text label and detail text label
            cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check to see if the index is actually valid. If it is not valid do nothing
        let isValidIndex = self.searchData?.indices.contains(indexPath.row)
        if !isValidIndex! {
            print("Cannot select this row because the index is invalid")
            return
        }
        
        if let currentRowData = self.searchData?[indexPath.row] {
            textToBeSent   = currentRowData.trackName
            selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "searchToNowPlayingSegue", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_FOR_ROW
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = [ ]
        artistName = searchText
        loadData()
    }
    
    func loadData() {
        // if the artistName is empty do nothing
        guard artistName != nil else { return }
        print("load data is called")

        // otherwise, search the songs based on the artistName
        let         searchURL = createURL(artistName: self.artistName!)!
        let searchDataTask = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            if let error = error {
                print("Error in loading data: \(error)")
            }
            
            print("dataTask, no error")
            
//            let bytesData = String(data: data!, encoding: String.Encoding.utf8)
//            if let bytesData = bytesData {
//                print("bytesData: \(String(describing: bytesData))")
//            }
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let result = try?jsonDecoder.decode(Result.self, from: data) {
                
                // store the results to the searchData array after decoding the json
                for eachResult in result.results {
                    self.searchData?.append(eachResult)
                }
                
                // use main thread to reload the table view
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        searchDataTask.resume()
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