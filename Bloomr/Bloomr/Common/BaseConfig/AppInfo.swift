//
//  AppInfo.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

open class AppInfo {
    
    open class func appDisplayName() -> String {
        let dipslayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        return dipslayName
    }
    
    open class func version() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        return version
    }
    
    open class func versionString() -> String {
        let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return versionString
    }
    
    open class func bundleId() -> String {
        let bundleId = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as! String
        return bundleId
    }
    
    open class func bundleName() -> String {
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
        return bundleName
    }
    
    open class func osversion() -> String {
        return UIDevice.current.systemVersion
    }
}
