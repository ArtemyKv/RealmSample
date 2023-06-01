//
//  UserDetailsView.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 29.05.2023.
//

import UIKit
import SnapKit

protocol UserDetailsViewDelegate: AnyObject {
    func nameTextFieldDidEndEditing(with text: String)
    func ageTextFieldDidEndEditing(with text: String)
}

class UserDetailsView: UIView {
//    let userImageVIew: UIImageView = {
//        let imageView = UIImageView()
//
//        return imageView
//    }()
    
    weak var delegate: UserDetailsViewDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        label.text = "User Name:"
        label.snp.contentHuggingHorizontalPriority = 251
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.placeholder = "Enter Name"
        return textField
    }()
    
    let nameStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
//    let lastNameTextField: UITextField = {
//        let textField = UITextField()
//        textField.textAlignment = .center
//        textField.placeholder = "Enter Last Name"
//        return textField
//        return textField
//    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        label.text = "User Age:"
        label.snp.contentHuggingHorizontalPriority = 251
        return label
    }()
    
    let ageTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
        textField.placeholder = "Enter Age"
        return textField
    }()
    
    let ageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    let devicesTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .systemBackground
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        ageStackView.addArrangedSubview(ageLabel)
        ageStackView.addArrangedSubview(ageTextField)
        vStack.addArrangedSubview(nameStackView)
        vStack.addArrangedSubview(ageStackView)
        
        addSubview(vStack)
        addSubview(devicesTableView)
        
        vStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        devicesTableView.snp.makeConstraints { make in
            make.top.equalTo(vStack.snp.bottom).offset(44)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nameTextField.delegate = self
        ageTextField.delegate = self
    }
    
    func configure(with username: String, age: Int) {
        nameTextField.text = username
        ageTextField.text = String(age)
    }
    
}

extension UserDetailsView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text else { return }
        if reason == .committed {
            switch textField {
            case nameTextField:
                delegate?.nameTextFieldDidEndEditing(with: text)
            case ageTextField:
                delegate?.ageTextFieldDidEndEditing(with: text)
            default:
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
}
