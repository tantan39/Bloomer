//
//  UpdateContentPostCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class UpdatePostContentCell: BaseCollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .rouge
        return imageView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = .fromType(.primary(.regular, .h2))
        textView.textColor = .very_light_pink
        textView.text = "What's on your mind".localized()
        return textView
    }()
    
    lazy var bottomLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupContainerView()
        setupThumbnailImageView()
        setupTextView()
        setupBottomLineView()
    }
    
    private func setupContainerView() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupThumbnailImageView() {
        self.containerView.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            maker.width.height.equalTo(self.width/3)
        }
    }
    
    private func setupTextView() {
        self.containerView.addSubview(self.textView)
        self.textView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Dimension.shared.normalHorizontalMargin)
            maker.top.bottom.equalTo(self.thumbnailImageView)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupBottomLineView() {
        self.containerView.addSubview(self.bottomLineView)
        self.bottomLineView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.bottom.equalToSuperview()
        }
    }
}
