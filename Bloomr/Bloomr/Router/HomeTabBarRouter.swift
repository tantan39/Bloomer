//
//  MainTabBarRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/9/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

struct HomeTabBarRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let tabBarViewController = HomeTabBarController()
        RoutingExecutor.navigate(from: root, to: tabBarViewController, transitionType: transitionType)
        return tabBarViewController
    }
}
