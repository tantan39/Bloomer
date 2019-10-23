//
//  BaseView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import UIKit

open class BaseView: UIView {
    
    // MARK: Define Variables
    @IBInspectable var coneradius: CGFloat = 0
    
    // MARK: Init
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.layoutDidChange()
        self.setupUIComponents()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUIComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUIComponents()
    }
    
    // MARK: Setup
    open func setupUIComponents() {}
    
    private func layoutDidChange() {
        if self.coneradius <= 0 { return }
        self.layer.cornerRadius = self.coneradius
        self.clipsToBounds = true
    }
    
    // MARK: Change Language
    open func setText() {}
}
