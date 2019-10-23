//
//  ExpandingMenuItem.swift
//  Bloomr
//
//  Created by Tan Tan on 8/19/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ExpandingMenuItem: UIView {
    var size: CGSize? {
        didSet {
            
        }
    }
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.text = self.title
        label.font = .fromType(.primary(.medium, .h2))
        return label
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    convenience init(title: String?, image: UIImage?, size: CGSize?) {
        self.init()
        
        self.title = title
        self.image = image
        self.size = size
        self.frame = CGRect(origin: .zero, size: self.size ?? .zero)
        self.layer.cornerRadius = self.width/2
        configItem()
    }
    
    func configItem() {
        self.backgroundColor = .rouge
        titleLabel.text = self.title
        imageView.image = self.image
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
    }
}
