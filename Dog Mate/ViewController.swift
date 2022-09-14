//
//  ViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 11/9/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
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
            
            print("Sign in")
        }
        
    }
    
    func goCreateAccountScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

