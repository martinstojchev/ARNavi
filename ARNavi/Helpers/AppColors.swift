//
//  AppColors.swift
//  ARNavi
//
//  Created by Martin on 9/24/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import UIKit

enum AppColor{
    
    case black
    case white
    case facebookBlue
    case twitterBlue
    case red
    case gray
    case backgroundColor
    case registerPopupColor
    
}

extension AppColor: RawRepresentable {
    
    
    
    typealias RawValue = UIColor
    
    init?(rawValue: RawValue) {
        
        switch rawValue {
            
        case UIColor(red: 43/255, green: 20/255, blue: 0/255, alpha: 1)        :self = .black
         
        case UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)    :self = .white
            
        case UIColor(red: 60/255, green: 90/255, blue: 150/255, alpha: 1)      :self = .facebookBlue
            
        case UIColor(red: 42/255, green: 163/255, blue: 239/255, alpha: 1)     :self = .twitterBlue
        
        case UIColor(red: 196/255, green: 32/255, blue: 33/255, alpha: 0.3)    :self = .red
        
        case UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)       :self = .gray
            
        case UIColor(red: 0/255, green: 169/255, blue: 165/255, alpha: 1)      :self = .backgroundColor
        
        case UIColor(red: 98/255, green: 149/255, blue: 101/255, alpha: 1)      :self = .registerPopupColor
            
            
        default: return nil
            
        }
        
    }
    
    
    var rawValue: RawValue {
        
        switch self {
            
        case .black              : return  UIColor(red: 43/255, green: 20/255, blue: 0/255, alpha: 1)
        case .white              : return  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case .facebookBlue       : return  UIColor(red: 60/255, green: 90/255, blue: 150/255, alpha: 1)
        case .twitterBlue        : return  UIColor(red: 42/255, green: 163/255, blue: 239/255, alpha: 1)
        case .red                : return  UIColor(red: 196/255, green: 32/255, blue: 33/255, alpha: 1)
        case .gray               : return  UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
        case .backgroundColor    : return UIColor(red: 0/255, green: 169/255, blue: 165/255, alpha: 1)
        case .registerPopupColor : return UIColor(red: 98/255, green: 149/255, blue: 101/255, alpha: 1)
            
        }
    }
    
    
    
}



