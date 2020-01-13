//
//  CompanyMainPageViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 13/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class CompanyMainPageViewController: UIViewController {

    var ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var addJobOfferButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref.child("companies").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
                
            if value == nil {
                return
            }
            else {
                self.navigationBar.topItem?.title = value!["companyName"] as? String
            }
            
        }
    }


    @IBAction func addJobOfferButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toJobCreate", sender: self)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        
        UserDefaults.standard.setIsLoggedIn(value: false)
        performSegue(withIdentifier: "logoutCompany", sender: self)
        
    }
}
