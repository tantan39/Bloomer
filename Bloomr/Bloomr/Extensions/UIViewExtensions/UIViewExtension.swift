//
//  UIViewExtension.swift
//  Bloomr
//
//  Created by Tan Tan on 8/2/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

public extension UIView {
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    class func loadFromNib<T: UIView>() -> T {
        let nibName = "\(self)".split { $0 == "." }.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! T
    }
    
    class func getNib() -> UINib? {
        let bundle = Bundle.init(for: self.classForCoder())
        return UINib(nibName: self.nibName(), bundle: bundle)
    }
    
    private static func nibName() -> String {
        let nameSpaceClassName = NSStringFromClass(self)
        let className = nameSpaceClassName.components(separatedBy: ".").last! as String
        return className
    }
    
    func border(borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: UIColor) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func circleBorder() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
    func removeBorder() {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func animate(withTransform transforms: CGAffineTransform, duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, springWithDamping: CGFloat = 0.20, springVelocity: CGFloat = 6.0, options: UIView.AnimationOptions = .allowUserInteraction) {
        self.transform = transforms
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: springWithDamping,
                       initialSpringVelocity: springVelocity,
                       options: options,
                       animations: {
                        self.transform = CGAffineTransform.identity
        }, completion: nil
        )
    }
}

// MARK: - Shadow
extension UIView {
    public func addShadow(offSet: CGSize = CGSize(width: 1, height: 1), radius: CGFloat = 1, opactity: Float = 0.5, shadowColor: UIColor = UIColor.black) {
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opactity
        self.layer.shadowColor = shadowColor.cgColor
    }
}

// MARK: - Constraints
extension UIView {
    
    public func deactivateAllConstraints() {
        self.constraints.forEach { (constraint) in
            constraint.isActive = false
        }
    }
    
    public func constraint(withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == withIdentifier }.first
    }
}

// MARK: - Hanlde loading indicator
extension UIView {
    
    static let indicatorLoadingViewTag = 112233 // Just a number to define the activity view in the view's hierarchy
//    static let delayTime = 0.3 // Need small delay time in the case request is completed too fast to avoid blinked
    
    public func startLoading(useDefaultIndicator: Bool? = false, disableInteraction: Bool? = true) {
        
        if let useDefaultIndicator = useDefaultIndicator, useDefaultIndicator {
            // Make sure there's no indicator showing
            let thereIsNoIndicator = self.subviews.allSatisfy({ (view) in
                (view.tag != UIView.indicatorLoadingViewTag && !(view is UIActivityIndicatorView))
            })
            guard thereIsNoIndicator else {
                return
            }
            
            let indicator = UIActivityIndicatorView.init(style: .gray)
            indicator.hidesWhenStopped = true
            indicator.tag = UIView.indicatorLoadingViewTag
            
            self.addSubview(indicator)
            self.bringSubviewToFront(indicator)
            indicator.snp.makeConstraints { (maker) in
                maker.center.equalTo(self)
            }
            
            if let disableInteraction = disableInteraction {
                self.isUserInteractionEnabled = !disableInteraction
            } else {
                self.isUserInteractionEnabled = false
            }
            indicator.startAnimating()
            
        } 
    }
    
    public func stopLoading() {
        
        if let indicator = self.subviews.first(where: { (view) in
            (view.tag == UIView.indicatorLoadingViewTag)
        }) {
            if let theIndicator = indicator as? UIActivityIndicatorView {
                theIndicator.stopAnimating()
            }
            
            self.isUserInteractionEnabled = true
            indicator.removeFromSuperview()
        }
    }
}

// MARK: Check point inside subviews
public extension UIView {
    func checkPointInsideSubview(point: CGPoint, event: UIEvent?) -> Bool {
        for subview in self.subviews {
            let convertPoint = self.convert(point, to: subview)
            if subview.point(inside: convertPoint, with: event) {
                return true
            }
        }
        return false
    }
}
extension UIView {
    class public func loadXib<T>(type: T.Type) -> T {
        let nameString = String(describing: self)
        let bundle = Bundle(for: self)
        let view = bundle.loadNibNamed(nameString, owner: self, options: nil)?.first
        return view as! T
    }
}
// MARK: - Get current bundle
extension UIView {
    
    public func currentBundle() -> Bundle {
        return Bundle.init(for: self.classForCoder)
    }
}

// MARK: - Geometric
extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    public var width: CGFloat {
        get {
            return self.bounds.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return self.bounds.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}

public extension UIView {
    func rotate(_ angleRad: CGFloat, anchorPoint: CGPoint) {
        let transform = self.transform.rotated(by: angleRad)
        self.transform = transform
    }
}

public extension UIView {
    private struct AnimationRepeat {
        static var isRepeatAnimation = "isRepeatAnimation"
        static var isStartAnimation = "isStartAnimation"
        static var isCompleteOneRound = "isCompleteOneRound"
    }
    var isRepeatAnimation: Bool {
        get { return objc_getAssociatedObject(self, &AnimationRepeat.isRepeatAnimation) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AnimationRepeat.isRepeatAnimation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var isStartAnimation: Bool {
        get { return objc_getAssociatedObject(self, &AnimationRepeat.isStartAnimation) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AnimationRepeat.isStartAnimation, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    var isCompleteOneRound: Bool {
        get { return objc_getAssociatedObject(self, &AnimationRepeat.isCompleteOneRound) as? Bool ?? true }
        set { objc_setAssociatedObject(self, &AnimationRepeat.isCompleteOneRound, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func animationRotate360DegreesStart(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil, isRecursive: Bool = false) {
        if !isRecursive {
            isRepeatAnimation = true
        }
        if !isRecursive &&  isStartAnimation {
            return
        }
        isStartAnimation = true
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.transform = self.transform.rotated(by: CGFloat(Double.pi))
            self.alpha = 1
        }) { _ in
            self.isCompleteOneRound = !self.isCompleteOneRound
            if self.isRepeatAnimation {
                self.animationRotate360DegreesStart(duration: duration, completionDelegate: completionDelegate, isRecursive: true)
            } else {
                self.isStartAnimation = false
                if self.isCompleteOneRound {
                    UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                        self.transform = self.transform.rotated(by: CGFloat(Double.pi))
                        self.alpha = 0
                    })
                } else {
                    UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                        self.alpha = 0
                    })
                }
            }
        }
    }
    func animationRotate360DegreesStop() {
        self.isRepeatAnimation = false
    }
    
    func rotate(fromValue: Double, toValue: Float, duration: Double = 1) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        self.layer.add(animation, forKey: nil)
    }
}

// MARK: - Recursive to get supperview/subview
public extension UIView {
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }
    
    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
}

// MARK: Check Semantic Content Attribute
public extension UIView {
    class func isSemanticContentAttributeRTL() -> Bool {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
}
