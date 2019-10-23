//
//  ObjectExtension.swift
//  PizzaHutCore
//
//  Created by James Nguyen on 5/22/19.
//  Copyright © 2019 PHDV Asia. All rights reserved.
//

import Foundation


extension NSObject {
    @objc var className: String {
        return String(describing: type(of: self))
    }
    
    @objc class var className: String {
        return String(describing: self)
    }
}
