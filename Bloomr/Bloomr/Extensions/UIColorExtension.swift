//
//  UIColorExtension.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
// MARK: - Define App Color
extension UIColor {
    open class var rouge: UIColor {
        return UIColor(hex: ColorConfig.rouge)
    }
    
    open class var baby_blue: UIColor {
        return UIColor(hex: ColorConfig.baby_blue)
    }
    
    open class var soft_blue: UIColor {
        return UIColor(hex: ColorConfig.soft_blue)
    }
    
    open class var very_light_pink: UIColor {
        return UIColor(hex: ColorConfig.very_light_pink)
    }
    
    open class var charcoal_grey: UIColor {
        return UIColor(hex: ColorConfig.charcoal_grey)
    }
    
    open class var french_blue: UIColor {
        return UIColor(hex: ColorConfig.french_blue)
    }
    
    open class var watermelon: UIColor {
        return UIColor(hex: ColorConfig.watermelon)
    }
    
    open class var dusty_pink: UIColor {
        return UIColor(hex: ColorConfig.dusty_pink)
    }
    
    open class var brown_grey: UIColor {
        return UIColor(hex: ColorConfig.brown_grey)
    }
    
    open class var light_grey: UIColor {
        return UIColor(hex: ColorConfig.light_grey)
    }
}

// MARK: - Support Method
extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
            return
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    
    convenience public init(red: Int, green: Int, blue: Int, alphaChannel: CGFloat) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alphaChannel)
    }
    
    convenience public init(netHex: Int, alpha: CGFloat = 1.0) {
        self.init(red: (netHex >> 16) & 0xff,
                  green: (netHex >> 8) & 0xff,
                  blue: netHex & 0xff,
                  alphaChannel: alpha)
    }
    
    convenience public init?(stringHex: String) {
        var cString = stringHex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return nil
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0)
        )
    }
}
