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
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestsTableViewCell
        
        let cellImage = data[indexPath.row].image!
        let cellTitle = data[indexPath.row].title!
        let acceptImage = data[indexPath.row].acceptImage!
        let declineImage = data[indexPath.row].declineImage!
        
        cell.setRequestCell(image: cellImage, title: cellTitle, acceptImage: acceptImage, declineImage: declineImage)
        
        return cell
    }


}
