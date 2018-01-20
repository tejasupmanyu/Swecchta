//
//  LocationAddress.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 18/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import Foundation
import CoreLocation

class LocationAddress
{
    var coordinates : CLLocation
    var address : String
    
    init(coord : CLLocation, add : String) {
        coordinates = coord
        address = add
    }
    
}
