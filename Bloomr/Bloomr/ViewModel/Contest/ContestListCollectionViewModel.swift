//
//  ContestListCollectionViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

class ContestListCollectionViewModel: BaseViewModel {
    
    var dataSource: [SubMenuCellType] = [.main, .singing, .modeling]
    
    override init() {
        
    }
}
