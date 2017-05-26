//
//  AddContactViewController.swift
//  ContactDemo
//
//  Created by iFlame on 5/25/17.
//  Copyright © 2017 iFlame. All rights reserved.
//

import UIKit
import Contacts

protocol fetchAllContactsDelegate {
    func fetchAllContacts()
}

class AddContactViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate ,UITextFieldDelegate{
   
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var contactField: UITextField!
    @IBOutlet var secondNameField: UITextField!
    
    var myParent: fetchAllContactsDelegate?
    
    
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
    
    func createCNContactWithFirstName(_ firstName: String, lastName: String, email: String?, phone: String?, image: UIImage?){
        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            let newContact = CNMutableContact()
            
            newContact.givenName = firstName
            newContact.familyName = lastName
          
       
            // email
            if email != nil {
                let contactEmail = CNLabeledValue(label: CNLabelHome, value: email! as NSString)
                newContact.emailAddresses = [contactEmail]
            }
            // phone
            if phone != nil {
                let contactPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone!))
                newContact.phoneNumbers = [contactPhone]
            }
            
            // image
            if image != nil {
                newContact.imageData = UIImageJPEGRepresentation(image!, 0.9)
            }
            
            do {
                let newContactRequest = CNSaveRequest()
                newContactRequest.add(newContact, toContainerWithIdentifier: nil)
                try CNContactStore().execute(newContactRequest)
                
                NotificationCenter.default.post(name: NSNotification.Name.init("NewContanctAdded"), object: nil)
                
                myParent?.fetchAllContacts()
                self.navigationController?.popViewController(animated: true)
                //self.presentingViewController?.dismiss(animated: true, completion: nil)
            } catch {
               
            }

           
//            let controller = CNContactViewController(forUnknownContact : contact)// .viewControllerForUnknownContact(contact)
//            controller.contactStore = store
//            controller.delegate = self
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationController!.pushViewController(controller, animated: true)
        }

    }
    
    
    
    //MARK:- ADD Action UIBarButton
    @IBAction func addPressed(_ sender: UIButton) {
        if (nameField.text != "" && secondNameField.text != "") && (emailField.text != "" && contactField.text != ""){
        self.createCNContactWithFirstName(nameField.text!, lastName: secondNameField.text!, email: emailField.text, phone: contactField.text, image:myImageView.image )
        }
        }
    
    
    
    
    
    
    //MARK:- TEXT Field Delegate ResignFirst Risponder
       func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}
