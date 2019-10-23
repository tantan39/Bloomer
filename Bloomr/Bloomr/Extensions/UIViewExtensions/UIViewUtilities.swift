import UIKit

public struct BorderSide: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top = BorderSide(rawValue: 1)
    public static let left = BorderSide(rawValue: 2)
    public static let bottom = BorderSide(rawValue: 4)
    public static let right = BorderSide(rawValue: 8)
    public static let all: BorderSide = [.top, .left, .right, .bottom]
}

public extension UIView {
    func findSuperviewWithType<T: UIView>(_ type: T.Type) -> T? {
        if let superview = self.superview {
            if let match = superview as? T {
                return match
            } else {
               return superview.findSuperviewWithType(type)
            }
        } else {
            return nil
        }
    }
    
    func findTableViewIndexPath() -> IndexPath? {
        guard let cell = findSuperviewWithType(UITableViewCell.self),
            let tableView = findSuperviewWithType(UITableView.self) else { return nil }
        
        return tableView.indexPath(for: cell)
    }
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, rect: bounds, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat, borderSide: BorderSide = .all) {
        var rect = bounds
        
        var height = rect.height
        if !borderSide.contains(.bottom) {
//            rect.height += borderWidth
            height += borderWidth
        }
        
        if !borderSide.contains(.top) {
            rect.top -= borderWidth
//            rect.height += borderWidth
            height += borderWidth
        }
        
        let newRect = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: height))
        let mask = _round(corners: corners, rect: newRect, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        round(corners: .allCorners, radius: radius, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    func getRidOfRoundedBorders() {
        guard let borderLayer = associatedObject(self, key: &borderLayerKey, initialiser: { () -> CAShapeLayer? in
            return nil
        }) else { return }
        
        borderLayer.removeFromSuperlayer()
    }
}

private var borderLayerKey: UInt8 = 1

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, rect: CGRect, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        
        guard let borderLayer = associatedObject(self, key: &borderLayerKey, initialiser: { () -> CAShapeLayer in
            return CAShapeLayer()
        }) else { return }
        
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.masksToBounds = true
        layer.addSublayer(borderLayer)
    }
}

public extension UIView {
    func addshadow(top: Bool,
                          left: Bool,
                          bottom: Bool,
                          right: Bool,
                          shadowRadius: CGFloat = 2.0,
                          shadowColor: UIColor,
                          shadowOffset: CGSize) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset // CGSize(width: 0.0, height: -1)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.5
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y-5))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight + 5))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight + 5))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y-5))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    func addshadowToLeftAndRightSide(
        shadowRadius: CGFloat = 2.0,
        shadowColor: UIColor,
        shadowOffset: CGSize,
        addedOffset: CGFloat = 0.0,
        shadowOpacity: Float = 0.5) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset // CGSize(width: 0.0, height: -1)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        
        let path = UIBezierPath()
        let x: CGFloat = 0
        var y: CGFloat = 0
        let viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        y+=(shadowRadius+1)
        viewHeight-=(shadowRadius+1)
        
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y-addedOffset))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight + addedOffset))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight + addedOffset))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y-addedOffset))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}
