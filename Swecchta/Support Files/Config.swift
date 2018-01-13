//
//  Config.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 10/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import Foundation
import Firebase
struct Config {
    static var STORAGE_ROOT_REFERENCE = FIRStorage.storage().reference()
    static var DB_ROOT_REFERENCE = FIRDatabase.database().reference()
    
    
}
