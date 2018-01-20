//
//  ViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 04/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import SwiftSpinner

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        
        passTextField.attributedPlaceholder = NSAttributedString(string: passTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        loginButton.layer.cornerRadius = 4.0
        loginButton.isEnabled = false
        handleTextFields()
    }
    
    func handleTextFields()
    {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        passTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange()
    {
        guard let email = emailTextField.text, !email.isEmpty, let password = passTextField.text, !password.isEmpty else {
            loginButton.setTitleColor(UIColor.lightGray, for: .normal)
            loginButton.isEnabled = false
            return
        }
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.isEnabled = true
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        view.endEditing(true)
        SwiftSpinner.show("Authenticating")
        AuthServices.signIn(email: emailTextField.text!, password: passTextField.text!, onSuccess: {
            self.downloadUserProfile()
            SwiftSpinner.hide()
            self.performSegue(withIdentifier: "SignInToTabBarVC", sender: nil)
            
        }) { (error) in
            // swiftspinner for Activity Indicator View. 
            SwiftSpinner.show(error, animated: false).addTapHandler({
                SwiftSpinner.hide()
            }, subtitle: "Tap To Try Again!")
        }
        
        
    }
    
    
    func downloadUserProfile()
    {
        if let uid = FIRAuth.auth()?.currentUser?.uid
        {
            let defaults = UserDefaults.standard
            Config.DB_ROOT_REFERENCE.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let dict = snapshot.value as? [String : Any]
                {
                    
                    UserInfo.userProfileImageURL = dict["profile_Image_URLString"] as? String
                    UserInfo.userName = dict["user_name"] as? String
                    
                    defaults.set(dict["user_name"], forKey: "userName")
                    defaults.set(dict["profile_Image_URLString"], forKey:"userProfileImageURL")
                    
                    UserInfo.userProfileImageView?.sd_setImage(with: URL(string: defaults.value(forKey: "userProfileImageURL") as! String))
                    defaults.set(UserInfo.userProfileImageView?.image, forKey: "userProfileImage")
                }
            
                else
                {
                    UserInfo.userProfileImageView?.image = #imageLiteral(resourceName: "userprofileimage")
                    defaults.set(UserInfo.userProfileImageView?.image, forKey: "userProfileImage")
                    UserInfo.userName = "User"
                    defaults.set("User", forKey: "userName")
                }
            }
        }
    }
    
    // touching anywhere else on the screen except keyboard makes It give up Its first Responder Status
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, err) in
            if err != nil
            {
                print("Custom Login Failed")
                
            }
            
            
            self.showFBDetails()
        }
        
    }
    
    func showFBDetails() {
        
        
        let params = ["fields" : "email, name, picture.width(198).height(198)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: params).start { (connection, result, err) in
            
            if err != nil
            {
                print("Graph Request Failed")
                return
            }
            
            print(result)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

