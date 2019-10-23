//
//  ContestAlbumViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ContestAlbumViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: AlbumCollectionViewLayout())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.cellIdentifier())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.showNavigationBarRightViewStyle(.upload)
    }
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupCollectionView()
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
    }
}

extension ContestAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellIdentifier(), for: indexPath) as? PhotoCollectionViewCell
        cell?.backgroundColor = .lightGray
        cell?.titleLabel.text = "\(indexPath.row)"
        return cell ?? UICollectionViewCell()
    }
}
