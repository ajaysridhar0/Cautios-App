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

class SOSMessageViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    // Outlet
    @IBOutlet weak var sendHelpMessageButton: UIButton!
    @IBOutlet weak var borderOfButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendLocation: UISwitch!
    
    // Instance Variables
    var userLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
//        sendHelpMessageButton.frame = CGRect(x: 0, y: 0, width: 185, height: 185)
        sendHelpMessageButton.layer.cornerRadius = sendHelpMessageButton.frame.size.width/2
        sendHelpMessageButton.clipsToBounds = true
//        sendHelpMessageButton.center = self.view.center
//        borderOfButton.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
        borderOfButton.layer.cornerRadius = 0.5 * borderOfButton.bounds.size.width
        borderOfButton.clipsToBounds = true
        
        messageTextView.layer.cornerRadius = messageTextView.frame.size.width/32
        
//        borderOfButton.center = self.view.center
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendHelpMessagePressed(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            if let location = userLocation {
                messageVC.body = sendLocation.isOn ? ("\(messageTextView.text!) https://www.google.com/maps/search/?api=1&query=\(location.latitude),\(location.longitude)") : messageTextView.text!
            }
            else {
                messageVC.body = messageTextView.text!
            }
                   
            messageVC.recipients = ["7163904739", "7164716561", "7169099693"]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        //            UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@\(userLocation?.latitude),\(userLocation?.longitude),15z")!)
        }
        else {
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
}
//extension SOSMessageViewController: ReceiveLocationDelegate {
//    func receiveUserLocation(location: CLLocationCoordinate2D) {
//        userLocation = location
//        print("user location received")
//    }
//}
