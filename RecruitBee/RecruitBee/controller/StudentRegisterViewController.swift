//
//  StudentRegisterViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 12/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class StudentRegisterViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
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
        
        if password.count < 6 {
            self.alert(message: "Your password should be at least 6 characters long", title: "Password too short")
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                self.alert(message: "There is another account associated with this email", title: "Registration error")
                return
            } else {
                // TO DO
                self.registrationSuccessful()
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
    
    func registrationSuccessful() {
        guard let firstname = firstNameTextField.text else {
            return
        }
        
        guard let lastname = lastNameTextField.text else {
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }

        self.ref.child("students/\(user.uid)/firstname").setValue(firstname)
        self.ref.child("students/\(user.uid)/lastname").setValue(lastname)
        performSegue(withIdentifier: "toStudentUpdate", sender: self)
    }
}
