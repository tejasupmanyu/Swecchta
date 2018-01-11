//
//  ProfileViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 10/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logOutError {
            print(logOutError.localizedDescription)
            print("Error Logging Out!")
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
