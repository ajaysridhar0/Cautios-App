//
//  ContactStruct.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 11/1/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    @objc dynamic var firstName: String = ""
    @objc dynamic var familyName: String = ""
    @objc dynamic var number: String = ""
    @objc dynamic var isSafety: Bool = false
}
