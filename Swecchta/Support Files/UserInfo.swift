//
//  UserInfo.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 12/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import Foundation
import Firebase

struct UserInfo
{
    
    static var uid = FIRAuth.auth()?.currentUser?.uid
    static var userName : String?
    static var userProfileImageURL : String?
    static var userProfileImageView : UIImageView?
    static var residence : String?
}


