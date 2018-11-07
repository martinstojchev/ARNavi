//
//  FriendsCell.swift
//  ARNavi
//
//  Created by Martin on 10/31/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import Foundation
import UIKit

class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var addRemoveButton: UIButton!
    
    
    func setFriendsCell(cellImage: UIImage, title: String, buttonText: String, buttonColor: AppColor){
        
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
        
    }
    
}
