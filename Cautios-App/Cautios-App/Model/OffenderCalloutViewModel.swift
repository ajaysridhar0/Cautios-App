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
    var offender: OregonOffenders
    
    init(offender: OregonOffenders) {
        let address = (offender.residenceStreetNumber + " " + offender.residenceStreetName + " " + offender.residenceCity + ", " + offender.residenceState + " " + String(offender.residenceZip)).uppercased()
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthDate : Date = inputFormatter.date(from: offender.dateOfBirth) else { fatalError() }
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 1
        form.unitsStyle = .full
        form.allowedUnits = [.year]
        let age = form.string(from: birthDate, to: Date())
        let height: String = String(offender.height / 100) + "' " + String(offender.height % 100) + "\""
        let weight = offender.weight
        let eyeColor = offender.eyes == "BLU" ? "Blue" : (offender.eyes  == "BRO" ? "Brown" : (offender.eyes  == "HAZ" ? "Hazel" : (offender.eyes  == "GRY" ? "Gray" : (offender.eyes  == "GRN" ? "Green" : (offender.eyes  == "BLK" ? "Black" : ("Not available"))))))
        let hairColor = offender.hair == "BLN" ? "Blond" : (offender.hair  == "BRO" ? "Brown" : (offender.hair  == "WHI" ? "White" : (offender.hair  == "GRY" ? "Gray" : (offender.hair  == "RED" ? "Red" : (offender.hair  == "BLK" ? "Black" : ("Not available"))))))
        
        self.name = offender.firstName + " " + offender.middleName + " " + offender.lastName + " " + offender.suffix

        self.info = "Address: \(address) \nAge: \(age!) \nHeight: \(height) \nWeight: \(weight) lbs \nHair Color: \(hairColor) \nEye Color: \(eyeColor)"
        self.offender = offender
    }
}
