//
//  MainContestViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxSwift
import RxCocoa

enum ContestItemType {
    // location 0: Country
    // location 1: HCM or HN
    case location(Int)
    case sponsor
    case theme
}

protocol ContestItemProtocol {
    var type: ContestItemType { get }
    var sectionTitle: String { get }
    var itemNumbers: Int { get }
}

class MainContestViewModel: BaseViewModel {
    var contests: [ContestItemProtocol] = [LocationContestItem(), CityContestItem(), SponsorContestItem(), ThemeContestItem()]
    var selectedContest: BehaviorRelay<ContestItemProtocol?> = BehaviorRelay<ContestItemProtocol?>(value: nil)    
    
}
