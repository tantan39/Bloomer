//
//  Message.swift
//  Bloomr
//
//  Created by Tan Tan on 8/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Message: JSONParsable {
    var code: String = ""
    var message: [String: String]?
    
    init?(json: JSON) {
        self.code = json["error_code"].stringValue
        self.message = json["error_message"].dictionaryObject as? [String : String]
    }
}
