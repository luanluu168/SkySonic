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
                        // use main thread to set the image for each cell
                        cell.imageView?.image = image
                    }
                }
            }
            getImageTask.resume()
        }
        
        return cell
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
