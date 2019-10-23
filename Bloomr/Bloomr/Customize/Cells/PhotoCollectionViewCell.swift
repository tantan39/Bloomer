//
//  PhotoCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: BaseCollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()
    
    override func setupUIComponents() {
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
