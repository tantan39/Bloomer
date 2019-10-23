//
//  HomeContestViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeContestViewModel: BaseViewModel {
    
    let dataSouce: [String] = ["CONTEST", "WINNER CLUB", "HALL OF FAME"]
    
    var contestListCollectionViewModel: ContestListCollectionViewModel?
    var mainContestViewModel: MainContestViewModel?
    
    override init() {
        self.mainContestViewModel = MainContestViewModel()
        self.contestListCollectionViewModel = ContestListCollectionViewModel()
    }
}
