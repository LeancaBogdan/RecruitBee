//
//  JobCreateViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 13/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit
import Firebase

class JobCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var titleTextFiled: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var otherTextField: UITextField!
    
    var user = Auth.auth().currentUser!
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jobImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectJobImage)))
        jobImage.isUserInteractionEnabled = true
    }
    

    @IBAction func cancelButtonPresseed(_ sender: Any) {
        performSegue(withIdentifier: "backToCompany", sender: self)
    }

    @IBAction func postButtonPressed(_ sender: Any) {
        let title = titleTextFiled.text
        let description = descriptionTextField.text
        let duration = durationTextField.text
        let other = otherTextField.text
        guard let key = ref.child("jobs").childByAutoId().key else { return }
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("jobs").child("\(imageName).png")
        if let uploadData = jobImage.image!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                
                storageRef.downloadURL { (url, erorr) in
                    guard let downloadURL = url else {
                        return
                    }
                    let job = ["uid": self.user.uid,
                    "title": title,
                    "description": description,
                    "duration": duration,
                    "other": other,
                    "jobImageURL": downloadURL.absoluteString]
                    self.ref.child("jobs/\(key)").setValue(job)
                }
            }
        }
        self.alert(message: "Your job offer was successfully submitted.", title: "Success")
    }
    
    @objc func handleSelectJobImage() {
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
            jobImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "backToCompany", sender: self)
        }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
