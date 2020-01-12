//
//  StudentUpdateViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 12/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class StudentUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var facultyTextField: UITextField!
    @IBOutlet weak var domainTextField: UITextField!
    
    var ref = Database.database().reference()
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        profileImage.isUserInteractionEnabled = true
        
        self.ref.child("students").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
                
            if value == nil {
                return
            }
            else {
                self.firstNameLabel.text = value!["firstname"] as? String
                self.lastNameLabel.text = value!["lastname"] as? String
            }
            
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let university = universityTextField.text else {
            return
        }
        
        guard let faculty = facultyTextField.text else {
            return
        }
        
        guard let domain = domainTextField.text else {
            return
        }
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("students").child("\(imageName).png")
        if let uploadData = profileImage.image!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                
                storageRef.downloadURL { (url, erorr) in
                    guard let downloadURL = url else {
                        return
                    }
                    
                    self.ref.child("students/\(self.user!.uid)/university").setValue(university)
                    self.ref.child("students/\(self.user!.uid)/faculty").setValue(faculty)
                    self.ref.child("students/\(self.user!.uid)/domain").setValue(domain)
                    self.ref.child("students/\(self.user!.uid)/profileImageURL").setValue(downloadURL.absoluteString)
                }
            }
            
            performSegue(withIdentifier: "toStudentMainScreen", sender: self)
        }
        
    }
    
    @objc func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
