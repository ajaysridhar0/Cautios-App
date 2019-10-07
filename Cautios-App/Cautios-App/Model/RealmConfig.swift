//
//  RealmConfig.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 9/15/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmConfig {
    // Copy the pre-bundled file to the documents folder
    private static var copyInitialFile: Void = {
        do {
            try FileManager.default.copyItem(at: Bundle.main.url(forResource: "default-OR", withExtension: "realm")!, to: Realm.Configuration.defaultConfiguration.fileURL!)
            print("Copying Realm data in default configuration file complete")
        } catch{}
    }()
    
    // MARK: - private configuration
    private static let mainConfig = Realm.Configuration(
        fileURL: Bundle.main.url(forResource: "default-OR", withExtension: "realm"),
        readOnly: true
    )
    
    // MARK: - enum cases
    case main
    
    // MARK: - public access to current configuration
    var configuration: Realm.Configuration {
        switch self {
        case .main:
            // Skip functon invocation result.
            _ = RealmConfig.copyInitialFile
            // Code that checks if we already copied the bundled data already
            return RealmConfig.mainConfig
        }
        
    }
}
