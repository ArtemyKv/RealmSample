//
//  UserTableViewCell.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 26.05.2023.
//

import UIKit
import SnapKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
