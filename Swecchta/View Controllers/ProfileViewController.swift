//
//  ProfileViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 10/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileImage: RoundImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var residenceLabel: UILabel!
    
    @IBOutlet weak var BioLabel: UILabel!
    
    @IBOutlet weak var noOfPostsLabel: UILabel!
    
    @IBOutlet weak var noOfDustbinsIdentifiedLabel: UILabel!
    
    @IBOutlet weak var editDetailsButton: UIButton!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if FIRAuth.auth()?.currentUser != nil
        {
            userProfileImage.sd_setImage(with: URL(string : UserInfo.userProfileImageURL!), placeholderImage: #imageLiteral(resourceName: "userprofileimage"))
            userNameLabel.text = User.getUserName()
            noOfPostsLabel.text = "\(AllPostsViewController.postCount ?? 0) Posts"
            logOutButton.setTitle("Not \(userNameLabel.text ?? "You")? Log Out.", for: .normal)
        }
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logOutError {
            print(logOutError.localizedDescription)
            print("Error Logging Out!")
        }
        User.clearUserDefaults()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIImageView{
    func downloadImage(from url: String)
    {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){(data,response,error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
