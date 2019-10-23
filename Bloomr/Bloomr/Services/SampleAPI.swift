//
//  SampleAPI.swift
//  Bloomr
//
//  Created by Tan Tan on 8/4/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation
import Moya

let SampleAPIProvider = MoyaProvider<SampleAPI>(endpointClosure: ServiceHelper.defaultEndpointClosure, manager: DefaultAlamofireManager.sharedManager, plugins: [MoyaLoggerPlugin])

enum SampleAPI {
    case getMessage
}

extension SampleAPI: TargetTypeHelper {
    var extendPath: String {
        return "extend"
    }
    
    var baseURL: URL {
        return URL(string: "http://localhost:1337/")!
    }
    
    var path: String {
        return "message"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "No caption".data(using: .utf8)!
    }
    
    var parameters: [String: Any]? {
        return [:]
    }

    var headers: [String : String]? {
        return [:]
    }
    
    public var task: Task {
        if self.parameters != nil {
            if self.method == .post {
                return .requestParameters(parameters: self.parameters!, encoding: JSONEncoding.default)
            }
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
        return .requestPlain
    }
    
    
}
