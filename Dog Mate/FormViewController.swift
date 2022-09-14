//
//  CreateUserViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 11/9/22.
//

import UIKit
import FirebaseAuth

class FormViewController: UIViewController {
    enum FormType {
        case Registration
        case User
        case Pet
    }
    
    var formType: FormType = .Registration
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var dataSource: [[FormFields]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let emailField = FormFields(field: "Email", placeholder: "Enter Email")
        let passwordField = FormFields(field: "Password", placeholder: "Enter Password")
        dataSource = [[emailField, passwordField]]
    }
    
    @IBAction func completeRegistration(_ sender: UIButton) {
        switch formType {
        case .Registration:
            completeRegistration()
        case .User:
            break
        case .Pet:
            break
        }
        
    }
    
    private func completeRegistration() {
        guard let email = dataSource[0][0].value, !email.isEmpty,
              let password = dataSource[0][1].value, !password.isEmpty else {
            print("Missing fields")
            return
        }

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] auth, error in
            guard let weakself = self else {
                return
            }

            guard error == nil else { return }

            print("Sign in")
        }
    }
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        let information = dataSource[indexPath.section][indexPath.row]
        
        let model = TextFieldCellModel(placeHolder: information.placeholder ?? "")
        cell.update(model: model)
        
        cell.shouldFinishEditing = ({ [weak self] text in
            guard let weakself = self else { return }
            weakself.dataSource[indexPath.section][indexPath.row].value = text
        })
        return cell
    }
}

struct FormFields {
    var field: String
    var placeholder: String?
    var value: String?
    
    init(field: String, placeholder: String?) {
        self.field = field
        self.placeholder = placeholder
    }
}
