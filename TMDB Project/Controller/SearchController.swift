//
//  SearchResultsController.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

protocol SearchControllerDelegate: AnyObject {
    func SearchControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

private let identifier = "TitleCollectionViewCell"

class SearchController: UIViewController, SearchResultsControllerDelegate {
    
    //MARK: - properties
    
    public var titles: [Title] = [Title]()
    
    weak var delegate: SearchControllerDelegate?
    
    public let discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsController())
        controller.searchBar.placeholder = "Search for a Movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureCollectionView()
        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverCollectionView.frame = view.bounds
    }
    
    //MARK: - Helpers
    
    func configureNavBar() {
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .black
        title = "Explore"
        
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(handleDismiss))
    }
    
    func configureCollectionView() {
        view.addSubview(discoverCollectionView)
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        
        searchController.searchResultsUpdater = self
    }
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension SearchController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.title else { return }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self ] result in
            switch result {
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    let title = self?.titles[indexPath.row]
                    guard let titleOverview = title?.overview else { return }
                
                    
                    let viewMdeol = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                    self?.delegate?.SearchControllerDidTapItem(viewMdeol)
                }
                

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - SearchResultsViewController

extension SearchController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              
                let resultController = searchController.searchResultsController as? SearchResultsController else {
                    return
                }
        resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultTableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func SearchResultsControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
