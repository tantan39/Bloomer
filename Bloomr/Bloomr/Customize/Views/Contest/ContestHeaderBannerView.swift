//
//  ContestHeaderReusableView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ContestHeaderBannerView: UICollectionReusableView {
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellIdentifier())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.width, height: self.height)
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        //                self.collectionView.delegate = self
    }
}

extension ContestHeaderBannerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellIdentifier(), for: indexPath)
        cell.backgroundColor = .baby_blue
        return cell
    }
}
