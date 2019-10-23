//
//  CellExtension.swift
//  Bloomr
//
//  Created by Tan Tan on 8/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    class func cellIdentifier() -> String {
        return String(describing: self)
    }
    
    func cellIdentifier() -> String {
        return String(describing: self.classForCoder)
    }
    
    class func registerFor(_ collectionView: UICollectionView) {
        collectionView.register(self.getNib(), forCellWithReuseIdentifier: self.cellIdentifier())
    }
}

extension UICollectionReusableView {
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
}

open class TableViewCell: UITableViewCell {
    class open func cellIdentifier() -> String {
        return  String(describing: self)
    }
    
    class open func registerFor(_ tableView: UITableView) {
        tableView.register(self.getNib(), forCellReuseIdentifier: self.cellIdentifier())
    }
    
    class open func dequeue(_ tableView: UITableView, _ indexPath: IndexPath) -> TableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(), for: indexPath) as? TableViewCell
    }
    
    class open func dequeue(_ tableView: UITableView) -> TableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier()) as? TableViewCell
    }
    
    open var isSeparatorHidden: Bool {
        get {
            return self.separatorInset.right != 0
        }
        set {
            if newValue {
                self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
            } else {
                self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
}
