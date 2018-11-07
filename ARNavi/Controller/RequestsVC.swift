//
//  RequestsVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class RequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var requestsTableView: UITableView!
    
    var requests = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredRequests = [Friend]()
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ref = Database.database().reference()
//        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Martin", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
//        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Petar", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
//        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Stefan", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
//        data.append(CellData(image: UIImage(named: "profile_pic"), title: "leon", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
//        data.append(CellData(image: UIImage(named: "profile_pic"), title: "Boris", acceptImage: UIImage(named: "request_accept_checkmark"), declineImage: UIImage(named: "request_decline_checkmark")))
        
        self.navigationItem.title = "Requests"
         requestsTableView.dataSource = self
         requestsTableView.delegate = self
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
        requestsTableView.backgroundColor = AppColor.backgroundColor.rawValue
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search requests"
        navigationItem.searchController = searchController
        definesPresentationContext = true
         checkForRequests()
    }
    
    func checkForRequests(){
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        
        ref.child("requests").observe(.value) { (snapshot) in
            var requestArray = [Friend]()
            let value = snapshot.value as? NSDictionary ?? [:]
            print("requests value: \(value)")
            for ids in value {
                let id = ids.key as? String ?? ""
                print("id: \(id)")
                if id == currentUserID {
                    //print("id equal to current id")
                    let requestIDs  = ids.value as? NSArray ?? []
                     print("requestIDs : \(requestIDs)")
                    for requestID in requestIDs {
                        print("requestID: \(requestID)")
                        if let requestIDString = requestID as? String {
                        // find the info for the founded users
                        self.ref.child("users").child(requestIDString).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let value = snapshot.value as? NSDictionary ?? [:]
                            let name = value["name"] as? String ?? ""
                            let email = value["email"] as? String ?? ""
                            let username = value["username"] as? String ?? ""
                            
                            let requestFriend = Friend(userID: requestIDString, name: name, username: username, email: email, image: UIImage())
                            requestArray.append(requestFriend)
                            self.requests = requestArray
                            self.requestsTableView.reloadData()
                            print("requests count: \(self.requests.count)")
                            
                        })
                        
                    }
                        
                    }
                    
                    
                }
            }
            
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredRequests.count
        }
        
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestsTableViewCell
        var cellTitle: String!
        
        let cellImage = requests[indexPath.row].getImage()
        if isFiltering(){
          cellTitle = filteredRequests[indexPath.row].getName()
        }
        else {
          cellTitle = requests[indexPath.row].getName()
        }
        
         let acceptImage = UIImage(named: "request_accept_checkmark") ?? UIImage()
         let declineImage = UIImage(named: "request_decline_checkmark") ?? UIImage()
        
        cell.setRequestCell(image: cellImage, title: cellTitle, acceptImage: acceptImage, declineImage: declineImage)
        
        return cell
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRequests = requests.filter({( request : Friend) -> Bool in
            return request.getName().lowercased().contains(searchText.lowercased())
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
