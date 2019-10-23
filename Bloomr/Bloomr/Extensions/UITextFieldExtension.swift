//
//  UITextFieldExtension.swift
//  PizzaHutCore
//
//  Created by Xuan Thuong on 1/16/19.
//  Copyright © 2019 PHDV Asia. All rights reserved.
//

import UIKit

var key: Void?

class UITextFieldAdditions: NSObject {
    public var readonly: Bool = false
}

extension UITextField {
    public var readonly: Bool {
        get {
            return self.getAdditions().readonly
        }
        
        set {
            self.getAdditions().readonly = newValue
        }
    }
    
    private func getAdditions() -> UITextFieldAdditions {
        var additions = objc_getAssociatedObject(self, &key) as? UITextFieldAdditions
        if additions == nil {
            additions = UITextFieldAdditions()
            objc_setAssociatedObject(self, &key, additions!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return additions!
    }
    
    open override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if ((action == #selector(UIResponderStandardEditActions.paste(_:)) || (action == #selector(UIResponderStandardEditActions.cut(_:)))) && self.readonly) {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
    
}
