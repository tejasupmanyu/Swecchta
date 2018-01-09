//
//  SignUpViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 08/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {

    var selectedProfileImage : UIImage?
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var confPassTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProfileImageView.layer.cornerRadius = ProfileImageView.bounds.height * 0.5
        
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: nameTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        passTextField.attributedPlaceholder = NSAttributedString(string: passTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        confPassTextField.attributedPlaceholder = NSAttributedString(string: confPassTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        mobileTextField.attributedPlaceholder = NSAttributedString(string: mobileTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.7)])
        
        
        joinButton.layer.cornerRadius = 4.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        ProfileImageView.addGestureRecognizer(tapGesture)
        ProfileImageView.isUserInteractionEnabled = true
        
        handleTextFields()
    }
    
    @objc func handleSelectProfileImageView() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    func handleTextFields()
    {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        passTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        confPassTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        mobileTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange()
    {
        guard let name = nameTextField.text, !name.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passTextField.text, !password.isEmpty, let confpass = confPassTextField.text, confpass == password, let mob = mobileTextField.text, !mob.isEmpty else {
            joinButton.setTitleColor(UIColor.lightGray, for: .normal)
            joinButton.isEnabled = false
            return
        }
        joinButton.setTitleColor(UIColor.white, for: .normal)
        joinButton.isEnabled = true
    }
    
    @IBAction func JoinButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text
        {
            if let pass = passTextField.text
            {
                if pass == confPassTextField.text
                {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user : FIRUser?, error : Error?) in
                        
                        if error != nil
                        {
                            print(error?.localizedDescription)
                            print("error creating user")
                            return
                        }
                        
                        let uid = user?.uid
                        let storageRef = FIRStorage.storage().reference() // reference to Firebase Storage
                        print(storageRef.description)
                        let allProfileImagesReference = storageRef.child("profile_images")
                        let userProfileImageReference = allProfileImagesReference.child(uid!)
                    
                        if let profileImg = self.selectedProfileImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.4)
                        {
                            userProfileImageReference.put(imageData, metadata: nil, completion: { (metadata, error) in

                                if error != nil
                                {
                                    print("some error uploading Image to Firebase Storage")
                                    return
                                }
                        
                                let profileImageURLString = metadata?.downloadURL()?.absoluteString
                                let DBRef = FIRDatabase.database().reference()      // reference to Firebase Datbase
                                let usersReference = DBRef.child("users")
                                let newUserReference = usersReference.child(uid!)
                                newUserReference.setValue(["user_name" : self.nameTextField.text!, "email" : self.emailTextField.text!, "mobile" : self.mobileTextField.text!, "profile_Image_URLString" : profileImageURLString])
                                self.performSegue(withIdentifier: "SignUpToTabBarVC", sender: nil)
                            })
                        }
                    })
                }
                else // password and confirm password fields are not same
                {
                    print("Passwords don't match!")
                    return
                }
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedProfileImage = image
            ProfileImageView.image = selectedProfileImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}


