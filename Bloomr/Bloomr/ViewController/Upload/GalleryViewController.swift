//
//  GalleryViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import BTNavigationDropdownMenu
class GalleryViewController: BaseViewController {
    
    lazy var menuView: BTNavigationDropdownMenu = {
        let items = ["All Photos", "Favorites"]
        let menuView = BTNavigationDropdownMenu(title: "All Photos", items: items)
        return menuView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.cellIdentifier())
        collectionView.register(OpenCameraCell.self, forCellWithReuseIdentifier: OpenCameraCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let viewModel = GalleryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.titleView = menuView
        self.showNavigationBarRightViewStyle(.next)
        
        self.rightBarButton?.rx.tap.subscribe(onNext: { _ in
            _ = UpdatePostContentRouter(viewModel: self.viewModel).navigate(from: self.navigationController, transitionType: .push, animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuView.hide()
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupCollectionView()
        
        handleObservers()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
            }
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 1.0
            let widthItem =  (self.view.width / 3) - 2
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = padding
            layout.itemSize = CGSize(width: widthItem, height: widthItem)
        }
    }
    
    override func handleObservers() {
        menuView.didSelectItemAtIndexHandler = {[weak self] indexPath in
            guard let self = self else { return }
            logDebug("Did select item at index: \(indexPath)")
        }

    }

}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenCameraCell.cellIdentifier(), for: indexPath) as? OpenCameraCell
            return cell ?? UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellIdentifier(), for: indexPath) as? GalleryCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Open camera
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            let numberSelected = self.viewModel.photoSelectedNumber.value + 1
            self.viewModel.photoSelectedNumber.accept(numberSelected)
            cell?.selectedWithIndex(value: numberSelected)
        }
    }
}
