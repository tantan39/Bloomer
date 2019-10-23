//
//  RoundedCornerButton.swift
//  PizzaHutGlobal
//
//  Created by Jacob on 11/15/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable open class RoundedCornerButton: UIButton {
    
    @IBInspectable open var corner: CGFloat = 5
    @IBInspectable open var borderWidth: CGFloat = 0
    @IBInspectable open var borderColor: UIColor?
    @IBInspectable open var borderAlpha: CGFloat = 1.0
    
    open var loadingActivity: UIActivityIndicatorView?
    
    open override var isEnabled: Bool {
        didSet {
            if self.state == .disabled {
                self.isUserInteractionEnabled = false
                self.alpha = 0.5
            } else {
                self.isUserInteractionEnabled = true
                self.alpha = 1
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.startDrawingBorder()
    }
    
    private func startDrawingBorder() {
        self.layer.cornerRadius = corner
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        guard let color = borderColor else {
            self.layer.borderWidth = 0
            return
        }
        self.layer.borderColor = color.withAlphaComponent(borderAlpha).cgColor
    }
    
    public func setup() {
        self.border(borderWidth: 0, cornerRadius: 5, borderColor: UIColor.clear)
        loadingActivity = UIActivityIndicatorView(style: .white)
        loadingActivity?.hidesWhenStopped = true
        loadingActivity?.stopAnimating()
        self.addSubview(loadingActivity!)
        loadingActivity?.snp.makeConstraints({ [weak self] (make) in
            guard let self = self else { return }
            make.center.equalTo(self)
        })
        self.titleLabel?.adjustsFontSizeToFitWidth = true
//        self.titleLabel?.font = UIFont.fromType(.primary(.bold, .h1))
        self.setTitleColor(.lightGray, for: .highlighted)
    }
    
    public func showLoading() {
        self.isUserInteractionEnabled = false
        loadingActivity?.startAnimating()
        self.titleLabel?.removeFromSuperview()
    }
    
    public func hideLoading() {
        self.isUserInteractionEnabled = true
        loadingActivity?.stopAnimating()
        self.addSubview(self.titleLabel!)
    }
    
    public func setupBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.corner = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.startDrawingBorder()
    }
}
