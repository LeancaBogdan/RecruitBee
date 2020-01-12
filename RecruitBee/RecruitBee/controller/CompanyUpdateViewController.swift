//
//  CompanyUpdateViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 12/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class CompanyUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var aboutCompanyTextField: UITextField!
    
    var ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        profileImage.isUserInteractionEnabled = true
        
        self.ref.child("companies").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
                
            if value == nil {
                return
            }
            else {
                self.companyNameLabel.text = value!["companyName"] as? String
            }
            
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let description = aboutCompanyTextField.text else {
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("companies").child("\(imageName).png")
        if let uploadData = profileImage.image!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                
                storageRef.downloadURL { (url, erorr) in
                    guard let downloadURL = url else {
                        return
                    }
                    
                    self.ref.child("companies/\(user.uid)/description").setValue(description)
                    self.ref.child("companies/\(user.uid)/profileImageURL").setValue(downloadURL.absoluteString)
                    
                    
                }
            }
        }
        
        performSegue(withIdentifier: "toCompanyMainScreen", sender: self)
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
