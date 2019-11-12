//
//  SOSViewController.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 10/28/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation
import RealmSwift

class SOSMessageViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextViewDelegate {
    
    // Outlet
    @IBOutlet weak var sendHelpMessageButton: UIButton!
    @IBOutlet weak var borderOfButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendLocationSwitch: UISwitch!
    
    // Instance Variables
    var userLocation: CLLocationCoordinate2D?
    var contacts: Results<Contact>?
    let defaults = UserDefaults.standard
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        messageTextView.delegate = self
        sendLocationSwitch.tag = 1
        
        // UI
        view.backgroundColor = .black
        sendHelpMessageButton.layer.cornerRadius = sendHelpMessageButton.frame.size.width/2
        sendHelpMessageButton.clipsToBounds = true
        borderOfButton.layer.cornerRadius = 0.5 * borderOfButton.bounds.size.width
        borderOfButton.clipsToBounds = true
        messageTextView.layer.cornerRadius = messageTextView.frame.size.width/32
        
        // Setting up user defaults
//        sendLocationSwitch.isOn = defaults.bool(forKey: "SendLocation")
        
        if let helpMessage = defaults.string(forKey: "HelpMessage") {
            messageTextView.text = helpMessage
        }
        else {
            messageTextView.text = "Help! - This message was sent through the Cautios App"
        }
    }
    
    // MARK: - MF Message Compose View Controller Delegate
    @IBAction func sendHelpMessagePressed(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            if let location = userLocation {
                messageVC.body = sendLocationSwitch.isOn ? ("\(messageTextView.text!) https://www.google.com/maps/search/?api=1&query=\(location.latitude),\(location.longitude)") : messageTextView.text!
            }
            else {
                messageVC.body = messageTextView.text!
            }
            for contact in contacts! {
                messageVC.recipients?.append(contact.number)
            }
            print(messageVC.recipients)
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        }
        else {
//            for contact in contacts! {
//                print(contact.number)
//            }
            // TODO: - show that this device cannot send text messages through alert
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("iMessage was cancelled")
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            print("iMessage was sent")
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            print("iMessage failed")
            controller.dismiss(animated: true, completion: nil)
        @unknown default:
            break
        }
    }
    
    // MARK: - Text View Delegate Methods
    func textViewDidEndEditing(_ textView: UITextView) {
        defaults.set(messageTextView.text!, forKey: "HelpMessage")
        print("The user stopped typing the help message")
    }
    
    // MARK: - Load contacts method
    func loadContacts() {
        contacts = realm.objects(Contact.self)
    }
    
    // MARK: - Button Pressed Methods
//    func buttonClicked(sender: UIButton) {
//        if sender.tag == 1 {
//            defaults.set(sendLocationSwitch.isOn, forKey: "SendLocation")
//        }
//    }
}
