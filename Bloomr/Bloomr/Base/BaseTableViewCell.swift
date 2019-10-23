//
//  BaseTableViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Init
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUIComponents()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupUIComponents()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .none
        self.setupUIComponents()
    }
    
    // MARK: - Setup UI
    open func setupUIComponents() {
        // Where UI components will be polished
    }
    
    public func setSelectionColor(color: UIColor) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = color
        self.selectedBackgroundView = backgroundView
    }
}
