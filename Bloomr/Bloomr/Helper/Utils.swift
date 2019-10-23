//
//  Utils.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import UIKit

public enum ScreenType {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6s
    case iPhone6Plus
    case iPhone6sPlus
    case iPhone7
    case iPhone7Plus
    case unknown
    
    var size: CGSize {
        switch self {
        case .iPhone5:
            return CGSize(width: 320.0, height: 568.0)
        case .iPhone6, .iPhone6s, .iPhone7 :
            return CGSize(width: 375.0, height: 667.0)
        case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus:
            return CGSize(width: 414.0, height: 736.0)
        default: // default is iphone  5
            return CGSize(width: 320.0, height: 568.0)
        }
    }
}

public extension UIDevice {
    
    static var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }

    static var screenType: ScreenType? {
        guard iPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 1920:
            return .iPhone6Plus
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }
    
    static func getRatioByWidth(original: ScreenType = .iPhone6) -> CGFloat {
        return UIScreen.main.bounds.width / original.size.width
    }
    
    static func getRatioByHeight(original: ScreenType = .iPhone6) -> CGFloat {
        return UIScreen.main.bounds.height / original.size.height
    }
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}

public struct Platform {
    public static let isSimulator: Bool = {
        var isSim = false
        #if targetEnvironment(simulator)
        isSim = true
        #endif
        return isSim
    }()
}

public enum UIUserInterfaceIdiom: Int {
    case Unspecified
    case Phone
    case Pad
}

public struct ScreenSize {
    public static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    public static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    public static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

public struct DeviceType {
    public static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    public static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    public static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    public static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    public static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    public static let IS_IPHONE_R         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0 && UIScreen.main.scale == 2
    public static let IS_IPHONE_MAX         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0 && UIScreen.main.scale == 3
    public static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    public static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
