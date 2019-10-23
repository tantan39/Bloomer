//
//  Errpr.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

public enum ServiceErrorCode: String {
    case invalidDataFormat = "INVALID_DATA"
    case invalidToken = "CUS-100001"
    case unauthenticated = "UNAUTHENTICATED"
    case emptyResponse = "EMPTYRESPONSE"
    case timeout = "TIMEOUT"
    case undefined = "UNDEFINED"
}

public struct ServiceErrorAPI: LocalizedError {
    
    static let unauthenticated = ServiceErrorAPI(code: .unauthenticated, reason: "Unauthenticated".localized())
    static let emptyResponse = ServiceErrorAPI(code: .emptyResponse, reason: "Empty Response".localized())
    static let invalidDataFormat = ServiceErrorAPI(code: .invalidDataFormat, reason: "Invalid Data Format".localized())
    static let timeout = ServiceErrorAPI(code: .timeout, reason: "Request Time out".localized())
    static let invalidToken = ServiceErrorAPI(code: .invalidToken, reason: "Invalid token".localized())
    static let undefined = ServiceErrorAPI(code: .undefined, reason: "Undefined error".localized())
    
    fileprivate (set) var code: String
    fileprivate (set) var reason: String
    fileprivate (set) var data: [String: Any]?
    
    public init(code: ServiceErrorCode, reason: String) {
        self.code = code.rawValue
        self.reason = reason
    }
    
    public init(error: Error) {
        self.code = String(error._code)
        self.reason = error.localizedDescription
    }
    
    public init(code: String, reason: String) {
        self.code = code
        self.reason = reason
    }
    
    public var errorDescription: String? {
        get {
            return self.reason
        }
    }
    
    public func getErrorCode() -> String {
        return self.code
    }
    
    public func getMinCartValue() -> Double {
        guard let json = self.data, let minCart = json["min_cart"] as? String, let value = Double(minCart)
            else { return 0 }
        
        return  value
    }
}
