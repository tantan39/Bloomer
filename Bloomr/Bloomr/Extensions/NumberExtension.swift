//
//  NumberExtension.swift
//  PizzaHutCore
//
//  Created by Jacob on 12/5/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

extension Int {
    
    public func doubleValue() -> Double {
        return Double(self)
    }
    
    public func floatValue() -> Float {
        return Float(self)
    }
    
    public func cgFloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    
    public func doubleValue() -> Double {
        return Double(self)
    }
    
    public func intValue() -> Int {
        return Int(self)
    }
    
    public func cgFloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Double {
    
    public func intValue() -> Int {
        return Int(self)
    }
    
    public func floatValue() -> Float {
        return Float(self)
    }
    
    public func cgFloatValue() -> CGFloat {
        return CGFloat(self)
    }
}

extension Bool {
    
    public func intValue() -> Int {
        return self ? 1 : 0
    }
}

public protocol DoubleConvertible {
    init(_ double: Double)
    var double: Double { get }
}
extension Double: DoubleConvertible { public var double: Double { return self } }
extension Float: DoubleConvertible { public var double: Double { return Double(self) } }
extension CGFloat: DoubleConvertible { public var double: Double { return Double(self) } }

public extension DoubleConvertible {
    var degreesToRadians: DoubleConvertible {
        return Self(double * .pi / 180)
    }
    var radiansToDegrees: DoubleConvertible {
        return Self(double * 180 / .pi)
    }
}
