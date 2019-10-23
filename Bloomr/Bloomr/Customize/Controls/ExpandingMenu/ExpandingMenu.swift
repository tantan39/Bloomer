//
//  ExpandingMenu.swift
//  Bloomr
//
//  Created by Tan Tan on 8/19/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class ExpandingMenu: UIView {
    
    private var homeButton: ExpandingMenuItem?
    var homePoint: CGPoint {
        set {
            self.homeButton?.center = newValue
        }
        get {
            return CGPoint(x: 80, y: self.height/2)
        }
    }
    var homeButtonSize: CGSize?
    
    var itemSize: CGSize?
    
    var menuItems: [ExpandingMenuItem]? {
        didSet {
            configMenuItems()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .init(white: 1, alpha: 0.6)
        configHomeButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configHomeButton() {
        self.homeButton = ExpandingMenuItem(title: "...", image: UIImage(named: "icon_menu_give_flower"), size: CGSize(width: 35, height: 35))
        self.homeButton?.backgroundColor = .rouge
        self.addSubview(self.homeButton!)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.homeButton?.center =  self.homePoint
        }, completion: nil)
    }
    
    private func configMenuItems() {
        guard let menuItems = self.menuItems else { return }
        let angle: CGFloat = 0.0
        let distance: CGFloat = 10
        var lastItemOffset: CGFloat = self.homePoint.x
        var lastWidth: CGFloat = self.homeButton?.width ?? 0
        for (index, item) in menuItems.enumerated() {
            
            var pointX =  lastItemOffset + (CGFloat(cos(angle * CGFloat.pi/180)) * (item.width + distance) )
            pointX -= ((item.width - lastWidth) / 2)
            let pointY = self.homePoint.y + (CGFloat(sin(angle * CGFloat.pi/180)) * (item.width + distance) * CGFloat(index + 1))
            
            lastItemOffset = pointX
            lastWidth = item.width
            self.addSubview(item)
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                item.center = CGPoint(x: pointX, y: pointY)
            }, completion: nil)
            
        }
    }
    
}
