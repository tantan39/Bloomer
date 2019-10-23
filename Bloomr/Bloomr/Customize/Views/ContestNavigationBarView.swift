//
//  ContestNavigationBarView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import RxCocoa
import RxSwift

class ContestNavigationBarView: BaseView {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var infoButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_contest_info"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var uploadButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .rouge
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h4))
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupStackView()
        setupInfoButton()
        setupUploadButton()
    }
    
    private func setupStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupInfoButton() {
        self.stackView.addArrangedSubview(self.infoButton)
        self.infoButton.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalTo(18)
            maker.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
    
    private func setupUploadButton() {
        self.stackView.addArrangedSubview(self.uploadButton)
        self.uploadButton.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalTo(Dimension.shared.smallButtonWidth)
            maker.height.equalTo(Dimension.shared.smallButtonHeight)
        }
    }
}
