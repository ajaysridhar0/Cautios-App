//
//  OffenderListManager.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 10/26/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import CoreLocation

// quick singleton implementtation for our OffenderInfoListManager.
private let _singeltonInstance = OffenderInfoListManager()

// private let kOffenderInfoListMangerNumberOfOffenders = 877

class OffenderInfoListManager: NSObject {
    // shared instance of OffenderInfoListManager.
    class var sharedInstance: OffenderInfoListManager { return _singeltonInstance }
    
    // offender info list
//    var offenderAnnotations = [offenderAnnotations]()
    
    // MARK - init
    override init() {
        super.init()
        
    }
    
    func populateOffenderList() {
        
    }
    
    func giveInfoList() {
        
        
    }
}
