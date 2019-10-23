//
//  UIStackViewExtension.swift
//  PizzaHutCore
//
//  Created by Xuan Thuong on 1/21/19.
//  Copyright © 2019 PHDV Asia. All rights reserved.
//

import UIKit

extension UIStackView {
    static var backgroundViewKey = "UIStackViewBacgroundKey"
    
    public var backgroundView: UIView! {
        get {
            if let view = objc_getAssociatedObject(self, &UIStackView.backgroundViewKey) as? UIView {
                return view
            } else {
                self.backgroundView = UIView()
                self.backgroundView.isUserInteractionEnabled = false
                self.addSubview(self.backgroundView)
                self.sendSubviewToBack(self.backgroundView)
                self.backgroundView.snp.makeConstraints { (make) in
                    make.left.right.top.bottom.equalToSuperview()
                }
                return self.backgroundView
            }
        }
        set { objc_setAssociatedObject(self, &UIStackView.backgroundViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    open override var clipsToBounds: Bool {
        didSet {
            self.backgroundView.clipsToBounds = clipsToBounds
        }
    }
    
    open override var backgroundColor: UIColor? {
        didSet {
            self.backgroundView.backgroundColor = backgroundColor
        }
    }
    
    open func setBorderColor(color: UIColor) {
        self.backgroundView.layer.borderColor = color.cgColor
    }
    
    open func setBorderWitdh(width: CGFloat) {
        self.backgroundView.layer.borderWidth = width
    }
    
    open func setCornerRadius(radius: CGFloat) {
        self.backgroundView.layer.cornerRadius = radius
    }
}
