//
//  SearchResultsController.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

private let identifier = "TitleTableViewCell"

protocol SearchResultsControllerDelegate: AnyObject {
    func SearchResultsControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsController: UIViewController {
    
    //MARK: - Properties
    
    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultsControllerDelegate?
    
    public let searchResultTableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: identifier)
        table.backgroundColor = .black
        return table
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultTableView.frame = view.bounds
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .black
        
        view.addSubview(searchResultTableView)
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
}

//MARK: - UITableViewDataSource

extension SearchResultsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_title ?? title.title ?? "Unknow name", posterURL: title.poster_path ?? "", overview: title.overview ?? "")
        cell.configure(with: model)
        
        return cell
    }
}

//MARK: - UItableViewDelegate

extension SearchResultsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
