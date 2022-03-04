//
//  ViewController.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

private let identifier = "CollectionViewTableViewCell"

class HomeController: UITableViewController {
    
    //MARK: - Properties
    
    private var randomTrendingMovies: Title?

    private var headerView: HeroHeaderView?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableview()
        configureHeroHeaderView()
    }
    
    //MARK: - Helpers
    
    func configureNavBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
                
//        navigationItem.titleView = UIImageView(image: UIImage(named: "TMDBLogo"))
        title = "TMDB"
        view.backgroundColor = .black

    }
    
    func configureTableview() {
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: identifier)

        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        tableView.tableHeaderView = headerView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(handleSearch))
    }
    
    //MARK: - Actions
    
    @objc func handleSearch() {
        let controller = SearchController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //MARK: - API
    
    func configureHeroHeaderView() {
        APICaller.shared.getPopularMovies { [weak self] result in
            switch result {
            case .success(let title):
                let selectedTitle = title.randomElement()
                self?.randomTrendingMovies = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? "", overview: selectedTitle?.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension HomeController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textColor = .white
        title.text = HomeSections(rawValue: section)?.description
        view.addSubview(title)
        title.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 16)

        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        switch indexPath.section {
            
        case HomeSections.TrendingMovies.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case HomeSections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case HomeSections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case HomeSections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case HomeSections.topRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
}


//MARK: - UITableViewDelegate

extension HomeController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaulOffSet = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaulOffSet
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
    }
}

extension HomeController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
