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
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    
    var users: Results<User>?
    
    func loadUsers() {
        let users = realm.objects(User.self).sorted(byKeyPath: "age", ascending: true)
        self.users = users
    }
    
    func addUser(name: String, age: Int) {
        let user = User()
        user.name = name
        user.age = age
        
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
    
    func sampleUsers() {
//        let user1 = User(value: ["name": "Artem", "age": 32] as [String : Any])
        
        let user1 = User()
        user1.age = 32
        user1.name = "Artem"
        
        try! realm.write {
            realm.add(user1)
        }
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
