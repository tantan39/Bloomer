//
//  GiveFlowerMenuView.swift
//  Bloomr
//
//  Created by Tan Tan on 8/18/19.
//  Copyright © 2019 phdv. All rights reserved.
//

class GiveFlowerMenuView: BaseView {
    lazy var awesomeMenu: AwesomeMenu = {
        let menuItem1 = AwesomeMenuItem(image: UIImage(named: "icon_menu_give_flower"), highlightedImage: UIImage(named: "icon_menu_give_flower"), text: "100")
        let menuItem2 = AwesomeMenuItem(image: UIImage(named: "icon_menu_give_flower"), highlightedImage: UIImage(named: "icon_menu_give_flower"), text: "200")
        let menuItem3 = AwesomeMenuItem(image: UIImage(named: "icon_menu_give_flower"), highlightedImage: UIImage(named: "icon_menu_give_flower"), text: "300")
        let menuItem4 = AwesomeMenuItem(image: UIImage(named: "icon_menu_give_flower"), highlightedImage: UIImage(named: "icon_menu_give_flower"), text: "400")
        let menu = AwesomeMenu(frame: self.frame, start: menuItem1, optionMenus: [menuItem2!, menuItem3!, menuItem4!], isCell: true)
        menu?.startPoint = CGPoint(x: self.x + 100, y: self.y)
        menu?.menuWholeAngle = 0
        menu?.farRadius = 60.0
        menu?.endRadius = 50.0
        menu?.nearRadius = 40.0
        menu?.animationDuration = 0.7
        menu?.rotateAngle = 5.04
        menu?.isExpanding = true
        return menu!
    }()
    
    override func setupUIComponents() {
        super.setupUIComponents()
        
        self.backgroundColor = .orange
        
//        setupAwesomeMenu()
    }
    
    private func setupAwesomeMenu() {
        self.layoutIfNeeded()
        self.addSubview(self.awesomeMenu)
        self.awesomeMenu.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
