//
//  PlistReader.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

open class PlistReader {
    public static func readConfigurationFile(bundle: Bundle, fileName: String) -> NSDictionary? {
        if let path = bundle.path(forResource: fileName, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        
        return nil
    }
}
