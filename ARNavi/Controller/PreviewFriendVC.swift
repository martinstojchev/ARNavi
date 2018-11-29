//
//  PreviewFriendVC.swift
//  ARNavi
//
//  Created by Martin on 11/29/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class PreviewFriendVC: UIViewController{
    
    
    @IBOutlet weak var previewingImageView: UIImageView!
    @IBOutlet weak var previewingLabel: UILabel!
    var tappedFriend: Friend!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let friend = tappedFriend {
            previewingLabel.text = friend.getName()
            //previewingImageView.image = friend.getImage()
        }
        
        view.backgroundColor = AppColor.peekColor.rawValue
        
        previewingImageView.layer.cornerRadius = previewingImageView.frame.width / 2
        previewingImageView.layer.borderColor  = AppColor.black.rawValue.cgColor
        previewingImageView.layer.borderWidth  = 1
    }
    

  

}
