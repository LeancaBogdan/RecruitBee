//
//  CompanyRegisterViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 12/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class CompanyRegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UIStackView!
    @IBOutlet weak var lastNameTextField: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else {
            print("Firebase registration email text field empty")
            return
        }
        
        guard let password = passwordTextField.text else {
            print("Firebase registration email text field empty")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                print(error!)
                return
            } else {
                print(authResult!)
            }
            
        }
    }
}
