//
//  CompanyTableViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 14/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class CompanyTableViewController: UITableViewController {

    var ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var data:  [String:[String:String]] = [String:[String:String]]()
    
    @IBOutlet weak var nabigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref.child("companies").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
                
            if value == nil {
                return
            }
            else {
                self.nabigationBar.topItem?.title = value!["companyName"] as? String
            }
            
        }
        
        populateTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "companyJob"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CompanyTableViewCell

        let key = Array(data.keys)[indexPath.row]
        let value = data[key]
        cell.jobTitleTextField.text = value!["title"]
        cell.durationTextField.text = value!["duration"]
//        ref.child("companies").child(value!["uid"]!).observeSingleEvent(of: .value) { (snapshot) in
//            let val = snapshot.value as? NSDictionary
//            cell.companyTextField.text = val!["companyName"] as? String
//        }
        let imageStorageRef = Storage.storage().reference(forURL: value!["jobImageURL"]!)
        imageStorageRef.downloadURL(completion: { (url, error) in
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data as Data)
                cell.jobImage.image = image
            } catch _ {
                cell.jobImage.image = UIImage(named: "empty-profile-image")
            }
        })
        return cell
    }
    
    func populateTableView() {
        ref.child("jobs").observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? [String:[String:String]]
            
            if values == nil {
                return
            }
            
            for (key, value) in values! {
                let v = value
                if v["uid"] == self.user?.uid {
                    self.data[key] = v
                }
            
            }
            sleep(2)
            self.tableView.reloadData()
        }
   }

    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        
        UserDefaults.standard.setIsLoggedIn(value: false)
        performSegue(withIdentifier: "logoutCompany", sender: self)
    }
    
    @IBAction func addJobOfferPressed(_ sender: Any) {
        performSegue(withIdentifier: "toJobCreate", sender: self)
    }
}
