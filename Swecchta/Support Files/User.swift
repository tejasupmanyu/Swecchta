//
//  User.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 20/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import Foundation
class User
{
    static var defaults = UserDefaults.standard
    
    static func getUserName() -> String
    {
        return defaults.string(forKey: "userName")!
        //value(forKey: "userName") as! String
    }
    
//    static func getUserProfileImage() -> UIImage {
//        
//        //return defaults.object(forKey: "userProfileImage") as! UIImage
//        //value(forKey: "userProfileImage") as! UIImage
//        return (UserInfo.userProfileImageView?.image)!
//    }
    
    static func clearUserDefaults()
    {
        // should clear the UserDefaults
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
