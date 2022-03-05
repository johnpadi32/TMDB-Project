//
//  HeroHeaderView.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

class HeroHeaderView: UIView {
    
    //MARK: - Properties
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "heroImage")
        return iv
    }()
    
    private let playButton: UIButton = {
       let button = UIButton()
        button.setTitle("More info", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        heroImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        addGradient()
        
        let stack = UIStackView(arrangedSubviews: [playButton, downloadButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingBottom: 25, paddingRight: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Actions
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }

        heroImageView.sd_setImage(with: url, completed: nil)
    }
}
