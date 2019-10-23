//
//  ContestRankingCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/16/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ContestRankingCollectionViewCell: BaseCollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let indexLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .fromType(.primary(.medium, .special_20))
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .rouge
        label.font = .fromType(.primary(.medium, .h1))
        return label
    }()
    
    private let flowerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let iconFLowerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "icon_small_flower")
        return imageView
    }()
    
    private let numberFlowerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .fromType(.primary(.medium, .h3))
        return label
    }()
    
    private let viewAlbumButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_album_contest"), for: .normal)
        return button
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .white
        
        setupContainerView()
        setupIndexLabel()
        setupAvatarImageView()
        setupNameLabel()
        setupFlowerView()
        setupIconFlowerImageView()
        setupNumberFlowerLabel()
        setupViewAlbumButton()
        setupBottomLineView()
    }
    
    private func setupContainerView() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupIndexLabel() {
        self.containerView.addSubview(self.indexLabel)
        self.indexLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupAvatarImageView() {
        self.containerView.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.indexLabel.snp.trailing).offset(Dimension.shared.normalVerticalMargin)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(45)
        }
        self.avatarImageView.layer.cornerRadius = 22.5
    }
    
    private func setupNameLabel() {
        self.containerView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.avatarImageView.snp.trailing).offset(Dimension.shared.largeVerticalMargin)
            maker.bottom.equalTo(self.containerView.snp.centerY)
        }
    }
    
    private func setupFlowerView() {
        self.containerView.addSubview(self.flowerView)
        self.flowerView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.nameLabel)
            maker.top.equalTo(self.nameLabel.snp.bottom)
            maker.height.equalTo(15)
        }
    }
    
    private func setupIconFlowerImageView() {
        self.flowerView.addSubview(self.iconFLowerImageView)
        self.iconFLowerImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(10)
        }
    }
    
    private func setupNumberFlowerLabel() {
        self.flowerView.addSubview(self.numberFlowerLabel)
        self.numberFlowerLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.iconFLowerImageView.snp.trailing).offset(Dimension.shared.mediumVerticalMargin)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
    
    private func setupViewAlbumButton() {
        self.containerView.addSubview(self.viewAlbumButton)
        self.viewAlbumButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(20)
        }
    }
    
    private func setupBottomLineView() {
        self.containerView.addSubview(self.bottomLineView)
        self.bottomLineView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
            maker.leading.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
    }
    
}

extension ContestRankingCollectionViewCell {
    func binding() {
        self.indexLabel.text = "1"
//        self.avatarImageView.image = UIImage(named: "")
        self.avatarImageView.backgroundColor = .french_blue
        self.nameLabel.text = "N.D.Lan Ngọc"
        self.numberFlowerLabel.text = "212454353"
    }
}
