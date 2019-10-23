//
//  CityCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class LocationItemLayoutCell: BaseCollectionViewCell {
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(ContestCollectionViewCell.self, forCellWithReuseIdentifier: ContestCollectionViewCell.cellIdentifier())
        
        return collectionView
    }()
    
    var homeContestViewModel: HomeContestViewModel?
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 2
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: (self.width / 2), height: self.height)
        }
        self.collectionView.isScrollEnabled = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension LocationItemLayoutCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestCollectionViewCell
        cell?.resizingCell()
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.homeContestViewModel?.mainContestViewModel?.contests[indexPath.section]
        self.homeContestViewModel?.mainContestViewModel?.selectedContest.accept(item)
    }
}
