//
//  UserListView.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 26.05.2023.
//

import UIKit
import SnapKit

class UserListView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
