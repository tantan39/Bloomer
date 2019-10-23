//
//  GalleryCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class GalleryCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .baby_blue
        return imageView
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.rouge.withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    private lazy var countNumberView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .rouge
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private lazy var countNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = .fromType(.primary(.medium, .h4))
        label.textAlignment = .center
        return label
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupThumbnailImageView()
        setupHighlightView()
        setupCountNumberView()
        setupCountNumberLabel()
    }
    
    private func setupThumbnailImageView() {
        self.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupHighlightView() {
        self.addSubview(self.highlightView)
        self.highlightView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupCountNumberView() {
        self.highlightView.addSubview(self.countNumberView)
        self.countNumberView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.smallVerticalMargin)
            maker.width.height.equalTo(20)
        }
        self.countNumberView.layer.cornerRadius = 10
    }
    
    private func setupCountNumberLabel() {
        self.countNumberView.addSubview(self.countNumberLabel)
        self.countNumberLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}

extension GalleryCollectionViewCell {
    func selectedWithIndex(value: Int) {
        self.highlightView.isHidden = false
        self.countNumberLabel.text = "\(value)"
    }
}
