//
//  ContestRankingViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class ContestRankingViewController: BaseViewController {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var headerStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var timeSegmentView: SegmentView = {
        let segment = SegmentView(frame: .zero)
        return segment
    }()
    
    lazy var lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    
    lazy var searchView: RankingSeachView = {
        let view = RankingSeachView(frame: .zero)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.width, height: 65)
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.register(ContestRankingCollectionViewCell.self, forCellWithReuseIdentifier: ContestRankingCollectionViewCell.cellIdentifier())
        collectionView.register(ContestHeaderBannerView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ContestHeaderBannerView.reuseIdentifier())
        return collectionView
    }()
        
    override func setupUIComponents() {
        super.setupUIComponents()
        self.view.backgroundColor = .white
        
        setupStackView()
        setupTopStackView()
        setupTimeSegmentView()
        setupLineView()
        setupSearchView()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
       self.showNavigationBarRightViewStyle(.upload)
    }
    
    private func setupStackView() {
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTopStackView() {
        self.stackView.addArrangedSubview(self.headerStackView)
        self.headerStackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTimeSegmentView() {
        self.headerStackView.addArrangedSubview(self.timeSegmentView)
        self.timeSegmentView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
    }
    
    private func setupLineView() {
        self.headerStackView.addArrangedSubview(self.lineView)
        self.lineView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
    private func setupSearchView() {
        self.headerStackView.addArrangedSubview(self.searchView)
        self.searchView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.timeSegmentView.snp.height)
        }
    }
    
    private func setupCollectionView() {
        self.stackView.addArrangedSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}

extension ContestRankingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.width, height: self.view.width * 9/16)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ContestHeaderBannerView.reuseIdentifier(), for: indexPath)
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestRankingCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestRankingCollectionViewCell
        cell?.binding()
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = ContestAlbumRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
    }
}
