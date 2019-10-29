//
//  OffenderCalloutView.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 10/28/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import MapViewPlus

class OffenderCalloutView: UIView, CalloutViewPlus {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    func configureCallout(_ viewModel: CalloutViewModel) {
        let viewModel = viewModel as! OffenderCalloutViewModel
        nameLabel.text = viewModel.name
        infoLabel.text = viewModel.info
    }
}
