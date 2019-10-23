//
//  Pagination.swift
//  Bloomr
//
//  Created by Tan Tan on 11/29/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
     "total":1,
     "current_page":1,
     "total_pages":1,
     "per_page":"10"
*/

open class Pagination: JSONParsable {
    public var total = 0
    public var currentPage = 0
    public var totalPages = 0
    public var perPage = 0
    
    public required init?(json: JSON) {
        self.total = json["total"].intValue
        self.currentPage = json["current_page"].intValue
        self.totalPages = json["total_pages"].intValue
        self.perPage = json["per_page"].intValue
    }
}
