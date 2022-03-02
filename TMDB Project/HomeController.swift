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

    private var headerView: HeroHeaderView?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureUI()
        configureTableview()
    }
    
    //MARK: - Helpers
    
    func configureNavBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
//        navigationItem.titleView = UIImageView(image: UIImage(named: "TMDBLogo"))
        title = "TMDB"
    }

    func configureUI() {
        view.backgroundColor = .black
    }
    
    func configureTableview() {
        
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: identifier)

        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        tableView.tableHeaderView = headerView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: nil)

    }
}

//MARK: - UITableViewDataSource

extension HomeController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = HomeSections(rawValue: section)?.description
        view.addSubview(title)
        title.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 16)

        return view
    }
}


//MARK: - UITableViewDelegate

extension HomeController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
