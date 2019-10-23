//
//  Router.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

// Transition types
public enum TransitionType {
    // Presents the screen modally on top of the current viewController
    case present
    
    // Pushes the next screen to the rootViewController of current navigation
    case push
    
    // Replaces the key window's root view controller
    case changeRootController
}

/*
 The Router is a protocol that handles all screen transitions
 */
public protocol Router {
    
    /**
     Navigate from your current screen to a new route.
     
     - Parameters:
         + root: The root where the transition happens
         + destination: The destination where the transition ends
         + transition: The transition type that you want to use.
         + animated: Animate the transition or not.
         + completion: Completion handler.
     */
    @discardableResult
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)?) -> AnyObject?
}

extension Router {
    @discardableResult
    public func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        return self.navigate(from: root, transitionType: transitionType, animated: animated, completion: nil)
    }
}

open class RoutingExecutor {
    
    @discardableResult
    public static func navigate(from root: AnyScreen?, to destination: AnyScreen?, transitionType: TransitionType, animated: Bool = true, completion: (() -> Void)? = nil) -> AnyObject? {

        switch transitionType {
        case .present:
            if let root = root as? UIViewController,
               let destination = destination as? UIViewController {
                root.present(destination, animated: animated, completion: completion)
            } else {
                safelyFatalError("Both root and destination should be an instance or descendant of UIViewController!")
            }
            
        case .push:
            if let root = root as? UINavigationController,
                let destination = destination as? UIViewController {
                root.pushViewController(destination, animated: animated)
                if let theCompletion = completion {
                    theCompletion()
                }
            } else {
                safelyFatalError("Root should be an instance of UINavigationController & Destination should be an instance of UIViewController!")
            }
            
        case .changeRootController:
            guard let destination = destination as? UIViewController else {
                safelyFatalError("Destination should be an instance or descendants of UIViewController")
                return nil
            }
            
            guard let keyWindow = UIApplication.shared.keyWindow else {
                safelyFatalError("Root should be an instance of UIWindow")
                return nil
            }
            
            let duration = keyWindow.rootViewController == nil ? 0 : 0.35
            
            UIView.transition(with: keyWindow, duration: duration, options: .transitionCrossDissolve, animations: {
                keyWindow.rootViewController = destination
            }) { (_) in
                if let completion = completion {
                    completion()
                }
            }
        }
        
        return destination
    }
}
