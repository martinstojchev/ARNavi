//
//  FormFieldPresetFactory.swift
//  ARNavi
//
//  Created by Martin on 10/31/18.
//  Copyright © 2018 Martin. All rights reserved.
//

import Foundation
import SwiftEntryKit

struct TextFieldOptionSet: OptionSet {
    let rawValue: Int
    static let fullName = TextFieldOptionSet(rawValue: 1 << 0)
    static let mobile = TextFieldOptionSet(rawValue: 1 << 1)
    static let email = TextFieldOptionSet(rawValue: 1 << 2)
    static let password = TextFieldOptionSet(rawValue: 1 << 3)
}

enum FormStyle {
    case light
    case dark
    
    var imageSuffix: String {
        switch self {
        case .dark:
            return "_light"
        case .light:
            return "_dark"
        }
    }
    
    var title: EKProperty.LabelStyle {
        let font = UIFont.boldSystemFont(ofSize: 16)
        switch self {
        case .dark:
            return .init(font: font, color: .white, alignment: .center)
        case .light:
            return .init(font: font, color: UIColor.gray, alignment: .center)
        }
    }
    
    var buttonTitle: EKProperty.LabelStyle {
        let font = UIFont.boldSystemFont(ofSize: 16)
        switch self {
        case .dark:
            return .init(font: font, color: .black)
        case .light:
            return .init(font: font, color: .white)
        }
    }
    
    var buttonBackground: UIColor {
        switch self {
        case .dark:
            return .white
        case .light:
            return .red
        }
    }
    
    var placeholder: EKProperty.LabelStyle {
        let font = UIFont.boldSystemFont(ofSize: 14)
        switch self {
        case .dark:
            return .init(font: font, color: UIColor(white: 0.8, alpha: 1))
        case .light:
            return .init(font: font, color: UIColor(white: 0.5, alpha: 1))
        }
    }
    
    var text: EKProperty.LabelStyle {
        let font = UIFont.boldSystemFont(ofSize: 14)
        switch self {
        case .dark:
            return .init(font: font, color: .white)
        case .light:
            return .init(font: font, color: .black)
        }
    }
    
    var separator: UIColor {
        return .init(white: 0.8784, alpha: 0.6)
    }
}

class FormFieldPresetFactory {
    
    class func email(placeholderStyle: EKProperty.LabelStyle, textStyle: EKProperty.LabelStyle, separatorColor: UIColor, style: FormStyle) -> EKProperty.TextFieldContent {
        let emailPlaceholder = EKProperty.LabelContent(text: "Email Address", style: placeholderStyle)
        return .init(keyboardType: .emailAddress, placeholder: emailPlaceholder, textStyle: textStyle, leadingImage: UIImage(named: "ic_mail" + style.imageSuffix), bottomBorderColor: separatorColor)
    }
    
    class func fullName(placeholderStyle: EKProperty.LabelStyle, textStyle: EKProperty.LabelStyle, separatorColor: UIColor, style: FormStyle) -> EKProperty.TextFieldContent {
        let fullNamePlaceholder = EKProperty.LabelContent(text: "Full Name", style: placeholderStyle)
        return .init(keyboardType: .namePhonePad, placeholder: fullNamePlaceholder, textStyle: textStyle, leadingImage: UIImage(named: "ic_user" + style.imageSuffix), bottomBorderColor: separatorColor)
    }
    
    class func mobile(placeholderStyle: EKProperty.LabelStyle, textStyle: EKProperty.LabelStyle, separatorColor: UIColor, style: FormStyle) -> EKProperty.TextFieldContent {
        let mobilePlaceholder = EKProperty.LabelContent(text: "Mobile Phone", style: placeholderStyle)
        return .init(keyboardType: .decimalPad, placeholder: mobilePlaceholder, textStyle: textStyle, leadingImage: UIImage(named: "ic_phone" + style.imageSuffix), bottomBorderColor: separatorColor)
    }
    
    class func password(placeholderStyle: EKProperty.LabelStyle, textStyle: EKProperty.LabelStyle, separatorColor: UIColor, style: FormStyle) -> EKProperty.TextFieldContent {
        let passwordPlaceholder = EKProperty.LabelContent(text: "Password", style: placeholderStyle)
        return .init(keyboardType: .namePhonePad, placeholder: passwordPlaceholder, textStyle: textStyle, isSecure: true, leadingImage: UIImage(named: "ic_lock" + style.imageSuffix), bottomBorderColor: separatorColor)
    }
    
    class func fields(by set: TextFieldOptionSet, style: FormStyle) -> [EKProperty.TextFieldContent] {
        var array: [EKProperty.TextFieldContent] = []
        let placeholderStyle = style.placeholder
        let textStyle = style.text
        let separatorColor = style.separator
        if set.contains(.fullName) {
            array.append(fullName(placeholderStyle: placeholderStyle, textStyle: textStyle, separatorColor: separatorColor, style: style))
        }
        if set.contains(.mobile) {
            array.append(mobile(placeholderStyle: placeholderStyle, textStyle: textStyle, separatorColor: separatorColor, style: style))
        }
        if set.contains(.email) {
            array.append(email(placeholderStyle: placeholderStyle, textStyle: textStyle, separatorColor: separatorColor, style: style))
        }
        if set.contains(.password) {
            array.append(password(placeholderStyle: placeholderStyle, textStyle: textStyle, separatorColor: separatorColor, style: style))
        }
        return array
    }
}
