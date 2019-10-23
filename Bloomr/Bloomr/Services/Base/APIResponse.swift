//
//  APIResponse.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import Alamofire
import Moya
import SwiftyJSON

public protocol JSONParsable {
    
    init?(json: JSON)
    func export() -> JSON
}

public extension JSONParsable {
    
    func export() -> JSON {
        return .null
    }
}

// MARK: - API Response
open class ApiResponse {
    
    var error: ServiceErrorAPI?
    let data: JSON?
    
    init(response: Response) {
        if response.isSuccess {
            let json = JSON(response.data)
            if json["status"].exists() && json["status"].intValue == 0 {
                if let errorCode = json["error"]["code"].int {
                    self.error = ServiceErrorAPI(code: "\(errorCode)", reason: "message")
                } else {
                    self.error = ServiceErrorAPI(code: "", reason: "")
                }
            } else {
                self.error = nil
            }
            
            if json["data"].exists() {
                self.data = json["data"]
            } else {
                self.data = json
            }
        } else {
            self.data = nil
            self.error = ServiceErrorAPI(code: "code", reason: "message")
        }
    }
    
    // Keypath is the key following "data"
    // e.g:
    //  "data" : {
    //      "customer" : {
    //          "age": 10
    //          "name": "John"
    //      }
    //   }
    //
    
    // In case of keypath with multiple layers
    // e.g:
    //  "data" : {
    //      "customers": [
    //        "customer" : {
    //        "age": 10
    //        "name": "John"
    //        }
    //      ]
    //   }
    //
    // ** This case, the key path should passed as: "customers"
    // ** The default keypath is "items" for array, "item" for object
     
    public func toObject<T: JSONParsable>(_ as: T.Type, keyPath: String? = nil) -> T? {
        guard var data = self.data else {
            return nil
        }
        
        if var keyPath = keyPath?.components(separatedBy: ".").filter({!$0.isEmpty}) {
            while keyPath.count > 0 {
                if let theKeypath = keyPath.first {
                    data = data[theKeypath]
                    keyPath.removeFirst()
                }
            }
        }
        
        return T(json: data)
    }
    
    public func toArray<T: JSONParsable>(array: [T.Type], keyPath: String? = nil) -> ([T], Pagination?) {
        return self.toArray(array, keyPath: keyPath, usePaging: false)
    }
    
    public func toArray<T: JSONParsable>(_ as: [T.Type], keyPath: String? = nil, usePaging: Bool? = false) -> ([T], Pagination?) {
        guard var rawData = self.data else {
            return ([], nil)
        }
        
        var dataForArray = JSON()
        var pagination: Pagination?
        if var keyPath = keyPath?.components(separatedBy: ".") {
            while keyPath.count > 0 {
                if let theKeypath = keyPath.first {
                    dataForArray = rawData[theKeypath]
                    keyPath.removeFirst()
                    
                    // Check pagination if needed
                    if theKeypath.caseInsensitiveCompare(Constant.defaultKeypathForArray) == .orderedSame {
                        if let usePaging = usePaging, usePaging == true {
                            pagination = Pagination(json: rawData[Constant.defaultKeypathForPagination])
                        }
                    }
                }
            }
        }
        
        return (dataForArray.arrayValue.compactMap { T(json: $0) }, pagination)
    }
}

// MARK: - Moya Extension
public extension Response {
    
    func mapApi() -> ApiResponse {
        return ApiResponse(response: self)
    }
}

public struct ServiceHelper {
    
    static let errorServiceDomain = "pizzahut.error.service"
    static let errorCodeUnauthenticated = 401
    static let errorCodeUnauthorized = 403
    static let errorInternal = 500
    
    public static func defaultEndpointClosure<Target: TargetTypeHelper>(target: Target) -> Endpoint {
        var headers = [String: String]()

        // language
        let currentLanguage = "en"
        var acceptLanguage = "en-US" // Default
        
        if currentLanguage.caseInsensitiveCompare("vi") == .orderedSame {
            acceptLanguage = "vi-VN"
        } else if currentLanguage.caseInsensitiveCompare("en") == .orderedSame {
            acceptLanguage = "en-US"
        } else if currentLanguage.caseInsensitiveCompare("ja") == .orderedSame {
            acceptLanguage = "ja-JP"
        }
        headers["Accept-Language"] = acceptLanguage
        headers["Accept"] = "application/json"
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: TargetHelper(targetType: target))
        return defaultEndpoint.adding(newHTTPHeaderFields: headers)
    }
    
    public static func cancelAllRequests() {
        DefaultAlamofireManager.sharedManager.session.getAllTasks { (tasks) in
            tasks.forEach {
                $0.cancel()
            }
        }
    }
}

extension Moya.Response {
    
    var isSuccess: Bool {
        return statusCode == 200
    }
    
    var isUnauthenticated: Bool {
        return statusCode == ServiceHelper.errorCodeUnauthenticated
    }
    
    var isUnauthorized: Bool {
        return statusCode == ServiceHelper.errorCodeUnauthorized
    }
    
    var isInternalError: Bool {
        return statusCode == ServiceHelper.errorInternal
    }
}

public protocol TargetTypeHelper: TargetType {
    var extendPath: String { get }
}

class TargetHelper: TargetType {
    let targetType: TargetTypeHelper
    required init (targetType: TargetTypeHelper) {
        self.targetType = targetType
    }
    public var baseURL: URL {
        return self.targetType.baseURL
    }
    
    public var path: String {
        return self.targetType.path
    }
    
    public var method: Moya.Method {
        return self.targetType.method
    }
    
    public var headers: [String: String]? {
        return self.targetType.headers
    }
    
    public var sampleData: Data {
        return self.targetType.sampleData
    }
    
    public var task: Task {
        return self.targetType.task
    }
}
