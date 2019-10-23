//
//  UINavigationExtension.swift
//  PizzaHutCore
//
//  Created by Huỳnh Công Thái on 1/10/19.
//  Copyright © 2019 PHDV Asia. All rights reserved.
//

import UIKit
import Foundation

extension UINavigationController {
    public func popToViewControllerType(_ type: UIViewController.Type, animated: Bool) {
        let vc = self.viewControllers.filter {return $0.isKind(of: type)}.first
        if let vc = vc { self.popToViewController(vc, animated: true) }
    }
}
