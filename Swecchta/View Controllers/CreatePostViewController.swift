//
//  CreatePostViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 11/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GoogleMaps
import GooglePlaces
import SwiftSpinner

class CreatePostViewController: UIViewController, CLLocationManagerDelegate{
    
    var selectedPostImage : UIImage?
    var currentLocationCoordinates : String?
    var currentLocationAddress : String?
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var clearButton: RoundButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var submitPostButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            placesClient = GMSPlacesClient.shared()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreatePostViewController.handleSelectPostImageView))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.isUserInteractionEnabled = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handlePost()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error occurred in updating locations. Did Fail With Error!")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            currentLocationCoordinates = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
            // Google Places Used
            placesClient.currentPlace(callback: { (placelikelihoods, error) in
                
                if error != nil
                {
                    print("current Place Error! : \(error?.localizedDescription ?? "")")
                    return
                }
                
                if let likelihoodPlace = placelikelihoods?.likelihoods.first
                {
                    self.locationManager.stopUpdatingLocation()
                    let place = likelihoodPlace.place
                    self.currentLocationAddress = place.formattedAddress!
                    self.locationLabel.text = self.currentLocationAddress
                }
            })
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied
        {
            displayLocationDisabledPopUp()
        }
    }
    
    func displayLocationDisabledPopUp()
    {
        let alertController = UIAlertController(title: "Location Access Disallowed", message: "Swecchta Needs Your Location To Geotag Images", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(openSettingsAction)
    }
    
    @objc func handleSelectPostImageView() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func handlePost()
    {
        if selectedPostImage != nil {
            submitPostButton.isEnabled = true
            submitPostButton.setBackgroundImage(#imageLiteral(resourceName: "Orange Fun"), for: .normal)
            clearButton.isEnabled = true
        }else
        {
            submitPostButton.isEnabled = false
            submitPostButton.setBackgroundImage(#imageLiteral(resourceName: "Lawrencium"), for: .normal)
            clearButton.isEnabled = false
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: RoundButton) {
        view.endEditing(true)
        ProgressHUD.show("Posting...", interaction: false)
        
        if let postImg = self.selectedPostImage, let imageData = UIImageJPEGRepresentation(postImg, 0.4)
        {
            let postID = NSUUID().uuidString
            let storageRef = Config.STORAGE_ROOT_REFERENCE.child("posts").child(postID)
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil
                {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                let postURL = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(postImageURL: postURL!)
            })
        }
        else
        {
            ProgressHUD.showError("No Image Selected")
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        cleaner()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func sendDataToDatabase(postImageURL : String)
    {
        let dbRef = Config.DB_ROOT_REFERENCE
        let uid = FIRAuth.auth()?.currentUser?.uid
        let postRef = dbRef.child("users").child(uid!).child("posts")
        let newPostRef = postRef.child(postRef.childByAutoId().key)
        newPostRef.setValue(["postImageURL":postImageURL,"description": descriptionTextField.text!, "currentLocationCoordinates": currentLocationCoordinates, "currentLocationAddress": currentLocationAddress, "postDate": getFormattedDate()]) { (error, ref) in
            
            if error != nil
            {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Successfully Posted")
            //clearing out the fields
            self.cleaner()
            self.tabBarController?.selectedIndex = 0
        }
        
    }
    
    func getFormattedDate() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let postDate = formatter.string(from: date)
        return postDate
    }
    
    func cleaner()
    {
        self.descriptionTextField.text = ""
        self.postImageView.image = UIImage(named: "placeholder.jpg")
        self.selectedPostImage = nil
        handlePost()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension CreatePostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedPostImage = image
            postImageView.image = selectedPostImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
