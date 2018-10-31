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
    
    func setFriendsCell(cellImage: UIImage, title: String){
        
        cellImageView.image = cellImage
        cellLabel.text = title
        self.backgroundColor = AppColor.backgroundColor.rawValue
        
    }
    
}
