//
//  TitlePreviewController.swift
//  TMDB Project
//
//  Created by John Padilla on 3/3/22.
//

import UIKit
import WebKit

class TitlePreviewController: UIViewController {
    
    //MARK: - Properties
    
    public var titles: [Title] = [Title]()

    
    private let webView: WKWebView = {
       let wv = WKWebView()
        return wv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.lightGreenColorButton , for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.7061370015, blue: 0.893964231, alpha: 1)
        button.layer.borderWidth = 1.8
        button.layer.cornerRadius = 8
        button.setHeight(50)
        return button
    }()
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 200)
        
        let stack = UIStackView(arrangedSubviews: [downloadButton, titleLabel, overviewLabel])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: webView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
    }
    
    //MARK - Helpers
    
    func configureNavBar() {
        view.backgroundColor = .black

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .done, target: self, action: #selector(handleDismiss))
    }
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
}
