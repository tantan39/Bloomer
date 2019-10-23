//
//  BaseCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import UIKit

open class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Init
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUIComponents()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUIComponents()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUIComponents()
    }
    
    // MARK: - Setup UI
    open func setupUIComponents() {
        // Where UI components will be polished
    }
}
