//
//  HomeTabBarView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/14/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class HomeTabBarView: BaseView {
    private let primaryImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_tabbar_flower_red"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let secondaryImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_tabbar_flower_white")
        return imageView
    }()
    
    private let flowerNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "3000"
        label.font = .fromType(.primary(.regular, .h5))
        label.textColor = .black
        return label
    }()
    
    private lazy var homeLocation: SEDraggableLocation = {
        let location = SEDraggableLocation(frame: CGRect(x: 0, y: 0, width: flowerButtonHeight, height: flowerButtonHeight))
        location.objectWidth = Float(flowerButtonHeight)
        location.objectHeight = Float(flowerButtonHeight)
        return location
    }()
    
    lazy var homeDraggable: SEDraggable = {
        let draggable = SEDraggable(imageView: self.primaryImageView)
        return draggable!
    }()
    
    var flowerButtonHeight: CGFloat = 42.0

    override func setupUIComponents() {
        super.setupUIComponents()
        
        setupHomeLocation()
        setupSecondaryImageView()
        setupFlowerNumberLabel()
    }

    private func setupHomeLocation() {
        self.addSubview(homeLocation)
        self.homeDraggable.homeLocation = self.homeLocation
        self.homeLocation.addDraggableObject(homeDraggable, animated: false)
        
        self.homeDraggable.isExclusiveTouch = true
        self.bringSubviewToFront(homeDraggable)
    }
    
    private func setupSecondaryImageView() {
        self.insertSubview(self.secondaryImageView, belowSubview: self.homeLocation)
        self.secondaryImageView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.height.equalTo(self.homeLocation)
        }
    }
    
    private func setupFlowerNumberLabel() {
        self.addSubview(self.flowerNumberLabel)
        self.flowerNumberLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.secondaryImageView.snp.bottom).offset(1)
            maker.centerX.equalToSuperview()
        }
    }
}

// MARK: - Support method
extension HomeTabBarView {
    private func configureDraggableLocation(location: SEDraggableLocation) {
//        location.objectWidth = Float(location.width)
//        location.objectHeight = Float(location.height)
        
//        location.marginLeft = -12.0
//        location.marginRight = 0.0
//        location.marginTop = -12.0
//        location.marginBottom = 0.0
//
//        location.marginBetweenX = 0.0
//        location.marginBetweenY = 0.0
//
//        location.highlightColor = UIColor.green.cgColor
//        location.highlightOpacity = 0.4
//        location.shouldHighlightOnDragOver = true
//
//        location.shouldAcceptDroppedObjects = false
//
//        location.shouldKeepObjectsArranged = true
//        location.fillHorizontallyFirst = true
//        location.allowRows = true
//        location.allowColumns = true
//        location.shouldAnimateObjectAdjustments = true
//        location.animationDuration = 0.5
//        location.animationDelay = 0.0
//        location.animationOptions = .layoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;
//
//        location.shouldAcceptObjectsSnappingBack = true
    }
}

extension HomeTabBarView: SEDraggableLocationEventResponder {
    
}
