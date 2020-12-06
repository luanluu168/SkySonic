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
        searchBar.setImage(UIImage(named: RED_SEARCH_ICON_24), for: .search, state: .normal)
        
        // change the navigation bar's back button image
        self.changeNavigationBarBackButtonImage()
    }
        
    func changeNavigationBarBackButtonImage() {
        let backArrowImage = UIImage(named: NAVIGATION_BACK_ARROW_ICON)
        self.navigationController?.navigationBar.backIndicatorImage = backArrowImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrowImage
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
                    // use main thread to set the image for each row
                    DispatchQueue.main.async {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // setup the player before moving to the destination view (NowPlayingViewController)
            player.removeAllItems()
            player.receivedSongName  = textToBeSent // send the current selected song name
            player.tracks = searchData
            player.currentIndex = selectedIndex!
            
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

}
