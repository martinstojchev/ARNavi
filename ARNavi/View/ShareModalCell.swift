//
//  ShareModalCell.swift
//  ARNavi
//
//  Created by Martin on 11/27/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

protocol SharingPlacesDelegate {
    func sharePlaceWithFriend(friendID: String, friendName: String)
}

class ShareModalCell: UITableViewCell {

    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    var userID: String!
    var sharePlaceDelegate: SharingPlacesDelegate!
    
    func setShareModelCell(friendName: String, userID: String, buttonTextColor: AppColor, buttonBackgroudColor: AppColor){
        
        self.friendsNameLabel.text = friendName
        self.userID = userID
        sendButton.titleLabel?.text = "Send"
        sendButton.tintColor = buttonTextColor.rawValue
        sendButton.backgroundColor = buttonBackgroudColor.rawValue
        sendButton.layer.cornerRadius = 7
        sendButton.addTarget(self, action: #selector(tappedSendButtonAction), for: .touchUpInside)
    }
    
    
    
    @objc func tappedSendButtonAction(){
        
        guard let friendName = self.friendsNameLabel.text else {return }
        guard let friendID   = self.userID else {return}
        
        print("tapped cell name: \(friendName) with id: \(friendID)")
        sharePlaceDelegate.sharePlaceWithFriend(friendID: friendID, friendName: friendName)
        
        sendButton.backgroundColor = UIColor.gray
        sendButton.tintColor = UIColor.white
        self.sendButton.isUserInteractionEnabled = false
        self.sendButton.setTitle("Sent", for: .normal)
        
        
        
        
        
    }
    
    
    
}
