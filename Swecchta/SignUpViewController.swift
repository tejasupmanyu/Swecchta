//
//  SignUpViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 08/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

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
        joinButton.isEnabled = false
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func JoinButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        SwiftSpinner.show("Signing You Up...", animated: true)
        if confPassTextField.text! == passTextField.text!
        {
            if let profileImg = self.selectedProfileImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.4)
            {
                AuthServices.signUp(userName: nameTextField.text!, email: emailTextField.text!, password: passTextField.text!,mobile: mobileTextField.text!, imageData: imageData, onSuccess: {
                    SwiftSpinner.hide()
                    self.performSegue(withIdentifier: "SignUpToTabBarVC", sender: nil)
                }, onError: { (error) in
                    SwiftSpinner.show(error, animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    }, subtitle: "Tap To Try Again!")
                })
            }
        }
        else
        {
            SwiftSpinner.show("Passwords Don't Match", animated: false).addTapHandler({
                SwiftSpinner.hide()
            }, subtitle: "Tap To Try Again!")
            return
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


