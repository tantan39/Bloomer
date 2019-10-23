//
//  ContestSubMenuCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
enum SubMenuCellType {
    case main
    case singing
    case modeling
}

class ContestSubMenuCell: BaseCollectionViewCell {
    private let iconImageView: UIImageView = {
        let imgview = UIImageView(frame: .zero)
        imgview.image = UIImage(named: "icon_contest_main_normal")
        imgview.contentMode = .scaleAspectFit
        return imgview
    }()
    
    var type: SubMenuCellType? = .main {
        didSet {
            switch type {
            case .main?:
                iconImageView.image = isSelected ? UIImage(named: "icon_contest_main_active") : UIImage(named: "icon_contest_main_normal")
            case .singing?:
                iconImageView.image = isSelected ? UIImage(named: "icon_contest_singing_active") : UIImage(named: "icon_contest_singing_normal")
            default:
                iconImageView.image = isSelected ? UIImage(named: "icon_contest_modeling_active") : UIImage(named: "icon_contest_modeling_normal")
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            switch type {
            case .main?:
                iconImageView.image = isSelected ? UIImage(named: "icon_contest_main_active") : UIImage(named: "icon_contest_main_normal")
            case .singing?:
                iconImageView.image = isSelected ? UIImage(named: "icon_contest_singing_active") : UIImage(named: "icon_contest_singing_normal")
            default:
                iconImageView.image = isSelected ? UIImage(named: "icon_contest_modeling_active") : UIImage(named: "icon_contest_modeling_normal")
            }
        }
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupIconImageView()
    }
    
    private func setupIconImageView() {
        self.addSubview(iconImageView)
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
            maker.width.height.equalTo(20)
        }
    }
    
    func binding(image: UIImage?) {
        self.iconImageView.image = image
    }
}
