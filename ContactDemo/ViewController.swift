//
//  ViewController.swift
//  ContactDemo
//
//  Created by iFlame on 5/25/17.
//  Copyright © 2017 iFlame. All rights reserved.
//

import UIKit
import ContactsUI

class ViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource , CNContactPickerDelegate {
    
    @IBOutlet var tblContact: UITableView!
    var arrContacts : NSMutableArray?
    var contactStore = CNContactStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tblContact.delegate = self
        tblContact.dataSource = self
        
        fetchAllContacts()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchAllContacts(){
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                    arrContacts?.add(results)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
        print(contacts)
        self.tblContact.reloadData()
    }
    
    func getContactsSimpleWay(){
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .phoneticFullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            
            try self.contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                print(contacts)
                self.arrContacts?.add(contacts)
                
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        self.tblContact.reloadData()
    }
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            _ = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            //self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    //MARK:- TableView Methods 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let contact = arrContacts?.count {
            return contact
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.nameLabel.text = arrContacts?[indexPath.row] as? String
        
        return cell
    }

}
