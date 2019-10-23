//
//  UILocalizable.swift
//  Global
//
//  Created by Jacob on 11/23/18.
//  Copyright © 2018 PHDV Asia. All rights reserved.
//

import UIKit

// MARK: Localizable
public protocol Localizable {
  var autoLocalized: String { get }
}

extension String: Localizable {
  public var autoLocalized: String {
    guard let bundle = Bundle.main.path(forResource: "en", ofType: "lproj") else {
      return NSLocalizedString(self, comment: "")
    }
    
    let langBundle = Bundle(path: bundle)
    return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: "")
  }
}

// MARK: XIBLocalizable
public protocol xibLocalizable {
  var localizedKey: String? { get set }
}

public protocol xibMultiLocalizable {
  var localizedKeys: String? { get set }
}

extension UILabel: xibLocalizable {
  @IBInspectable public var localizedKey: String? {
    get { return nil }
    set(key) {
      text = key?.autoLocalized
    }
  }
}

extension UIButton: xibLocalizable {
  @IBInspectable public var localizedKey: String? {
    get { return nil }
    set(key) {
      setTitle(key?.autoLocalized, for: .normal)
    }
  }
}

extension UISegmentedControl: xibMultiLocalizable {
  @IBInspectable public var localizedKeys: String? {
    get { return nil }
    set(keys) {
      guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else { return }
      for (index, title) in keys.enumerated() {
        setTitle(title.autoLocalized, forSegmentAt: index)
      }
    }
  }
}
