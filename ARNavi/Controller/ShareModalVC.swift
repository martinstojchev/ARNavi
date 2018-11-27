//
//  ShareModalVC.swift
//  ARNavi
//
//  Created by Martin on 11/27/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ShareModalVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var cancelModalButton: UIButton!
    @IBOutlet weak var shareModalTableview: UITableView!
    var sharingFavPlace: FavouritePlace!
    var friends: [Friend]!
    var ref: DatabaseReference!
    
//    let martin = Friend(userID: "u32udsdud12u312", name: "Martin", username: "martin123", email: "martin@mail.com", image: UIImage())
//    let petar = Friend(userID: "m231dsdas123mmsd", name: "Petar", username: "petar1", email: "petar@mail.com", image: UIImage())
//    let stefan = Friend(userID: "zW32nsmj1332", name: "Stefan", username: "stefan_12", email: "stefan@mail.com", image: UIImage())
//    let boris = Friend(userID: "2139dsnsnajsu3", name: "Boris", username: "boris", email: "boris@mail.com", image: UIImage())
    
//    var friends: [Friend] = [Friend(userID: "u32udsdud12u312", name: "Martin", username: "martin123", email: "martin@mail.com", image: UIImage()),
//                              Friend(userID: "m231dsdas123mmsd", name: "Petar", username: "petar1", email: "petar@mail.com", image: UIImage()),
//                              Friend(userID: "zW32nsmj1332", name: "Stefan", username: "stefan_12", email: "stefan@mail.com", image: UIImage()),
//                              Friend(userID: "2139dsnsnajsu3", name: "Boris", username: "boris", email: "boris@mail.com", image: UIImage())]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        cancelModalButton.tintColor = AppColor.white.rawValue
        cancelModalButton.addTarget(self, action: #selector(cancelModalButtonAction), for: .touchUpInside)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModalCell") as! ShareModalCell
        
         let friendName = friends[indexPath.row].getName()
         let userID     = friends[indexPath.row].getUserID()
        
        cell.sharePlaceDelegate = self
        cell.setShareModelCell(friendName: friendName, userID: userID, buttonTextColor: AppColor.white, buttonBackgroudColor: AppColor.green)
        
        return cell
        
    }
    
    
    @objc func cancelModalButtonAction(){
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension ShareModalVC: SharingPlacesDelegate {
    

    func sharePlaceWithFriend(friendID: String, friendName: String) {
        print("ShareModalVC: friendName: \(friendName) with id: \(friendID)")
        
        ref = Database.database().reference()
        
        if let sharingPlace = sharingFavPlace {
            
              let placeName = sharingPlace.getName()
              let placeCoordinate = sharingPlace.getCoordinate()
              let placeLatitudeString = String(placeCoordinate.latitude)
              let placeLongitudeString = String(placeCoordinate.longitude)
            
            print("Place for sharing: place: \(placeName) with lat: \(placeLatitudeString) and lon: \(placeLongitudeString)")
           
            guard let currentUserName = Auth.auth().currentUser?.displayName else {return}
            
            print("Current user name: \(currentUserName)")
            
            let databasePlaceName = currentUserName.appending("'s \(placeName)")
            print("databasePlaceName: \(databasePlaceName)")
            
            ref.child("users").child(friendID).child("places").child(databasePlaceName).updateChildValues(["lat" : placeLatitudeString])
            ref.child("users").child(friendID).child("places").child(databasePlaceName).updateChildValues(["lon" : placeLongitudeString])
            
        }
        
        
    }
    
    
    

}
