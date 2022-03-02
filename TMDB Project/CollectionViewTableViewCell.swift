//
//  CollectionViewTableViewCell.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
