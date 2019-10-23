//
//  RequestExtension.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift
import SwiftyJSON

public typealias APIResult<T: JSONParsable> = (result: T?, error: ServiceErrorAPI?)
public typealias APIBoolResult = (result: Bool, error: ServiceErrorAPI?)
public typealias APIArrayResult<T: JSONParsable> = (result: [T], pagination: Pagination?, error: ServiceErrorAPI?)

public extension Reactive where Base: MoyaProviderType {

    func requestCheckResult(_ target: Base.Target, disposeBag: DisposeBag? = nil, callbackQueue: DispatchQueue? = nil, keypath: String? = nil) -> BehaviorRelay<APIBoolResult?> {
        
        let relay = BehaviorRelay<APIBoolResult?>(value: nil)
        let sentRequest = self.request(target)
        logDebug(target.path)
        
        let disposable = sentRequest.subscribe { event in
            switch event {
            // Handle success response
            case let .success(response):
                let apiResponse = response.mapApi()
                relay.accept((result: response.isSuccess, error: apiResponse.error))
            // Handle error
            case .error(let error):
                relay.accept((result: false, error: ServiceErrorAPI(error: error)))
            }
        }
        
        if let theDisposeBag = disposeBag {
            disposable.disposed(by: theDisposeBag)
        }
        
        return relay
    }
    
    func requestGetObject<T: JSONParsable>(ofType JSONParsableType: T.Type, _ target: Base.Target, disposeBag: DisposeBag? = nil, callbackQueue: DispatchQueue? = nil, keypath: String? = nil) -> BehaviorRelay<APIResult<T>?> {
        
        let relay = BehaviorRelay<APIResult<T>?>(value: nil)
        let sentRequest = self.request(target)
        logDebug(target.path)
        
        let disposable = sentRequest.subscribe { event in
            switch event {
                // Handle success response
                case let .success(response):

                    let apiResponse = response.mapApi()
                    
                    let theKeypath = keypath ?? Constant.defaultKeypathForItem
                    let object = apiResponse.toObject((T.self), keyPath: theKeypath)
                
                    relay.accept((result: object, error: apiResponse.error))
                
                // Handle error
                case .error(let error):
                relay.accept((result: nil, error: ServiceErrorAPI(error: error)))
            }
        }
            
        if let theDisposeBag = disposeBag {
            disposable.disposed(by: theDisposeBag)
        }
        
        return relay
    }

    func requestGetArray<T: JSONParsable>(ofType JSONParsableType: T.Type, _ target: Base.Target, disposeBag: DisposeBag? = nil, callbackQueue: DispatchQueue? = nil, keypath: String? = nil, usePaging: Bool? = false) ->  (BehaviorRelay<APIArrayResult<T>?>) {
        
        let relay = BehaviorRelay<APIArrayResult<T>?>(value: nil)
        let sentRequest = self.request(target)
        logDebug(target.path)
        
        let disposable = sentRequest.subscribe { event in
            switch event {
                
            // Handle success response
            case let .success(response):
                let apiResponse = response.mapApi()
                let theKeypath = keypath ?? Constant.defaultKeypathForArray
                let objects = apiResponse.toArray([T.self], keyPath: theKeypath, usePaging: usePaging)
                relay.accept((result: objects.0, pagination: objects.1, error: apiResponse.error))

            // Handle error
            case .error(let error):
                relay.accept((result: [], pagination: nil, error: ServiceErrorAPI(error: error)))
            }
        }
        
        if let theDisposeBag = disposeBag {
            disposable.disposed(by: theDisposeBag)
        }
        
        return relay
    }
}
