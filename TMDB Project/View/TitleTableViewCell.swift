//
//  TitleTableViewCell.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let titlePosterImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 3
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        
        addSubview(titlePosterImageView)
        titlePosterImageView.setDimensions(height: 145, width: 100)
        titlePosterImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [titleLable, overviewLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        addSubview(stack)
        stack.centerY(inView: titlePosterImageView, leftAnchor: titlePosterImageView.rightAnchor, paddingLeft: 8)
        stack.anchor(right: rightAnchor,paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Actions
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        titlePosterImageView.sd_setImage(with: url, completed: nil)
        titleLable.text = model.titleName
        overviewLabel.text = model.overview
    }
}
