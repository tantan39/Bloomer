//
//  GalleryViewModel.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

class GalleryViewModel: BaseViewModel {
    var dataSource: [String] = [String](repeating: "photo", count: 20)
    var photoSelectedNumber = BehaviorRelay<Int>(value: 0)
    
}
