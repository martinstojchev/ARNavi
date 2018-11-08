//
//  RequestsTableViewCell.swift
//  ARNavi
//
//  Created by Martin on 10/31/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

protocol AcceptDeclineRequestDelegate {
    func acceptRequest(userID: String, indexPathRow: IndexPath)
    func declineRequest(userID: String, indexPathRow: IndexPath)
}

class RequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    var userID: String!
    var acceptDeclineDelegate: AcceptDeclineRequestDelegate!
    var cellIndexPathRow: IndexPath!
    
    func setRequestCell(image: UIImage, title: String, acceptImage: UIImage, declineImage: UIImage, userid: String, indexPathRow: IndexPath){
        self.titleLabel.text = title
        self.cellImageView.image = image
        acceptButton.setImage(acceptImage, for: .normal)
        acceptButton.tintColor = AppColor.green.rawValue
        acceptButton.setTitle("", for: .normal)
        acceptButton.tag = 1
        acceptButton.addTarget(self, action: #selector(acceptAction), for: .touchDown)
        declineButton.setImage(declineImage, for: .normal)
        declineButton.setTitle("", for: .normal)
        declineButton.tintColor = AppColor.red.rawValue
        declineButton.tag = 0
        declineButton.addTarget(self, action: #selector(declineAction), for: .touchDown)
        self.contentView.backgroundColor = AppColor.backgroundColor.rawValue
        self.userID = userid
        self.cellIndexPathRow = indexPathRow
        
        
    }
    
    //accept button has tag 1, decline button has tag 0
    
    @objc func acceptAction(){
        
        guard let userid = userID else {return}
        self.acceptDeclineDelegate.acceptRequest(userID: userid, indexPathRow: cellIndexPathRow)
        
    }
    
    @objc func declineAction(){
        
        guard let userid = userID else {return}
        self.acceptDeclineDelegate.declineRequest(userID: userid, indexPathRow: cellIndexPathRow)
        
    }
    

}
