//
//  BaseTabbarViewController.swift
//  Bloomr
//
//  Created by Tan Tan on 8/8/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    let homeTabBarSize = CGSize(width: 42, height: 80)
    
    lazy var homeTabBar: HomeTabBarView = {
        let view = HomeTabBarView(frame: CGRect(x: (self.tabBar.bounds.width - homeTabBarSize.width)/2, y: -15, width: homeTabBarSize.width, height: homeTabBarSize.height))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = HomeContestViewController()
        let view2 = ViewController()
        let view3 = ViewController()
        let view4 = ViewController()
        let view5 = ViewController()
        
        self.viewControllers = [view1.embbedToNavigationController(), view2.embbedToNavigationController(), view3.embbedToNavigationController(), view4.embbedToNavigationController(), view5.embbedToNavigationController()]
        
        view1.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_contest_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_contest_active")?.withRenderingMode(.alwaysOriginal))
        
        view2.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_mybloomer_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_mybloomer_active")?.withRenderingMode(.alwaysOriginal))
        view3.tabBarItem = UITabBarItem()

        view4.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_chat_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_chat_active")?.withRenderingMode(.alwaysOriginal))
        
        view5.tabBarItem = ESTabBarItem.init(ESTabBarItemContentView(), title: nil,
                                             image: UIImage(named: "icon_tabbar_me_normal")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "icon_tabbar_me_active")?.withRenderingMode(.alwaysOriginal))
        
        self.tabBar.setValue(true, forKey: "_hidesShadow")
        self.tabBar.addSubview(homeTabBar)
    }
}
