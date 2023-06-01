//
//  DataManager.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 26.05.2023.
//

import Foundation
import RealmSwift

protocol DataManagerDelegate: AnyObject {
    func reloadData()
    func handleUpdates(atDeletions deletions: [Int], insertions: [Int], modifications: [Int])
}

class UserListDataManager {
    
    weak var delegate: DataManagerDelegate?
    
    let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    var notificationToken: NotificationToken?
    
    let colors: [UIColor] = [.systemYellow, .systemGray6, .systemGreen, .systemBlue]
    
    var users: Results<User>?
    
    func loadUsers() {
        let users = realm.objects(User.self).sorted(byKeyPath: "age", ascending: true)
        self.users = users
    }
    
    func addUser(name: String, age: Int) {
        let user = User()
        user.name = name
        user.age = age
        user.color = colors.randomElement()
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func deleteUser(at index: Int) {
        guard let user = users?[index] else { return }
        try! realm.write {
            realm.delete(user)
        }
    }
    
    func updateSorting(ascending: Bool) {
        users = users?.sorted(byKeyPath: "age", ascending: ascending)
        notificationToken?.invalidate()
        setupObservers()
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func setupObservers() {
        guard let users = users else { return }
        notificationToken = users.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.delegate?.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                print("deletions: \(deletions), insertions: \(insertions), modifications: \(modifications)")
                self?.delegate?.handleUpdates(atDeletions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
}
