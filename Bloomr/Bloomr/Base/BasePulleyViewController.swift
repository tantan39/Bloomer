//
//  BasePulleyViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

open class BasePulleyViewController: BaseViewController {
    
    var dimView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.secondary1
        view.alpha = 0.0
        return view
    }()
    var shadowView = ShadowableView()
    
    public var mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
//        view.backgroundColor = UIColor.background2
        return view
    }()
    
    public var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
//        view.backgroundColor = UIColor.background2
        return view
    }()
    
    public var topDragableView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2.5
//        view.backgroundColor = UIColor.secondary3
        return view
    }()
    
    private var isSlideUp = true
    private var containerCurrentTopPadding: CGFloat = 32
    public var containerTopPadding: CGFloat = 48
    private var miniumTopPadding: CGFloat = 48
    private var heightAvaliable: CGFloat = 0.0
    private var containerMaxHeight: CGFloat = 0
    private var dimViewMaxAlpha: CGFloat = 0.8
    
    // Callbacks
    public var willDismissed: (() -> Void)?
    
    public override init() {
        super.init()
        self.modalPresentationStyle = .overFullScreen
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.dimView.alpha = 0
        containerMaxHeight = UIScreen.main.bounds.height - self.containerTopPadding
        self.addTarget()
    }
    
    override open func setupUIComponents() {
        self.containerCurrentTopPadding = UIScreen.main.bounds.height
        super.setupUIComponents()
        self.setupView()
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainView.snp.updateConstraints { (update) in
            update.top.equalTo(self.containerTopPadding)
        }
        UIView.animate(withDuration: 0.35, animations: {
            self.dimView.alpha = 0.8
            self.view.layoutIfNeeded()
        }) { (_) in
            self.containerCurrentTopPadding = self.containerTopPadding
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let willDismissed = self.willDismissed {
            willDismissed()
        }
    }
    
    private func setupDefaultData() {
        self.heightAvaliable = UIScreen.main.bounds.height - CGFloat(containerTopPadding)
    }
    
    private func setupView() {
        self.view.addSubview(self.dimView)
        self.view.addSubview(self.shadowView)
        self.view.addSubview(self.mainView)
        self.mainView.addSubview(self.topDragableView)
        self.mainView.addSubview(self.containerView)
        self.dimView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(self.view)
        }
        self.mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containerCurrentTopPadding)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(5)
        }
        self.shadowView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.left.right.equalTo(self.mainView)
        }
        self.topDragableView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(38)
            make.height.equalTo(5)
        }
        self.containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topDragableView.snp.bottom).offset(10)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

private extension BasePulleyViewController {
    func addTarget() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(gesture:)))
        self.mainView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer()
        self.dimView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mainView.snp.updateConstraints { (update) in
                update.top.equalTo(UIScreen.main.bounds.height)
            }
            
            UIView.animate(withDuration: 0.35, animations: {
                self.dimView.alpha = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                self.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        var transform = self.mainView.transform
        transform.tx = 0
        let velocity = gesture.velocity(in: self.view)
        switch gesture.state {
        case .began:
            print("Began.")
            
        case .changed:
            if(velocity.y < 0) {
                self.isSlideUp = true
            }
            if(velocity.y > 0) {
                self.isSlideUp = false
            }
            let tempY = transform.ty + translation.y
            self.containerCurrentTopPadding += tempY
            print("Began. \(containerCurrentTopPadding)")
            self.mainView.snp.updateConstraints { (update) in
                update.top.equalTo(self.containerCurrentTopPadding)
            }
            UIView.animate(withDuration: 0.1) {
                self.setAlphaForDimViewWithHeigth(currentHeight: self.containerCurrentTopPadding)
                self.view.layoutIfNeeded()
            }
        case .ended:
            if(velocity.y < 0 || (velocity.y == 0 && isSlideUp == true)) {
                self.isSlideUp = true
                self.containerCurrentTopPadding = self.containerTopPadding
                self.mainView.snp.updateConstraints { (update) in
                    update.top.equalTo(self.containerTopPadding)
                }
            } else {
                self.isSlideUp = false
                self.containerCurrentTopPadding = UIScreen.main.bounds.height - self.containerTopPadding
                self.mainView.snp.updateConstraints { (update) in
                    update.top.equalTo(UIScreen.main.bounds.height)
                }
            }
            UIView.animate(withDuration: 0.35, animations: {
                self.dimView.alpha = CGFloat(self.isSlideUp ? self.dimViewMaxAlpha : 0)
                self.view.layoutIfNeeded()
            }) { (_) in
                if !self.isSlideUp {
                    self.dismiss(animated: false)
                }
            }
        case .cancelled:
            print("Cancelled")
            
        default:
            print("Default")
        }
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    private func setAlphaForDimViewWithHeigth(currentHeight: CGFloat) {
        var alpha =  1.0 - dimViewMaxAlpha*currentHeight/self.containerMaxHeight
        if alpha > dimViewMaxAlpha {
            alpha = dimViewMaxAlpha
        }
        self.dimView.alpha = alpha
    }
}

// MARK: - Support Method
extension BasePulleyViewController {
    public func updateTopPaddingWithOffset(offset: CGFloat) {
        
        let topDragableViewHeight = topDragableView.frame.top + topDragableView.bounds.height + Dimension.shared.mediumVerticalMargin
        
        let padding = offset > 0 ? ScreenSize.SCREEN_HEIGHT / 2 - offset : ScreenSize.SCREEN_HEIGHT / 2
        
        self.containerTopPadding = padding - topDragableViewHeight < miniumTopPadding ? miniumTopPadding : padding - topDragableViewHeight
        
        self.containerCurrentTopPadding = self.containerTopPadding
        self.mainView.snp.updateConstraints { (update) in
            update.top.equalTo(self.containerTopPadding)
        }
    }
}
