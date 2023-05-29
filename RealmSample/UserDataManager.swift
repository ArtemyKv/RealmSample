//
//  UserDataManager.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 29.05.2023.
//

import Foundation
import RealmSwift

class UserDataManager {
    private let realm: Realm
    private let user: User
    private var notificationToken: NotificationToken?
    
    weak var delegate: DataManagerDelegate?
    
    var username: String {
        return user.name
    }
    
    var userAge: Int {
        return user.age
    }
    
    var devicesCount: Int {
        return user.devices.count
    }
    
    init(realm: Realm, user: User) {
        self.realm = realm
        self.user = user
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func updateUsername(_ username: String) {
        try! realm.write {
            user.name = username
        }
    }
    
    func updateAge(_ age: Int) {
        try! realm.write {
            user.age = age
        }
    }
    
    func userDevice(at index: Int) -> Device? {
        guard index < devicesCount else { return nil }
        return user.devices[index]
    }
    
    func addDevice(name: String, type: DeviceType) {
        let device = Device()
        device.name = name
        device.type = type
        
        try! realm.write {
            user.devices.append(device)
        }
    }
    
    func removeDevice(at index: Int) {
        guard index < user.devices.count else { return }
        let device = user.devices[index]
        
        try! realm.write {
            user.devices.remove(at: index)
            realm.delete(device)
        }
    }
    
    func addObservers() {
        notificationToken = user.devices.observe { [weak self] changes in
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
