//
//  RankingSearchView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class RankingSeachView: BaseView {
    
    lazy var searchTextfield: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.layer.cornerRadius = 5.0
        textfield.layer.borderColor = UIColor.light_grey.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.font = .fromType(.primary(.italic, .h4))
        textfield.placeholder = "Search name, ranking".localized()
        textfield.textAlignment = .center
        return textfield
    }()
    
    lazy var findMyRankButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitle("My Rank".localized().uppercased(), for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h5))
        button.setTitleColor(.baby_blue, for: .normal)
        button.setupBorder(cornerRadius: 5.0, borderWidth: 1, borderColor: .baby_blue)
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupFindMyRankButton()
        setupSearchTextfield()
    }
    
    private func setupSearchTextfield() {
        self.addSubview(searchTextfield)
        self.searchTextfield.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self.findMyRankButton)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalTo(self.findMyRankButton.snp.leading).offset(-10)
        }
    }
    
    private func setupFindMyRankButton() {
        self.addSubview(findMyRankButton)
        self.findMyRankButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
            maker.width.equalTo(Dimension.shared.smallButtonWidth)
        }
    }
}
