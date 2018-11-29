//
//  ShowFriendVC.swift
//  ARNavi
//
//  Created by Martin on 11/29/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class ShowFriendVC: UIViewController {

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    
    @IBOutlet weak var showEmailLabel: UILabel!
    @IBOutlet weak var shareCurrenLocationButton: UIButton!
    
    var showingFriend: Friend!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let friend = showingFriend {
            //showImageView.image = friend.getImage()
            showNameLabel.text  = friend.getName()
            showEmailLabel.text = friend.getEmail()
        }
        
        view.backgroundColor = AppColor.backgroundColor.rawValue
        shareCurrenLocationButton.tintColor = AppColor.white.rawValue
        
    }
    
    @IBAction func shareCurrenLocation(_ sender: Any) {
        
    }
    
    

}
