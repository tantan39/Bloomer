//
//  UpdatePostContentViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class UpdatePostContentViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UpdatePostContentCell.self, forCellWithReuseIdentifier: UpdatePostContentCell.cellIdentifier())
        collectionView.backgroundColor = .light_grey
        collectionView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var viewModel: GalleryViewModel?
    
    convenience init(viewModel: GalleryViewModel?) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.showNavigationBarRightViewStyle(.next)
        self.rightBarButton?.title = "Upload".localized()
        
        handleObservers()
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
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0.0
            layout.scrollDirection = .vertical
        }
    }
    
    override func handleObservers() {
        self.rightBarButton?.rx.tap.subscribe(onNext: { _ in
            // TO DO
        }).disposed(by: self.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension UpdatePostContentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Top padding + thumnail imageview height + bottom padding
        let estimateHeight = (self.view.width/3) + (Dimension.shared.mediumVerticalMargin * 2)
        return CGSize(width: self.view.width, height: estimateHeight)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.photoSelectedNumber.value ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpdatePostContentCell.cellIdentifier(), for: indexPath) as? UpdatePostContentCell
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
