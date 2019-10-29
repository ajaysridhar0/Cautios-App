//
//  OffenderCalloutViewModel.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 10/28/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import MapViewPlus

class OffenderCalloutViewModel: CalloutViewModel {
    var name: String
    var info: String
    
    init(name: String, info: String) {
        self.name = name
        self.info = info
    }
}
