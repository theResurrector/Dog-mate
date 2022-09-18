//
//  ViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 11/9/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let reference = Database.database(url: "https://dog-mate-e7f92-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        if let uid = Auth.auth().currentUser?.uid {
            checkUserData(userId: uid)
        }
    }
    
    func checkUserData(userId: String) {
        let dataRef = self.reference.child("/\(userId)")
        dataRef.observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                UserDefaults.standard.set(userId, forKey: "userid")
                self.goToLoggedInHomepageScreen()
            } else {
                self.goToUpdateUserScreen()
            }
        }
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Missing fields")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] auth, error in
            guard let weakself = self else {
                return
            }
            
            guard error == nil else {
                weakself.goCreateAccountScreen()
                return
            }
            
            if let userId = auth?.user.uid {
                weakself.checkUserData(userId: userId)
            }
        }
        
    }
    
    func goCreateAccountScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToUpdateUserScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        vc.formType = .User
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToLoggedInHomepageScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeLoggedInViewController") as! HomeLoggedInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

