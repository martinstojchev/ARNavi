//
//  ShareModalCell.swift
//  ARNavi
//
//  Created by Martin on 11/27/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class ShareModalCell: UITableViewCell {

    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    var userID: String!
    
    
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
        
        sendButton.backgroundColor = UIColor.gray
        sendButton.tintColor = UIColor.white
        sendButton.isUserInteractionEnabled = false
        sendButton.titleLabel?.text = "Sent"
    }
    
    
    
}
