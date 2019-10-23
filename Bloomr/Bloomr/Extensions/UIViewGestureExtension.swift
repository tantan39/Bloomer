//
//  UIViewGestureExtension.swift
//  iCondo
//
//  Created by James Nguyen on 5/10/19.
//  Copyright © 2019 James Nguyen. All rights reserved.
//

import UIKit

public extension UIView {
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "JamesNguyen"
        static var swipeUpGestureRecognizer = "SwipeUp"
        static var swipeDownGestureRecognizer = "SwipeDown"
        static var swipeLeftGestureRecognizer = "SwipeLeft"
        static var swipeRightGestureRecognizer = "RightSwipe"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set Computed Property Type To a Closure for TapGestureRecognizerAction
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // Set Computed Property Type To a Closure for SwipeUpGestureRecognizerAction
    fileprivate var swipeUpGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.swipeUpGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        get {
            let swipeUpGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.swipeUpGestureRecognizer) as? Action
            return swipeUpGestureRecognizerActionInstance
        }
    }
    
    // Set Computed Property Type To a Closure for SwipeDownGestureRecognizerAction
    fileprivate var swipeDownGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.swipeDownGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        get {
            let swipeDownGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.swipeDownGestureRecognizer) as? Action
            return swipeDownGestureRecognizerActionInstance
        }
    }
    
    // Set Computed Property Type To a Closure for SwipeLeftGestureRecognizerAction
    fileprivate var swipeLeftGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.swipeLeftGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        get {
            let swipeLeftGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.swipeLeftGestureRecognizer) as? Action
            return swipeLeftGestureRecognizerActionInstance
        }
    }
    
    
    // Set Computed Property Type To a Closure for SwipeRightGestureRecognizerAction
    fileprivate var swipeRightGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.swipeRightGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        get {
            let swipeRightGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.swipeRightGestureRecognizer) as? Action
            return swipeRightGestureRecognizerActionInstance
        }
    }
    
    //Add Tap Gesture Recognizer
    @objc func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //Add Swipe Left Gesture Recognizer
    @objc func addSwipeLeftGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.swipeLeftGestureRecognizerAction = action
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeftGesture))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //Add Swipe Right Gesture Recognizer
    @objc func addSwipeRightGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.swipeRightGestureRecognizerAction = action
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRightGesture))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //Add Swipe Up Gesture Recognizer
    @objc func addSwipeUpGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.swipeUpGestureRecognizerAction = action
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUpGesture))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.up
        self.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //Add Swipe Down Gesture Recognizer
    @objc func addSwipeDownGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.swipeDownGestureRecognizerAction = action
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGesture))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.down
        self.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //Handle Tap
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        }
    }
    
    //Handle Swipe Down
    @objc fileprivate func handleSwipeDownGesture(sender: UISwipeGestureRecognizer) {
        if let action = self.swipeDownGestureRecognizerAction {
            action?()
        }
    }
    
    //Handle Swipe Up
    @objc fileprivate func handleSwipeUpGesture(sender: UISwipeGestureRecognizer) {
        if let action = self.swipeUpGestureRecognizerAction {
            action?()
        }
    }
    
    //Handle Swipe Left
    @objc fileprivate func handleSwipeLeftGesture(sender: UISwipeGestureRecognizer) {
        if let action = self.swipeLeftGestureRecognizerAction {
            action?()
        }
    }
    
    //Handle Swipe Right
    @objc fileprivate func handleSwipeRightGesture(sender: UISwipeGestureRecognizer) {
        if let action = self.swipeRightGestureRecognizerAction {
            action?()
        }
    }
}
