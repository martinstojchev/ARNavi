//
//  RequestsVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

struct CellData {
    let image : UIImage?
    let title : String?
    let acceptImage: UIImage?
    let declineImage: UIImage?
}

class RequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var requestsTableView: UITableView!
    
    var data = [CellData]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredRequests = [CellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Martin", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Petar", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Stefan", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
        data.append(CellData(image: UIImage(named: "profile_pic"), title: "leon", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Boris", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
        
        self.navigationItem.title = "Requests"
         requestsTableView.dataSource = self
         requestsTableView.delegate = self
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
        requestsTableView.backgroundColor = AppColor.backgroundColor.rawValue
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredRequests.count
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestsTableViewCell
        var cellTitle: String!
        
        let cellImage = data[indexPath.row].image!
        if isFiltering(){
          cellTitle = filteredRequests[indexPath.row].title!
        }
        else {
          cellTitle = data[indexPath.row].title!
        }
        
        let acceptImage = data[indexPath.row].acceptImage!
        let declineImage = data[indexPath.row].declineImage!
        
        cell.setRequestCell(image: cellImage, title: cellTitle, acceptImage: acceptImage, declineImage: declineImage)
        
        return cell
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRequests = data.filter({( request : CellData) -> Bool in
            return request.title!.lowercased().contains(searchText.lowercased())
        })
        
        requestsTableView.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }


}
extension RequestsVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
