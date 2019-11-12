//
//  ContactsTableViewController.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 11/1/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import Contacts
import RealmSwift

class ContactsTableViewController: UITableViewController {
    // instance variables
    var contactStore = CNContactStore()
    var contacts: Results<Contact>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Safety Contacts"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        loadRealmContacts()
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Contacts authorization successful")
            }
        }
        fetchContacts()
    }
    
    // MARK: - Table view cell methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if let contactToDisplay = contacts?[indexPath.row] {
            cell.textLabel?.text = "\(contactToDisplay.firstName) \(contactToDisplay.familyName)"
            cell.detailTextLabel?.text = contactToDisplay.number
            cell.accessoryType = contactToDisplay.isSafety ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contact = contacts?[indexPath.row] {
            do {
                try realm.write {
                    contact.isSafety = !contact.isSafety
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts?.count ?? 0
    }
    
    // MARK: - Contact fetching method
    func fetchContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
                let firstName  = contact.givenName
                let familyName = contact.familyName
                let number = contact.phoneNumbers.first?.value.stringValue
                var isNewContact = true
                
                let contactToAppend = Contact()
                if (self.contacts?.count ?? -1 > 0) {
                    print("more than 1 contact generated")
                    for i in 0...(self.contacts?.count ?? 1) - 1 {
                        if self.contacts?[i].number == number {
                            contactToAppend.firstName = firstName
                            contactToAppend.familyName = familyName
                            contactToAppend.number = self.contacts?[i].number ?? ""
                            contactToAppend.isSafety = self.contacts?[i].isSafety ?? false
                            isNewContact = false
                            self.saveContact(contact: contactToAppend)
                            do {
                                try self.realm.write {
                                    self.realm.delete((self.contacts?[i])!)
                                    print("Contact successfully deleted")
                                }
                            } catch { print("Error deleting contact to update it: \(error)") }
                        }
                    }
                }
                if isNewContact {
                    print("Is new contact")
                    contactToAppend.firstName = firstName
                    contactToAppend.familyName = familyName
                    contactToAppend.number = number ?? ""
                    contactToAppend.isSafety = false
                    self.saveContact(contact: contactToAppend)
                }
            }
        } catch { print("getting contacts did not work") }
        tableView.reloadData()
        print(contacts?.first?.firstName)
    }
    
    func loadRealmContacts() {
        contacts = realm.objects(Contact.self)
        tableView.reloadData()
    }
    
    func saveContact(contact: Contact) {
        do {
            try realm.write {
                realm.add(contact)
            }
        } catch { print("Effor saving contact: \(contact)") }
        tableView.reloadData()
    }
    
    // MARK: - Delete data to be replaced
}
