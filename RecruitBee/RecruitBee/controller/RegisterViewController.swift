//
//  RegisterViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 12/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var universityButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func studentButtonPressed(_ sender: Any) {
    }
    @IBAction func companyButtonPressed(_ sender: Any) {
    }
    @IBAction func universityButtonPressed(_ sender: Any) {
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
