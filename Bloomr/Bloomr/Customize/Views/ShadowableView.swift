//
//  ShadowableView.swift
//  PizzaHutCore
//
//  Created by Jacob on 12/4/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

open class ShadowableView: UIView {

    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The color of shadow
    @IBInspectable public var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.4) {
        didSet {
            self.updateProperties()
        }
    }
    /// The offset of shadow
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The radius of shadow
    @IBInspectable public var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The opacity of shadow
    @IBInspectable public var shadowOpacity: Float = 0.3 {
        didSet {
            self.updateProperties()
        }
    }
    
    @IBInspectable public var isBackgroundViewHidden: Bool = false {
        didSet {
            self.backgroundView.isHidden = self.isBackgroundViewHidden
            self.setNeedsLayout()
        }
    }
    
    lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()

    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.layer.masksToBounds = false
        
        self.addSubview(self.backgroundView)
        self.sendSubviewToBack(self.backgroundView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.updateProperties()
        self.drawShadowPath()
    }
    
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    // Draw shadow
    fileprivate func drawShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    // Updates the shadow once the frame changes.
    override open func layoutSubviews() {
        super.layoutSubviews()

        self.drawShadowPath()
        if !self.isBackgroundViewHidden {
            self.backgroundView.border(borderWidth: 0, cornerRadius: self.cornerRadius, borderColor: .clear)
        }
    }
    
    public func updateBackgroundViewVisibility(isHidden: Bool) {
        self.isBackgroundViewHidden = isHidden
        self.backgroundView.isHidden = self.isBackgroundViewHidden
        self.setNeedsLayout()
    }
}
