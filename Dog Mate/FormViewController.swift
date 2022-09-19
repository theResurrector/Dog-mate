//
//  CreateUserViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 11/9/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FormViewController: UIViewController {
    enum FormType {
        case Registration
        case User
    }
    
    var formType: FormType = .Registration
    var reference: DatabaseReference = Database.database(url: "https://dog-mate-e7f92-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var dataSource: [FormFields] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }
    
    func setupFields() {
        switch formType {
        case .Registration:
            let emailField = FormFields(field: "email", placeholder: "Enter Email")
            let passwordField = FormFields(field: "password", placeholder: "Enter Password")
            dataSource = [emailField, passwordField]
        case .User:
            let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
            navigationItem.setLeftBarButton(logoutButton, animated: true)
            
            reference = reference.child("users")
            let nameField = FormFields(field: "name", placeholder: "Enter Name")
            dataSource = [nameField]
        }
    }
    
    @objc private func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print ("Already logged out")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeRegistration(_ sender: UIButton) {
        switch formType {
        case .Registration:
            completeRegistration()
        case .User:
            completeUserProfile()
        }
        
    }
    
    private func completeRegistration() {
        guard let email = dataSource[0].value as? String, !email.isEmpty,
              let password = dataSource[1].value as? String, !password.isEmpty else {
            print("Missing fields")
            return
        }

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] auth, error in
            guard let weakself = self else {
                return
            }

            guard error == nil else { return }
            if let userId = auth?.user.uid {
                UserDefaults.standard.set(userId, forKey: "userid")
                weakself.goToUpdateUserScreen()
            }
            
        }
    }
    
    private func completeUserProfile() {
        guard let name = dataSource[0].value as? String, !name.isEmpty else {
            print("Missing fields")
            return
        }
        if let userId = Auth.auth().currentUser?.uid {
            let dict = ["name": name, "pet": nil]
            reference.child("\(userId)").setValue(dict)
            goToAddPet()
        }
    }
    
    func goToUpdateUserScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        vc.formType = .User
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAddPet() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPetViewController") as! AddPetViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        let information = dataSource[indexPath.row]
        
        let model = FormFieldModel(placeHolder: information.placeholder ?? "")
        cell.update(model: model)
        
        cell.shouldFinishEditing = ({ [weak self] text in
            guard let weakself = self else { return }
            weakself.dataSource[indexPath.row].value = text
        })
        return cell
    }
}

struct FormFields {
    var title: String = ""
    var field: String
    var placeholder: String?
    var value: Any?
    
    init(field: String, placeholder: String?) {
        self.field = field
        self.placeholder = placeholder
    }
    
    init(title: String, field: String) {
        self.title = title
        self.field = field
    }
    
    init(title: String, field:String = "", value: Any?) {
        self.title = title
        self.field = field
        self.value = value
    }
}
