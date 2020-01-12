//
//  ViewController.swift
//  RecruitBee
//
//  Created by Adrian-Bogdan Leanca on 11/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toRegisterScreen", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
}
    

