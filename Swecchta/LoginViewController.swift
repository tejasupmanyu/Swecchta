//
//  ViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 04/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        
        passTextField.attributedPlaceholder = NSAttributedString(string: passTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        loginButton.layer.cornerRadius = 4.0
       
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

