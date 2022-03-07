//
//  ViewController.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import UIKit

enum Section: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case topRated = 4
}

private let reuseIdentifier = "CollectionViewTableViewCell"

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    let sectionTitles: [String] = ["Trending Movie", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    private var randomTrendingMoview: Title?
    
    private var TitlePreview: TitlePreviewViewModel?
    
    private var headerView: HeroHeaderView?
    
    private let homeFeedView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        table.backgroundColor = .black
        return table
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        configureHeroHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedView.frame = view.bounds
    }
    
    //MARK: - Helpers
    
    func configureNavBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = UIImageView(image: UIImage(named: "TMDBLogo"))
        navigationController?.navigationBar.tintColor = .white

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(handleSearchPressed)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line"), style: .done, target: self, action: nil)
        ]
    }
    
    func configureTableView() {
        view.backgroundColor = .black
        view.addSubview(homeFeedView)

        homeFeedView.delegate = self
        homeFeedView.dataSource = self
        
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 575))
        headerView?.delegate = self
        homeFeedView.tableHeaderView = headerView
    }
    
    func configureHeroHeaderView() {
        APICaller.shared.getPopularMovies { [weak self] result in
            switch result {
            case .success(let title):
                let selectedTile = title.randomElement()
                self?.randomTrendingMoview = selectedTile
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTile?.original_title ?? "", posterURL: selectedTile?.poster_path ?? "", overview: selectedTile?.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Actions
    
    @objc func handleSearchPressed() {
        print("Go to Search Controller")
        let controller = ExploreController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension HomeController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
                        
        case Section.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
                        
        case Section.topRated.rawValue:
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 80, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = sectionTitles[section]
        view.addSubview(title)
        title.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 16)

        return view
    }
}

//MARK: - UITableViewDatasource

extension HomeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffSet
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeController: CollectionViewTableViewCellDelegate {

    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            
            let controller = TitlePreviewController()
            controller.configure(with: viewModel)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        }
    }
}

extension HomeController: HeroHeaderViewDelegate {
    func didTapPreview() {
                
        guard let titleName = randomTrendingMoview?.original_title ?? randomTrendingMoview?.title else { return }

        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    
                    let controller = TitlePreviewController()
                    controller.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: self?.randomTrendingMoview?.overview ?? ""))
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    self?.headerView?.reloadInputViews()

                    self?.present(nav, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapDownload() {
        print("Download Movie")
    }
}
