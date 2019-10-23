//
//  SegmentView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class SegmentView: BaseView {
    
    lazy var timeSegmentControl: GLXSegmentedControl = {
        let appearance = GLXSegmentAppearance()
        appearance.segmentOnSelectionColor = .baby_blue
        appearance.segmentOffSelectionColor = .white
        appearance.titleOnSelectionFont = .fromType(.primary(.medium, .h3))
        appearance.titleOffSelectionFont = .fromType(.primary(.medium, .h3))
        appearance.titleOnSelectionColor = UIColor.white
        appearance.titleOffSelectionColor = .black
        appearance.dividerColor = .clear
        appearance.dividerWidth = 0
        
        let segment = GLXSegmentedControl(frame: .zero, segmentAppearance: appearance)
        segment.layer.borderWidth = 1
        segment.layer.borderColor = UIColor.baby_blue.cgColor
        segment.layer.cornerRadius = 5.0
        segment.organiseMode = .horizontal
        segment.addSegment(withTitle: "Date".localized().uppercased(), onSelectionImage: nil, offSelectionImage: nil)
        segment.addSegment(withTitle: "Week".localized().uppercased(), onSelectionImage: nil, offSelectionImage: nil)
        segment.addSegment(withTitle: "Month".localized().uppercased(), onSelectionImage: nil, offSelectionImage: nil)
        segment.addSegment(withTitle: "Year".localized().uppercased(), onSelectionImage: nil, offSelectionImage: nil)
        return segment
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        setupSegmentControl()
    }
    
    private func setupSegmentControl() {
        self.addSubview(timeSegmentControl)
        self.timeSegmentControl.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            maker.top.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
            maker.bottom.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
        }
    }
}
