//
//  ContestHeaderMenuView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/10/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContestHeaderMenuView: BaseView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(ContestHeaderMenuCell.self, forCellWithReuseIdentifier: ContestHeaderMenuCell.cellIdentifier())
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let genderView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private let genderButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .watermelon
        button.setTitle("Female".localized(), for: .normal)
        button.titleLabel?.font = UIFont.fromType(.primary(.regular, .h5))
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .light_grey
        return view
    }()
    
    var dataSource: [String]? {
        didSet {
            guard let dataSource = dataSource, dataSource.count > 0 else { return }
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
        }
    }
    var menuSelectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupCollectionView()
        setupGenderView()
        setupGenderButton()
        setupLineView()
    }
    
    private func setupCollectionView() {
        self.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-1)
            maker.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width/4)
        }
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 60, height: 40)
            layout.minimumInteritemSpacing = 1
            layout.scrollDirection = .horizontal
        }
        
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupGenderView() {
        self.addSubview(self.genderView)
        self.genderView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.collectionView.snp.trailing)
            maker.top.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupGenderButton() {
        self.addSubview(self.genderButton)
        self.genderButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin_12)
            maker.height.equalTo(16)
            maker.width.equalTo(42)
        }
    }
    
    private func setupLineView() {
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.collectionView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
}

extension ContestHeaderMenuView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 1000, height: self.height)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimateFrame = NSString(string: (dataSource?[indexPath.row])!).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: UIFont.fromType(.primary(.medium, .h3))], context: nil)
    
        return CGSize(width: estimateFrame.width + (Dimension.shared.normalHorizontalMargin * 2) + 1, height: 39)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContestHeaderMenuCell.cellIdentifier(), for: indexPath) as? ContestHeaderMenuCell
        cell?.titleLabel.text = dataSource?[indexPath.row] ?? ""
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.menuSelectedIndex.accept(indexPath)
    }
}

// MARK: - Support function
extension ContestHeaderMenuView {
    func selectedMenu(at index: Int) {
        self.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .init())
    }
}
