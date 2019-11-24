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
    @IBOutlet weak var messageTextView: UITextView!
    
    // UI Elements
    let buttonConverage = 0.8
    let screenSize = UIScreen.main.bounds
    
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
        // UI Setup
        view.backgroundColor = .black
        
        // helpButton
        sendHelpMessageButton.frame = CGRect(x: screenSize.width/2 - CGFloat(buttonConverage)*screenSize.width/2, y: (screenSize.height) * 0.15, width: CGFloat(buttonConverage)*screenSize.width, height: CGFloat(buttonConverage)*screenSize.width)
        sendHelpMessageButton.layer.cornerRadius = sendHelpMessageButton.frame.size.width/2
        sendHelpMessageButton.layer.borderWidth = sendHelpMessageButton.frame.size.width/40
        sendHelpMessageButton.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        sendHelpMessageButton.clipsToBounds = true
        
        // messageTextView
        if let helpMessage = defaults.string(forKey: "HelpMessage") {
            messageTextView.text = helpMessage
        }
        else {
            messageTextView.text = "Help! Here is my current location - This message was sent through the Cautios App"
        }

        messageTextView.frame = CGRect(x: screenSize.width/2 - sendHelpMessageButton.frame.width/2, y: (screenSize.height) * 0.19 + sendHelpMessageButton.frame.height , width: sendHelpMessageButton.frame.width, height: screenSize.height - ((screenSize.height) * 0.19 + sendHelpMessageButton.frame.height) - 110)
        messageTextView.layer.cornerRadius = messageTextView.frame.size.width/32
        messageTextView.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
        messageTextView.font = .systemFont(ofSize: 16)
        var frame = messageTextView.frame
        frame.size.height = messageTextView.contentSize.height
        messageTextView.frame = frame
    }

    // MARK: - MF Message Compose View Controller Delegate
    @IBAction func sendHelpMessageButtonPressed(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
                    let messageVC = MFMessageComposeViewController()
                    if let location = userLocation {
                        messageVC.body =  "\(messageTextView.text!) https://www.google.com/maps/search/?api=1&query=\(location.latitude),\(location.longitude)"
                    }
                    else {
                        messageVC.body = messageTextView.text!
                    }
                    messageVC.recipients = []
                    for contact in contacts! {
                        if contact.isSafety {
                    messageVC.recipients?.append(contact.number)
                        }
                    }
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
}
