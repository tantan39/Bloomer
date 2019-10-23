//
//  ContestViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class HomeContestViewController: BaseViewController {
    private let headerMenuView: ContestHeaderMenuView = {
        let view = ContestHeaderMenuView(frame: .zero)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(ContestListCollectionViewCell.self, forCellWithReuseIdentifier: ContestListCollectionViewCell.cellIdentifier())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellIdentifier())
        return collectionView
    }()
    
    let headerViewHeight: CGFloat = 40.0
    
    var viewModel = HomeContestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        view.backgroundColor = .white
        setupHeaderMenuView()
        setupCollectionView()
    }
    
    override func handleObservers() {
        self.headerMenuView.menuSelectedIndex.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self, let indexPath = indexPath else { return }
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.mainContestViewModel?.selectedContest.subscribe (onNext: { [weak self] (item) in
            guard let self = self, let item = item else { return }
            _ = ContestRankingRouter().navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
    }
}

extension HomeContestViewController {
    private func setupHeaderMenuView() {
        self.view.addSubview(self.headerMenuView)
        self.headerMenuView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(headerViewHeight)
        }
        
        self.headerMenuView.dataSource = self.viewModel.dataSouce
    }
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.headerMenuView.snp.bottom)
            maker.bottom.leading.trailing.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.view.width, height: self.view.height - UIApplication.shared.statusBarFrame.height - headerViewHeight)
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
        }
        self.collectionView.isPagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
}

extension HomeContestViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / self.collectionView.width)
        self.headerMenuView.selectedMenu(at: index)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeContestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestListCollectionViewCell.cellIdentifier(), for: indexPath) as? ContestListCollectionViewCell
            cell?.homeContestViewModel = self.viewModel
            return cell ?? UICollectionViewCell()

        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellIdentifier(), for: indexPath) as? UICollectionViewCell
            cell?.backgroundColor = .watermelon
            return cell ?? UICollectionViewCell()
        }
    }
}
