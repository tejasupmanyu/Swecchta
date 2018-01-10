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

class CreatePostViewController: UIViewController, CLLocationManagerDelegate{
    
    var selectedPostImage : UIImage?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var postImageView: UIImageView!
    
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
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreatePostViewController.handleSelectPostImageView))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.isUserInteractionEnabled = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error occurred in updating locations. Did Fail With Error!")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil
                {
                    print("Error in reverse Geocoding!!")
                    return
                }
                
                if let pm = placemarks?[0]
                {
                    self.displayLocationInfo(placemark: pm)
                }
                else
                {
                    print("problem with location data recieved")
                }
            })
        }
    }
    
    
    // prints addresses
    func displayLocationInfo(placemark : CLPlacemark)
    {
        locationManager.stopUpdatingLocation()
        print(placemark.thoroughfare ?? placemark.locality ?? "")
        print(placemark.subThoroughfare ?? placemark.subLocality ?? "")
        locationLabel.text = "\(placemark.subThoroughfare ?? "Sub Address"), \(placemark.thoroughfare ?? "Address"), \(placemark.locality ?? "locality"), \(placemark.administrativeArea ?? "state")"
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
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func submitButtonPressed(_ sender: RoundButton) {
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
