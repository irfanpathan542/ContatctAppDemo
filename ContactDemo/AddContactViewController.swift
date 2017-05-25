//
//  AddContactViewController.swift
//  ContactDemo
//
//  Created by iFlame on 5/25/17.
//  Copyright © 2017 iFlame. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
   
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var contactField: UITextField!
    @IBOutlet var secondNameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.placeholder = "Enter First Name"
        secondNameField.placeholder = "Enter Second Name"
        contactField.placeholder = "Enter Contact Number"
        emailField.placeholder = "Enter Email id"
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        myImageView.isUserInteractionEnabled = true
        myImageView .addGestureRecognizer(tapGestureRecognizer)
        

        
       }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        
        // Create a UiPickerContoller
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
              imagePickerController.sourceType = .camera
              self.present(imagePickerController, animated: true, completion: nil)
        }))
        
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            self.present(actionSheet, animated: true, completion: nil)
           }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        myImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK:- ADD Action UIBarButton
    @IBAction func addPressed(_ sender: UIButton) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}
