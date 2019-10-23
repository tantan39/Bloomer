//
//  MainContestCollectionViewCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class MainContestCollectionViewCell: BaseCollectionViewCell {
    private var headerView: ContestHeaderBannerView = {
        let view = ContestHeaderBannerView(frame: .zero)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.03)
        collectionView.register(ContestCollectionViewCell.self, forCellWithReuseIdentifier: ContestCollectionViewCell.cellIdentifier())
        collectionView.register(LocationItemLayoutCell.self, forCellWithReuseIdentifier: LocationItemLayoutCell.cellIdentifier())
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
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 4
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        }
        
        // Set image ratio 16:9
        let headerViewHeight = self.width * 9/16
        
        self.collectionView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)

        headerView = ContestHeaderBannerView(frame: CGRect(x: 0, y: -headerViewHeight, width: self.width, height: headerViewHeight))
        self.collectionView.addSubview(headerView)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension MainContestCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.homeContestViewModel?.mainContestViewModel?.contests[indexPath.section]
        switch item?.type {
        case .location(1)?:
            return CGSize(width: self.width, height: self.width/2 + 50)
        default:
            // Height cell = topView + centerView + bottomView
            return CGSize(width: self.width, height: self.width * 9/16 + (50 * 2))
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.homeContestViewModel?.mainContestViewModel?.contests.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeContestViewModel?.mainContestViewModel?.contests[section].itemNumbers ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.homeContestViewModel?.mainContestViewModel?.contests[indexPath.section]
        switch item?.type {
            
        case .location(1)?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationItemLayoutCell.cellIdentifier(), for: indexPath) as? LocationItemLayoutCell
            cell?.homeContestViewModel = self.homeContestViewModel
            cell?.backgroundColor = .dusty_pink
            return cell ?? UICollectionViewCell()
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestCollectionViewCell

            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.homeContestViewModel?.mainContestViewModel?.contests[indexPath.section]
        self.homeContestViewModel?.mainContestViewModel?.selectedContest.accept(item)
    }
}
