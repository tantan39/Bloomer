//
//  BaseScrollView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import UIKit

// This class is a base for UIView can scroll
open class BaseScrollView: UIScrollView {
    
    // MARK: - Define Components
    public let view: UIView = UIView()
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    // MARK: - Setup layout
    func setupView() {
//        self.backgroundColor = UIColor.background2
        self.addSubview(self.view)
        
        self.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.view.backgroundColor = UIColor.clear
    }
}
