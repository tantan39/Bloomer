//
//  CALayer + Ext.swift
//  Pizzahut
//
//  Created by Huỳnh Công Thái on 5/3/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

public enum DashedLineInset {
    case top
    case center
    case bottom
}

public extension CALayer {
    func dashedBorderLayerWithColor(color: UIColor, dashWidth: Int = 3, dash: Int = 3, cornerRadius: CGFloat = 0) {
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        borderLayer.bounds = shapeRect
        borderLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = 1
        borderLayer.lineJoin = CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: dashWidth), NSNumber(value: dash)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: cornerRadius)
        
        borderLayer.path = path.cgPath
        
        self.addSublayer(borderLayer)
    }
    
    func lineLayerWithColor(color: UIColor) {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        let size = self.frame.size
        
        path.move(to: CGPoint.init(x: 0, y: size.height))
        path.addLine(to: CGPoint.init(x: size.width, y: size.height))
        
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 0.5
        
        self.addSublayer(layer)
    }
    
    func lineLayerWith(color: UIColor, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        let size = self.frame.size
        
        path.move(to: CGPoint.init(x: left, y: size.height - bottom))
        path.addLine(to: CGPoint.init(x: size.width - left - right, y: size.height - bottom))
        
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 0.5
        
        self.addSublayer(layer)
    }
    
    func dashedLineLayerWithColor(color: UIColor, inset: DashedLineInset = .bottom, dash: NSNumber = 2) {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        let size = self.frame.size
        
        switch inset {
        case .top:
            path.move(to: CGPoint.init(x: 0, y: 0))
            path.addLine(to: CGPoint.init(x: size.width, y: 0))
        case .center:
            path.move(to: CGPoint.init(x: 0, y: size.height / 2.0))
            path.addLine(to: CGPoint.init(x: size.width, y: size.height / 2.0))
        case .bottom:
            path.move(to: CGPoint.init(x: 0, y: size.height))
            path.addLine(to: CGPoint.init(x: size.width, y: size.height))
        }
        
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.lineDashPattern = [dash, dash]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        self.addSublayer(layer)
    }
    
    func addBorderWith(borderColor: UIColor, borderWidth: CGFloat = 1) {
        self.borderColor = borderColor.cgColor
        self.borderWidth = borderWidth
    }
}
