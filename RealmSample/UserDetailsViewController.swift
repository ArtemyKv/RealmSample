//
//  UserDetailsViewController.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 29.05.2023.
//

import UIKit

class UserDetailsViewController: UIViewController {
    let dataManager: UserDataManager
    
    var userDetailsView: UserDetailsView! {
        guard isViewLoaded else { return nil }
        return (view as! UserDetailsView)
    }
    
    var devicesTableView: UITableView {
        return userDetailsView.devicesTableView
    }
    
    init(dataManager: UserDataManager) {
        self.dataManager = dataManager
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let userDetailsView = UserDetailsView()
        self.view = userDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailsView.configure(with: dataManager.username, age: dataManager.userAge)
        userDetailsView.delegate = self
        setupBarButton()
        dataManager.delegate = self
        dataManager.addObservers()
        devicesTableView.dataSource = self
        devicesTableView.delegate = self
        devicesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeviceTableViewCell")
        
    }
    
    func setupBarButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        let deviceNames = ["iPhone 11", "Samsung S3", "Playstation 3", "Hello its me 16", "Nintendo switch", "iPad", "Macbook air 2020", "iPhone 3gs", "Nokia 3310", "Hello 22"]
        let deviceTypes = DeviceType.allCases
        
        let deviceNameIndex = Int.random(in: 0..<deviceNames.count)
        let deviceTypeIndex = Int.random(in: 0..<deviceTypes.count)
        let deviceName = deviceNames[deviceNameIndex]
        let deviceType = deviceTypes[deviceTypeIndex]
        
        dataManager.addDevice(name: deviceName, type: deviceType)
    }
}

extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.devicesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let device = dataManager.userDevice(at: indexPath.row) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = device.name
        config.secondaryText = device.type.rawValue
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.removeDevice(at: indexPath.row)
        }
    }
    
    
}

extension UserDetailsViewController: DataManagerDelegate {
    func reloadData() {
        devicesTableView.reloadData()
    }
    
    func handleUpdates(atDeletions deletions: [Int], insertions: [Int], modifications: [Int]) {
        devicesTableView.performBatchUpdates {
            devicesTableView.deleteRows(at: deletions.map({IndexPath(item: $0, section: 0)}), with: .automatic)
            devicesTableView.insertRows(at: insertions.map({IndexPath(item: $0, section: 0)}), with: .automatic)
            devicesTableView.reloadRows(at: modifications.map({IndexPath(item: $0, section: 0)}), with: .automatic)
        }
    }
}

extension UserDetailsViewController: UserDetailsViewDelegate {
    func nameTextFieldDidEndEditing(with text: String) {
        let username = text.isEmpty ? "No name" : text
        dataManager.updateUsername(username)
    }
    
    func ageTextFieldDidEndEditing(with text: String) {
        guard let age = Int(text) else { return }
        dataManager.updateAge(age)
    }
    
    
}
