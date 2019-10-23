//
//  LocationContestCollectionView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/12/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class LocationContestCollectionViewCell: BaseCollectionViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let topView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .orange
        return view
    }()
    
    private let centerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .green
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .soft_blue
        return view
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupStackView()
        setupTopView()
        setupCenterView()
        setupBottomView()
    }
    
    private func setupStackView() {
        self.addSubview(stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTopView() {
        self.stackView.addArrangedSubview(topView)
        self.topView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
    }
    
    private func setupCenterView() {
        self.stackView.addArrangedSubview(centerView)
        self.centerView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            //            maker.height.equalTo(200)
        }
    }
    
    private func setupBottomView() {
        self.stackView.addArrangedSubview(bottomView)
        self.bottomView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
    }
}
