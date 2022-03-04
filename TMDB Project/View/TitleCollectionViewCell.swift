//
//  TitleCollectionViewCell.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    private let posterImageview: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImageview)
        posterImageview.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Actions
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        
        posterImageview.sd_setImage(with: url, completed: nil)
    }
}
