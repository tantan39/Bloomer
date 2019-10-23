//
//  UITableViewExtension.swift
//  PizzaHutCore
//
//  Created by Huỳnh Công Thái on 1/9/19.
//  Copyright © 2019 PHDV Asia. All rights reserved.
//

import UIKit

public extension UITableView {
    
    /// Set table header view & add Auto layout.
    func setTableHeaderView(headerView: UIView) {
        // Set first.
        self.tableHeaderView = headerView
        
        // Then setup AutoLayout.
        headerView.snp.makeConstraints { (make) in
            make.top.centerX.width.equalTo(self)
        }
    }
    
    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = self.tableHeaderView else { return }
        
        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()
        
        // ***Trigger table view to know that header should be updated.
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }
}

// MARK: Extension for keeping offset after reloading
public extension UITableView {
    func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
    
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: max(0, sections-1))
        if (rows > 0 && sections > 0) {
            self.scrollToRow(at: IndexPath.init(row: (rows-1), section: (sections-1)), at: .bottom, animated: animated)
        }
    }
    
    func scrollToTop(animated: Bool = true) {
        self.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: animated)
    }
}
