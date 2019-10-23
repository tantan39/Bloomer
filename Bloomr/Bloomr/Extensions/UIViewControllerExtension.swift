//
//  UIViewControllerExtension.swift
//  Bloomr
//
//  Created by Jacob on 11/14/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit
import Moya

extension UIViewController {
    
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
    
    func className() -> String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
}

// MARK: - Add/remove child controllers
extension UIViewController {
    
    // Add a child view controller, its whole view is embeded in the containerView
    func addController(controller: UIViewController, containerView: UIView) {
        if let parent = controller.parent, parent == self {
            return
        }
        addChild(controller)
        controller.view.frame = CGRect.init(origin: .zero, size: containerView.frame.size)
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    // To remove the current child view controller
    func removeController(controller: UIViewController, containerView: UIView) {
        controller.willMove(toParent: nil)
        controller.removeFromParent()
        controller.view.removeFromSuperview()
        controller.didMove(toParent: nil)
    }
    
    func embbedToNavigationController() -> BaseNavigationController {
        let navigationController = BaseNavigationController(rootViewController: self)
        return navigationController
    }
}

// MARK: - Find top most controller
extension UIViewController {
    
    class func topMostViewController() -> UIViewController? {
        return UIViewController.topViewControllerForRoot(rootViewController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    class func topViewControllerForRoot(rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        if rootViewController is UINavigationController {
            let navigationController: UINavigationController = rootViewController as! UINavigationController
            return UIViewController.topViewControllerForRoot(rootViewController: navigationController.viewControllers.last)
            
        } else if rootViewController is UITabBarController {
            let tabBarController: UITabBarController = rootViewController as! UITabBarController
            return UIViewController.topViewControllerForRoot(rootViewController: tabBarController.selectedViewController)
            
        } else if rootViewController.presentedViewController != nil {
            return UIViewController.topViewControllerForRoot(rootViewController: rootViewController.presentedViewController)
        } else {
            return rootViewController
        }
    }
}

// MARK: - Handle error
extension UIViewController {
    func handle(_ error: Error) {

    }
    
    func handle(_ error: Error, onDismissAlert: (() -> Void)?) {
    }
}

extension UIViewController {
    public func isModal() -> Bool {
        if self.presentingViewController == self {
            return true
        }
        if(self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) {
            return true
        }
        if(self.tabBarController?.presentingViewController?.isKind(of: UITabBarController.self) ?? false) {
            return true
        }
        return false
    }
}
