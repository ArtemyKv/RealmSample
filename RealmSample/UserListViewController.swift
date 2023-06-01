//
//  FirstViewController.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 25.05.2023.
//

import UIKit

class UserListViewController: UIViewController {
    
    let dataManager = UserListDataManager()
    
    var userListView: UserListView! {
        guard isViewLoaded else { return nil }
        return (view as! UserListView)
    }
    
    var tableView: UITableView {
        return userListView.tableView
    }
    
    var listAscending: Bool = true
    
    override func loadView() {
        let userListView = UserListView()
        self.view = userListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        setupBarButtons()
        dataManager.delegate = self
//        dataManager.deleteAll()
        dataManager.loadUsers()
        dataManager.setupObservers()
    }
    
    func setupBarButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [sortButton, addButton]
    }
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "New User", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
            textField.textAlignment = .left
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Age"
            textField.textAlignment = .left
            textField.keyboardType = .numberPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?[0].text,
                !name.isEmpty,
                let ageString = alert.textFields?[1].text,
                let age = Int(ageString)
            else { return }
            
            self?.dataManager.addUser(name: name, age: age)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc private func sortButtonTapped(_ sender: UIBarButtonItem) {
        listAscending.toggle()
        dataManager.updateSorting(ascending: listAscending)
        let image = UIImage(systemName: listAscending ? "arrow.down" : "arrow.up")
        sender.image = image
    }
    
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataManager.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let user = dataManager.users![indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = user.name
        config.secondaryText = "\(user.age)"
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.deleteUser(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = dataManager.users?[indexPath.row] else { return }
        let userDataManager = UserDataManager(realm: dataManager.realm, user: user)
        let userDetailsVC = UserDetailsViewController(dataManager: userDataManager)
        self.navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    
}

extension UserListViewController: DataManagerDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func handleUpdates(atDeletions deletions: [Int], insertions: [Int], modifications: [Int]) {
        tableView.performBatchUpdates {
            tableView.deleteRows(at: deletions.map({IndexPath(item: $0, section: 0)}), with: .automatic)
            tableView.insertRows(at: insertions.map({IndexPath(item: $0, section: 0)}), with: .automatic)
            tableView.reloadRows(at: modifications.map({IndexPath(item: $0, section: 0)}), with: .automatic)
        }
    }
    
    
}
