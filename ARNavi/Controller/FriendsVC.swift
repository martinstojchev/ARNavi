//
//  FriendsVC.swift
//  ARNavi
//
//  Created by Martin on 10/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

struct FriendsData {
    let image : UIImage?
    let title : String?
}

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsData = [FriendsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Friends"
        friendsTableView.dataSource = self
        friendsTableView.delegate   = self
        friendsTableView.backgroundColor = AppColor.backgroundColor.rawValue
        view.backgroundColor = AppColor.backgroundColor.rawValue
        // Do any additional setup after loading the view.
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Petar"))
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Leon"))
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Mirko"))
        friendsData.append(FriendsData(image: UIImage(named: "profile_pic"), title: "Boris"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        
        let cellImage = friendsData[indexPath.row].image!
        let cellTitle = friendsData[indexPath.row].title!
        
        cell.setFriendsCell(cellImage: cellImage, title: cellTitle)
        
        return cell
    }
    

}
