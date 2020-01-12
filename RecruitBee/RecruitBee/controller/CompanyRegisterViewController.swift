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

    var ref: DatabaseReference!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
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
                self.successRegistration()
            }
            
        }
    }
    
    func successRegistration() {
        guard let companyName = companyNameTextField.text else {
            return
        }
        guard let user = Auth.auth().currentUser else {
            return
        }

        self.ref.child("companies/\(user.uid)/companyName").setValue(companyName)
        performSegue(withIdentifier: "toCompanyUpdate", sender: self)
    }
}
