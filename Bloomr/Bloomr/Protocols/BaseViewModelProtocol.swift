//
//  ViewModelProtocol.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

protocol BaseViewModelProtocol {
    var disposeBag: DisposeBag { get }
}

extension BaseViewModelProtocol {
    var disposeBag: DisposeBag {
        return DisposeBag()
    }
}
