//
//  FriendsCell.swift
//  ARNavi
//
//  Created by Martin on 10/31/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import Foundation
import UIKit

protocol AddRemoveFriendDelegate {
    func addFriend(withID id: String)
    func removeFriend(withID id: String)
}


class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var addRemoveButton: UIButton!
    var userID: String!
    var addRemoveDelegate: AddRemoveFriendDelegate!
    
    func setFriendsCell(cellImage: UIImage, title: String, buttonText: String, buttonColor: AppColor, userID: String){
        
        cellImageView.image = cellImage
        cellLabel.text = title
        self.backgroundColor = AppColor.backgroundColor.rawValue
        addRemoveButton.setTitle(buttonText, for: .normal)
        addRemoveButton.backgroundColor = buttonColor.rawValue
        
        if buttonColor.rawValue == AppColor.red.rawValue {
         addRemoveButton.tintColor = AppColor.white.rawValue
        }
        else {
            addRemoveButton.tintColor = AppColor.black.rawValue
        }
        
        addRemoveButton.layer.cornerRadius = 7
        addRemoveButton.addTarget(self, action: #selector(tappedButtonAction), for: .touchDown)
        self.userID = userID
        
    }
    
    @objc func tappedButtonAction(){
        
        let buttonText = self.addRemoveButton.titleLabel?.text
        let cellText = self.cellLabel.text ?? ""
        print("cellText: \(cellText)")
        
        if (buttonText == "Add"){
        self.addRemoveDelegate.addFriend(withID: userID)
        print("button tapped add: \(self.cellLabel.text!)")
        
        }
        else if(buttonText == "Remove"){
            self.addRemoveDelegate.removeFriend(withID: userID)
            print("button tapped remove: \(self.cellLabel.text!)")
        }
        
    }
    
}
