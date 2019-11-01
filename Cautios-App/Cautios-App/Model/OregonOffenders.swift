//
//  Offender.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 9/14/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import Foundation
import RealmSwift

class OregonOffenders: Object{
    @objc dynamic var firstName: String = ""
    @objc dynamic var middleName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var suffix: String = ""
    @objc dynamic var dateOfBirth: String = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var residenceStreetNumber: String = ""
    @objc dynamic var residenceStreetName: String = ""
    @objc dynamic var residenceApartmentNumber: String = ""
    @objc dynamic var residenceCity: String = ""
    @objc dynamic var residenceState: String = ""
    @objc dynamic var residenceZip: Int = 0
    @objc dynamic var residenceCounty: String = ""
    @objc dynamic var residenceLatitude: Double = 0.0
    @objc dynamic var residenceLongitude: Double = 0.0
    @objc dynamic var height: Int = 0
    @objc dynamic var weight: Int = 0
    @objc dynamic var hair: String = ""
    @objc dynamic var eyes: String = ""
    @objc dynamic var ofs: String = ""
}
