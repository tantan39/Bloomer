//
//  ContestHeaderMenuCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ContestHeaderMenuCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .dusty_pink
        label.font = .fromType(.primary(.medium, .h3))
        label.text = "CONTEST"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .rouge : .dusty_pink
            titleLabel.font = isSelected ? .fromType(.primary(.medium, .h3)) : .fromType(.primary(.regular, .h3))
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalToSuperview()
        }
    }
}
