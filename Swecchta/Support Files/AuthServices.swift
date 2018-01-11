//
//  AuthServices.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 10/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import Foundation
import Firebase
class AuthServices {
    
    
    static func signIn(email : String, password : String, onSuccess: @escaping () -> Void, onError : @escaping (_ errorMessage : String) -> Void)
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil
            {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
    
    static func signUp(userName : String, email : String, password : String, mobile : String, imageData : Data, onSuccess: @escaping () -> Void, onError : @escaping (_ errorMessage : String) -> Void)
    {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user : FIRUser?, error : Error?) in
            
            if error != nil
            {
                onError(error!.localizedDescription)
                return
            }
            
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference() // reference to Firebase Storage
            print(storageRef.description)
            let allProfileImagesReference = storageRef.child("profile_images")
            let userProfileImageReference = allProfileImagesReference.child(uid!)
            
            
            userProfileImageReference.put(imageData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil
                {
                    print("some error uploading Image to Firebase Storage")
                    return
                }
                
                let profileImageURLString = metadata?.downloadURL()?.absoluteString
                
                self.setUserInformation(profileImageURL: profileImageURLString!, userName: userName, email: email, uid: uid!, mobile: mobile, onSuccess : onSuccess)
                
            })
        })
        
        
    }
    
    
    
    static func setUserInformation(profileImageURL : String, userName : String, email : String, uid : String, mobile : String, onSuccess: @escaping () -> Void )
    {
        let DBRef = FIRDatabase.database().reference()      // reference to Firebase Datbase
        let usersReference = DBRef.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["user_name" : userName, "email" : email, "mobile" : mobile, "profile_Image_URLString" : profileImageURL])
        onSuccess()
    }
    
    
    
    
}
