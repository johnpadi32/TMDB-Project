//
//  HeroHeaderView.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

protocol HeroHeaderViewDelegate: AnyObject {
    func didTapPreview()
    func didTapDownload()
}

class HeroHeaderView: UIView {
    
    //MARK: - Properties
            
    weak var delegate: HeroHeaderViewDelegate?
    
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
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More info", for: .normal)
        button.setTitleColor(UIColor.lightBlueColorButton, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.5647826195, green: 0.8065228462, blue: 0.6325702071, alpha: 1)
        button.layer.borderWidth = 1.8
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleShowPreview), for: .touchUpInside)
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.lightGreenColorButton, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.7061370015, blue: 0.893964231, alpha: 1)
        button.layer.borderWidth = 1.8
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleDownloadMovie), for: .touchUpInside)
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
        stack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingBottom: 25, paddingRight: 20, height: 45)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Actions
    
    @objc func handleShowPreview() {
        delegate?.didTapPreview()
    }
    
    @objc func handleDownloadMovie() {
        delegate?.didTapDownload()
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }

        heroImageView.sd_setImage(with: url, completed: nil)
    }
}
