//
//  ContestSubMenuView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/11/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ContestSubMenuView: BaseView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ContestSubMenuCell.self, forCellWithReuseIdentifier: ContestSubMenuCell.cellIdentifier())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var viewModel: ContestListCollectionViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }

    var subMenuSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: 40)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ContestSubMenuView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.dataSource.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestSubMenuCell.cellIdentifier(), for: indexPath) as? ContestSubMenuCell
        cell?.type = (self.viewModel?.dataSource[indexPath.row])!
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContestSubMenuCell else { return }
        self.subMenuSelectedIndex.accept(indexPath)
    }
}

// MARK: - Support function
extension ContestSubMenuView {
    func selectedMenu(at index: Int) {
        self.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .init())
    }
}
