//
//  AllPostsViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 12/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class AllPostsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    static var uid = FIRAuth.auth()?.currentUser?.uid
    static var profileImageURLString : String?
    static var user_Name : String?
    static var User_Profile_Image = UIImage(named: "userProfileImage.jpg")
    static var postCount : Int?
    
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadUserProfile()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        loadMyPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMyPosts()
        tableView.reloadData()
        ProgressHUD.showSuccess()
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
                    print("Ye hai url - \(UserInfo.userProfileImageURL!)")
                    UserInfo.userName = dict["user_name"] as? String
                    
                    defaults.set(dict["user_name"], forKey: "userName")
                    defaults.set(dict["profile_Image_URLString"], forKey:"userProfileImageURL")
                }
                    
                else
                {
                    UserInfo.userProfileImageView?.image = #imageLiteral(resourceName: "userprofileimage")
                    UserInfo.userName = "User"
                    defaults.set("User", forKey: "userName")
                }
            }
        }
    }
    
    func loadMyPosts()
    {
        
       //posts.removeAll()
       ProgressHUD.show("Loading Posts...", interaction: false)
        Config.DB_ROOT_REFERENCE.child("users").child(UserInfo.uid!).child("posts").queryOrderedByKey().observe(.value) { (snapshot) in
            
            self.posts = [Post]()
            if let allPosts = snapshot.value as? [String: AnyObject]
            {
                
                if allPosts.count == 0
                {
                    //self.tableView.isHidden = true
                    return
                }
                else
                {
                    //self.tableView.isHidden = false
                    
                    for (_,posts) in allPosts
                    {
                        let individualPost = Post()
                        if let description = posts["description"] as? String, let postImgUrl = posts["postImageURL"] as? String, let coordinates = posts["currentLocationCoordinates"] as? String, let address = posts["currentLocationAddress"] as? String, let postDate = posts["postDate"] as? String
                        {
                            individualPost.description = description
                            individualPost.currentLocationAddress = address
                            individualPost.currentLocationCoordinates = coordinates
                            individualPost.postDate = postDate
                            individualPost.postImageURL = postImgUrl
                            
                            self.posts.append(individualPost)
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
            
        }
        Config.DB_ROOT_REFERENCE.removeAllObservers() // removing observers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AllPostsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        AllPostsViewController.postCount = posts.count
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as!  AllPostsTableViewCell
        
        if let imgURL = UserDefaults.standard.string(forKey: "userProfileImageURL")
        {
            cell.UserProfileImage.sd_setImage(with: URL(string: imgURL), placeholderImage: #imageLiteral(resourceName: "userprofileimage"))
        }
        else
        {
            cell.UserProfileImage.image = #imageLiteral(resourceName: "userprofileimage")
        }
        cell.postImageView.sd_showActivityIndicatorView()
        cell.postImageView.sd_setIndicatorStyle(.whiteLarge)
        cell.postImageView.sd_setImage(with: URL(string: self.posts[indexPath.section].postImageURL!), placeholderImage: UIImage(named:"placeholder"), options: [.progressiveDownload,.continueInBackground,.scaleDownLargeImages,])
        cell.addressLabel.text = self.posts[indexPath.section].currentLocationAddress
        cell.coordinatesLabel.text = self.posts[indexPath.section].currentLocationCoordinates
        cell.postDescriptionLabel.text = self.posts[indexPath.section].description
        return cell
    }
}


