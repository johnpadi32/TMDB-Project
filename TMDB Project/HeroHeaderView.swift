//
//  HeroHeaderView.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

class HeroHeaderView: UIView {
    
    //MARK: - Properties
    
    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "heroImage")
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        heroImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
