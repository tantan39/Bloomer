//
//  OpenCameraCell.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class OpenCameraCell: BaseCollectionViewCell {
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_contest_main_active"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        self.backgroundColor = .light_grey
        
        setupCameraButton()
    }
    
    private func setupCameraButton() {
        self.addSubview(cameraButton)
        self.cameraButton.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
