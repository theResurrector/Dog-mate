//
//  CreateUserViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 11/9/22.
//

import UIKit
import FirebaseAuth

class CreateUserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    
    var fields: [(String, Any?)] = [("Email", nil), ("Password", nil)]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func completeRegistration(_ sender: UIButton) {
        guard let email = fields[0].1 as? String, !email.isEmpty,
              let password = fields[1].1 as? String, !password.isEmpty else {
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

extension CreateUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        
        let model = TextFieldCellModel(placeHolder: "Enter \(fields[indexPath.row].0)")
        cell.update(model: model)
        
        cell.shouldFinishEditing = ({ [weak self] text in
            guard let weakself = self else { return }
            
            weakself.fields[indexPath.row].1 = text
        })
        return cell
    }
}
