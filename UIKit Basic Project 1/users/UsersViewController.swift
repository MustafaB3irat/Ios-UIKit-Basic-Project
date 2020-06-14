//
//  ViewController.swift
//  UIKit Basic Project 1
//
//  Created by Asal Macbook 1 on 17/05/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView! {
        
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var usersViewModel: UsersViewModel = UsersViewModel(usersRequest: ApiUsersRequest())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.frame = view.bounds
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        fetchUsers()
        initSearchBarController()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserDetailsViewController {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                let user = self.usersViewModel.filteredUsers[selectedIndex.row]
                destination.user = user
            }
        }
    }
    
    
    private func fetchUsers() {
        usersViewModel.fetchUsers { [weak self] response in
            DispatchQueue.main.async {[weak self] in
                switch response {
                case .success(_):
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
    
    private func initSearchBarController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
}

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {(_,_, completionHandler) in
            self.usersViewModel.filteredUsers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersViewModel.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as? UsersCell
        cell?.user = self.usersViewModel.filteredUsers[indexPath.row]
        return cell ?? UITableViewCell()
    }
}

extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.usersViewModel.filterUsers(username: searchController.searchBar.text)
        self.tableView.reloadData()
    }
}
