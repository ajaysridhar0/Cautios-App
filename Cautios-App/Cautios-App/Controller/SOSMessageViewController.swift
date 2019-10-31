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
    
    // Instance Variables
    var userLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendHelpMessage(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            if let location = userLocation {
                messageVC.body = "Help! - This message was sent through the Cautios App https://www.google.com/maps/search/?api=1&query=\(location.latitude),\(location.longitude)"
            }
            else {
                messageVC.body = "Help! - This message was sent through the Cautios App"
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
