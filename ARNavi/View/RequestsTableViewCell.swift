//
//  RequestsTableViewCell.swift
//  ARNavi
//
//  Created by Martin on 10/31/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    
    func setRequestCell(image: UIImage, title: String, acceptImage: UIImage, declineImage: UIImage){
        self.titleLabel.text = title
        self.cellImageView.image = image
        acceptButton.setImage(acceptImage, for: .normal)
        acceptButton.tintColor = AppColor.green.rawValue
        acceptButton.setTitle("", for: .normal)
        declineButton.setImage(declineImage, for: .normal)
        declineButton.setTitle("", for: .normal)
        declineButton.tintColor = AppColor.red.rawValue
        self.contentView.backgroundColor = AppColor.backgroundColor.rawValue
        
        
    }
    

}
