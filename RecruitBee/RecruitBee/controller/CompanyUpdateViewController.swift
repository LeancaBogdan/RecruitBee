//
//  CompanyUpdateViewController.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 12/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit

class CompanyUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var aboutCompanyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        profileImage.isUserInteractionEnabled = true
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
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
