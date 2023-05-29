//
//  User.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 25.05.2023.
//

import RealmSwift

class User: Object {
    @Persisted (primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
    @Persisted var devices: List<Device>
}

class Device: Object {
    @Persisted var name: String = ""
    @Persisted var type: DeviceType = .unknown
    @Persisted(originProperty: "devices") var owner: LinkingObjects<User>
}

enum DeviceType: String, PersistableEnum, CaseIterable {
    case unknown
    case phone
    case tablet
    case laptop
    case handheld
    case smartWatch
    
}
