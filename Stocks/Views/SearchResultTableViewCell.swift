//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 14.12.2023.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let identifire = "SearchResultTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
