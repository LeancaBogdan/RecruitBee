//
//  JobViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 14/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class JobViewController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var jobId: String?
    var companyId: String?
    var ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.ref.child("jobs").child(jobId!).observeSingleEvent(of: .value) { (snapshot) in
        let value = snapshot.value as? NSDictionary
            
        if value == nil {
            return
        }
        else {
            self.navigationBar.topItem!.title = value!["title"] as? String
            
            let imageStorageRef = Storage.storage().reference(forURL: value!["jobImageURL"]! as! String)
            imageStorageRef.downloadURL(completion: { (url, error) in
                do {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data as Data)
                    self.image.image = image
                } catch _ {
                    self.image.image = UIImage(named: "empty-profile-image")
                }
            })
            
            let description = value!["description"] as! String
            let duration = value!["duration"] as! String
            let other = value!["other"] as! String
            self.companyId = value!["uid"] as? String
            self.textLabel.text = "\(description). \n\n The intership will have a duration of \(duration). \n\n Note that: \n\(other)"
            
        }
        }
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "backBack", sender: self)
    }
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        ref.child("companies").child(companyId!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            self.alert(message: "To apply for this internship please send your CV to: \(value!["email"]!)", title: "Information")
            
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
