//
//  IdentifyDustbinViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 18/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

// 1. Identify current location. 2. Set Map Camera. 3. Show Map. 4. -?
class IdentifyDustbinViewController: UIViewController{

    @IBOutlet weak var mapContainerView: UIView!
    
    
    let locationManager = CLLocationManager()
    var currentLocationCoordinates : String?
    var currentLocation : CLLocation?
    var currentLocationAddress : String?
    
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let defaultLocation = CLLocation(latitude: 28.6139, longitude: 77.2090)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 10.0
            placesClient = GMSPlacesClient.shared()
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapContainerView.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapContainerView.addSubview(mapView)
        mapView.isHidden = true
        
    }
    
    
    
    @IBOutlet weak var selectButton: RoundButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationSelected"
        {
            if let destinationVC = segue.destination as? ConfirmIdentifiedDustbinViewController, let recieved = sender as? LocationAddress
            {
                destinationVC.recievedLocation = recieved
            }
            
        }
    }
    
    
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        if let locationCoord = currentLocation, let address = currentLocationAddress
        {
            let presentLocation = LocationAddress(coord: locationCoord, add: address)
            performSegue(withIdentifier: "locationSelected", sender: presentLocation)
        }
        else
        {
            let presentLocation = LocationAddress(coord: currentLocation!, add: "")
            performSegue(withIdentifier: "locationSelected", sender: presentLocation)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension IdentifyDustbinViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error occurred in updating locations. Did Fail With Error!")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            currentLocationCoordinates = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
            currentLocation = location
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }

            // address using Google Places API
            
            placesClient.currentPlace(callback: { (placelikelihoods, error) in
                
                if error != nil
                {
                    print("current Place Error! : \(error?.localizedDescription ?? "")")
                    return
                }
                
                if let likelihoodPlace = placelikelihoods?.likelihoods.first
                {
                    let place = likelihoodPlace.place
                    self.currentLocationAddress = place.formattedAddress!
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
        let alertController = UIAlertController(title: "Location Access Disallowed", message: "Swecchta Needs Your Location To Locate A Dustbin", preferredStyle: .alert)
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
}


