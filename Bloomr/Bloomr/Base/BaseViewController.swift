//
//  BaseViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit
import RxSwift

enum NavigationBarRightViewStyle {
    case upload
    case next
}

func classDomain<T>(_ object: T.Type) -> String {
    return String(describing: object)
}

public protocol BaseViewControllerDelegate: class {
    func backAction()
}

open class BaseViewController: UIViewController {

    // Rx Variables
    public let disposeBag = DisposeBag()
    public weak var baseDelegate: BaseViewControllerDelegate?
    
    private var customNavigationView: ContestNavigationBarView?
    var rightBarButton: UIBarButtonItem?
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open class func initFromDefaultXib() -> UIViewController {
        let className = NSStringFromClass(self) as NSString
        let nibName = className.pathExtension
        let bundle = Bundle.init(for: self.classForCoder())

        return self.init(nibName: nibName, bundle: bundle)
    }
    
    required override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = self.backBarButton()
        }
        self.initializeObjects()
        self.setupUIComponents()
        self.registerNotifications()
    }
    
    open func initializeObjects() {
        // Where variables, objects will be initialized
    }
    
    open func setupUIComponents() {
        // Where UI components will be polished
    }
    
    open func handleObservers() {
        
    }
    
    open func registerNotifications() {
        // Where notification observers are registered
    }
    
    open func refreshdata(object: Any?, completetion:((_ object: Any?) -> Void)?) {
        // use to child view controller update 
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension BaseViewController {
    class func controller<T: UIViewController>(from storyboard: String, storyboardID: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        if let identifier = storyboardID {
            return storyboard.instantiateViewController(withIdentifier: identifier) as! T
        }
        return storyboard.instantiateViewController(withIdentifier: classDomain(T.self)) as! T
    }
    
//    open func handle(_ error: Error) {
//        self.handle(error, onDismissAlert: nil)
//    }
//    
//    open func handle(_ error: Error, onDismissAlert: (() -> Void)?) {
//        AlertManager.shared.show(TextManager.warningText.localized(), message: error.localizedDescription, buttons: [Constant.alertDismissButtonTitle.localized()]) { (_, _) in
//            if let onDismissCallback = onDismissAlert {
//                onDismissCallback()
//            }
//        }
//    }

    open func backBarButton(overlayColor: UIColor? = nil) -> UIBarButtonItem {
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Dimension.shared.mediumVerticalMargin, bottom: 0, right: Dimension.shared.mediumVerticalMargin)
        button.addTarget(self, action: #selector(self.backOrDismiss), for: .touchUpInside)
        if let count = self.navigationController?.viewControllers.count, count > 1 {
            var image = UIImage(named: "back")!.withRenderingMode(.alwaysOriginal)
            if let overlayColor = overlayColor {
                image = image.tint(color: overlayColor) ?? UIImage()
            }
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
        } else {
            button.setTitle("Cancel".localized(), for: .normal)
            button.setTitleColor(.charcoal_grey, for: .normal)
            button.titleLabel?.font = .fromType(.primary(.regular, .h2))
        }

        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.snp.makeConstraints({ (maker) in
            maker.width.equalTo(44)
            maker.height.equalTo(44)
        })
        
        return barButtonItem
    }
    
    open func cancelBarButton(overlayColor: UIColor? = nil) -> UIBarButtonItem {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 32)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Dimension.shared.mediumVerticalMargin, bottom: 0, right: Dimension.shared.mediumVerticalMargin)
        button.addTarget(self, action: #selector(self.backOrDismiss), for: .touchUpInside)
        button.setTitle("Cancel".localized(), for: .normal)
        if let overlayColor = overlayColor {
            button.setTitleColor(overlayColor, for: .normal)
        } else {
            button.setTitleColor(.rouge, for: .normal)
        }
        
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.fromType(.primary(.regular, .h2))
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        let barButtonItem = UIBarButtonItem(customView: button)
        
        return barButtonItem
    }
    
    open func closeBarButton(overlayColor: UIColor? = nil) -> UIBarButtonItem {
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Dimension.shared.mediumVerticalMargin, bottom: 0, right: Dimension.shared.mediumVerticalMargin)
        button.addTarget(self, action: #selector(self.backOrDismiss), for: .touchUpInside)
        var image = UIImage(named: "close")?.withRenderingMode(.alwaysOriginal)
        if let overlayColor = overlayColor {
            image = image?.tint(color: overlayColor)
        }
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.snp.makeConstraints({ (maker) in
            maker.width.equalTo(44)
            maker.height.equalTo(44)
        })
        
        return barButtonItem
    }
    
    open func backOrCloseBarButton() -> UIBarButtonItem {
        if let count = self.navigationController?.viewControllers.count, count > 1 {
            return self.backBarButton()
        } else {
            return self.closeBarButton()
        }
    }
    
    @objc open func backOrDismiss() {
        if let count = self.navigationController?.viewControllers.count, count > 1 {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: {
                logDebug("Dismiss viewcontroller: \(self.classForCoder)")
            })
        }
    }
    
    func showNavigationBarRightViewStyle(_ style: NavigationBarRightViewStyle) {
        switch style {
        case .upload:
            customNavigationView = ContestNavigationBarView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
            
            let rightView = UIBarButtonItem(customView: customNavigationView!)
            self.navigationItem.rightBarButtonItem = rightView
        case .next:
            rightBarButton = UIBarButtonItem(title: "Next".localized(), style: .plain, target: self, action: nil)
            let attributes = [NSAttributedString.Key.font: UIFont.fromType(.primary(.regular, .h2)),
                              NSAttributedString.Key.foregroundColor: UIColor.soft_blue]
            rightBarButton?.setTitleTextAttributes(attributes, for: .normal)
            rightBarButton?.setTitleTextAttributes(attributes, for: .highlighted)
            rightBarButton?.setTitleTextAttributes(attributes, for: .disabled)

            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        self.customNavigationView?.uploadButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            guard let topViewController = UIViewController.topMostViewController() else { return }
            let galleryViewController = GalleryViewController()
            RoutingExecutor.navigate(from: topViewController, to: galleryViewController.embbedToNavigationController(), transitionType: .present)
        }).disposed(by: self.disposeBag)
    }
    
}
