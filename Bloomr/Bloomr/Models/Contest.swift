//
//  Contest.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation

class LocationContestItem: ContestItemProtocol {
    var type: ContestItemType {
        get {
            return .location(0)
        }
    }
    var sectionTitle: String = "Location contest"
    var itemNumbers: Int = 1
}

class CityContestItem: ContestItemProtocol {
    var type: ContestItemType {
        get {
            return .location(1)
        }
    }
    var sectionTitle: String = "City contest"
    var itemNumbers: Int = 1
}

class SponsorContestItem: ContestItemProtocol {
    var type: ContestItemType {
        get {
            return .sponsor
        }
    }
    
    var sectionTitle: String = "Sponsor contest"
    
    var itemNumbers: Int = 1
}

class ThemeContestItem: ContestItemProtocol {
    var type: ContestItemType {
        get {
            return .theme
        }
    }
    
    var sectionTitle: String = "Theme contest"
    
    var itemNumbers: Int = 5
}
