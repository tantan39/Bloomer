//
//  ContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ContestCollectionViewCell: BaseCollectionViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let topView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let contestTypeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.text = "Location Contest"
        label.font = .fromType(.primary(.medium, .h1))
        return label
    }()
    
    private let uploadButton: RoundedCornerButton = {
        let button = RoundedCornerButton(frame: .zero)
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .rouge
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fromType(.primary(.medium, .h4))
        return button
    }()
    
    private let centerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let bannerImageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "banner_contest")
        return imgView
    }()
    
    private let bottomView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let contestLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h3))
        label.text = "Contest"
        return label
    }()
    
    private let contestTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .fromType(.primary(.regular, .h1))
        label.text = "Happy Contest"
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_contest_share"), for: .normal)
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_contest_info"), for: .normal)
        return button
    }()

    override func setupUIComponents() {
        super.setupUIComponents()
        
        self.backgroundColor = .white
        setupStackView()
        setupTopView()
        setupContestTypeLabel()
        setupUploadButton()
        setupCenterView()
        setupBannerImageView()
        setupBottomView()
        setupContestLabel()
        setupContestTitleLabel()
        setupShareButton()
        setupInfoButton()
    }
    
    private func setupStackView() {
        self.addSubview(stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTopView() {
        self.stackView.addArrangedSubview(topView)
        self.topView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
    }
    
    private func setupContestTypeLabel() {
        self.topView.addSubview(contestTypeLabel)
        self.contestTypeLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupUploadButton() {
        self.topView.addSubview(uploadButton)
        self.uploadButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.height.equalTo(28)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(77)
        }
    }
    
    private func setupCenterView() {
        self.stackView.addArrangedSubview(centerView)
        self.centerView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.width * (9/16))
        }
    }
    
    private func setupBannerImageView() {
        self.centerView.addSubview(bannerImageView)
        self.bannerImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupBottomView() {
        self.stackView.addArrangedSubview(bottomView)
        self.bottomView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
    }
    
    private func setupContestLabel() {
        self.bottomView.addSubview(contestLabel)
        self.contestLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupContestTitleLabel() {
        self.bottomView.addSubview(contestTitleLabel)
        self.contestTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contestLabel.snp.bottom)
            maker.leading.equalTo(self.contestLabel.snp.leading)
        }
    }
    
    private func setupShareButton() {
        self.bottomView.addSubview(shareButton)
        self.shareButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(18)
        }
    }

    private func setupInfoButton() {
        self.bottomView.addSubview(infoButton)
        self.infoButton.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(self.shareButton.snp.leading).offset(-Dimension.shared.mediumHorizontalMargin)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(self.shareButton)
        }
    }
    
    func resizingCell() {
        self.topView.isHidden = true
        self.centerView.snp.updateConstraints { (maker) in
            maker.height.equalTo(self.width)
        }
    }
}
