//
//  UIFontExtension.swift
//  PizzaHutCore
//
//  Created by Huỳnh Công Thái on 11/29/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

public enum FontType {
    case primary(FontFormat, FontSize)
}

public enum FontSize: CGFloat {
    case special_24 = 24.0
    case special_20 = 20.0
    
    case h1 = 16.0
    case h2 = 14.0
    case h3 = 12.0
    case h4 = 11.0
    case h5 = 8.0
}

extension UIFont {
    
    public static func fromType(_ type: FontType) -> UIFont {
        var fontSize = 10.cgFloatValue()
        switch type {
        case .primary(_, let size):
            fontSize = size.rawValue
        }
        return UIFont.init(type) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    public convenience init?(_ type: FontType) {
        switch type {
        case .primary(let format, let size):
            let fontName = "Roboto-\(format)"
            self.init(name: fontName, size: size.rawValue)
        }
    }
}
