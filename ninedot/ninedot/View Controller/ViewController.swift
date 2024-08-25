//
//  ViewController.swift
//  ninedot
//
//  Created by mohd shahid on 25/08/24.
import UIKit

// MARK: - ViewController

class ViewController: UIViewController {

    private var viewModel = ViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search fruits"
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.loadData()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "labelCell")
        tableView.register(CarouselCell.self, forCellReuseIdentifier: "carouselCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onCategoriesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onFilteredFruitsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableView DataSource & Delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.filteredFruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "carouselCell", for: indexPath) as? CarouselCell else {
                return UITableViewCell()
            }
            cell.categories = viewModel.categories
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
            cell.textLabel?.text = viewModel.filteredFruits[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? view.frame.height * 0.3 : 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView()
            headerView.backgroundColor = .white
            headerView.addSubview(searchBar)
            setupSearchBarConstraints(headerView: headerView)
            return headerView
        }
        return nil
    }
    
    private func setupSearchBarConstraints(headerView: UIView) {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : 0
    }
}

// MARK: - UISearchBar Delegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateFilteredFruits(with: searchText)
    }
}

// MARK: - CarouselCell Delegate

extension ViewController: CarouselCellDelegate {
    func didSelectCategory(_ category: Category) {
        viewModel.selectCategory(category)
    }
}
