//
//  StudentTableViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 14/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class StudentTableViewController: UITableViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    var ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var data:  [String:[String:String]] = [String:[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref.child("students").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
                
            if value == nil {
                return
            }
            else {
                self.navigationBar.topItem?.title = value!["firstname"] as? String
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentTableViewCell

        let key = Array(data.keys)[indexPath.row]
        let value = data[key]
        cell.jobTitle.text = value!["title"]
        cell.durationTextField.text = value!["duration"]
        ref.child("companies").child(value!["uid"]!).observeSingleEvent(of: .value) { (snapshot) in
            let val = snapshot.value as? NSDictionary
            cell.companyName.text = val!["companyName"] as? String
        }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showJob" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destination = segue.destination as! JobViewController
                destination.jobId = Array(data.keys)[indexPath.row] as String
                
            }
        }
    }
    
    func populateTableView() {
         ref.child("jobs").observeSingleEvent(of: .value) { (snapshot) in
             let values = snapshot.value as? [String:[String:String]]
            
            if values == nil {
                return
            }
             for (key, value) in values! {
                self.data[key] = value
             
             }
             sleep(2)
             self.tableView.reloadData()
         }
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        
        UserDefaults.standard.setIsLoggedIn(value: false)
        performSegue(withIdentifier: "signoutStudent", sender: self)
    }
}
