//
//  ViewController.swift
//  RecruitBee
//
//  Created by Adrian-Bogdan Leanca on 11/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toRegisterScreen", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else {
                   print("Firebase registration email text field empty")
                   return
               }
               
               guard let password = passwordTextField.text else {
                   print("Firebase registration email text field empty")
                   return
               }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
            self?.alert(message: "No user found. Please check your email and password.", title: "Login failed")
            return
          } else {
              // TO DO
          }
        }
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
    

