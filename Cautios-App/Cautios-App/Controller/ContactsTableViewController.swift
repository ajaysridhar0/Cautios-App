//
//  ContactsTableViewController.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 11/1/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import Contacts

class ContactsTableViewController: UITableViewController {
    // instance variables
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Safety Contacts"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorization successful")
            }
        }
        fetchContacts()
    }
    
    // MARK: - Table view cell methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactToDisplay = contacts[indexPath.row]
        cell.textLabel?.text = "\(contactToDisplay.firstName) \(contactToDisplay.familyName)"
        cell.detailTextLabel?.text = contactToDisplay.number
        cell.accessoryType = contacts[indexPath.row].isSafety ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    // MARK: - Contact fetching method

    func fetchContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
                let name  = contact.givenName
                let familyName = contact.familyName
                let number = contact.phoneNumbers.first?.value.stringValue
                
                let contactToAppend = ContactStruct(firstName: name, familyName: familyName, number: number ?? "", isSafety: false)
                self.contacts.append(contactToAppend)
            }
        } catch { print("getting contacts did not work") }
        tableView.reloadData()
        print(contacts.first?.firstName)
    }
}
