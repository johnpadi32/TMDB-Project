//
//  SearchResultsController.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

protocol SearchResultsViewcontrollerDelegate: AnyObject {
    func SearchResultsControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

private let identifer = "TitleTableViewCell"

class SearchResultsController: UIViewController {
    
    //MARK: - Properties
    
    public var titles: [Title] = [Title]()
    public weak var delegate: SearchResultsViewcontrollerDelegate?

    public let searchResultsCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: identifer)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        view.backgroundColor = .black
        
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
}

//MARK: - UICollectionViewDataSource

extension SearchResultsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifer, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SearchResultsController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        APICaller.shared.getMovie(with: title.original_title ?? "") { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.SearchResultsControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
