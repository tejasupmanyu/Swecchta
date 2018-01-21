//
//  LocateDustbinViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 18/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import GooglePlaces

class LocateDustbinViewController: UIViewController {

    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var NavigateButton: RoundButton!
    
    let locationManager = CLLocationManager()
    var currentLocationCoordinates : String?
    var currentLocation : CLLocation?
    var currentLocationAddress : String?
    
    var dbinPoints = [DustbinPoint]()
    
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
        loadMarkerData() // loading markers
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
    
    
    func loadMarkerData()
    {
        Config.DB_ROOT_REFERENCE.child("dbins").queryOrderedByKey().observe(.value) { (snapshot) in
            
            self.dbinPoints = [DustbinPoint]()
            if let allDbins = snapshot.value as? [String : AnyObject]
            {
                if allDbins.count != 0
                {
                    for (_,dbins) in allDbins
                    {
                        let dbin = DustbinPoint()
                        
                        if let coordinateString = dbins["coordinates"] as? String, let address = dbins["address"] as? String, let date = dbins["date"] as? String, let user = dbins["Identifier_User"] as? String
                        {
                            dbin.coordinatesString = coordinateString
                            print(coordinateString)
                            dbin.address = address
                            dbin.Identified_date = date
                            dbin.identifiedByUID = user
                            dbin.coordinates = self.extractor(coordinateString: coordinateString)
                            
                        }
                        
                        self.dbinPoints.append(dbin)
                        self.placeMarkers(dbin: dbin)
                    }
                }
            }
        }
        Config.DB_ROOT_REFERENCE.removeAllObservers()
        
    }
    
    func extractor(coordinateString : String) -> CLLocationCoordinate2D
    {
        var lat = coordinateString.split(separator: ",")[0]
        var long = coordinateString.split(separator: ",")[1].trimmingCharacters(in: .whitespacesAndNewlines)
        return CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
    }

    func placeMarkers(dbin : DustbinPoint)
    {
            print("printing dbin")
            print(dbin)
            let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: dbin.coordinates!.latitude, longitude: dbin.coordinates!.longitude)
        
            marker.title = dbin.address
            marker.appearAnimation = .pop
            marker.icon = #imageLiteral(resourceName: "icons8-trash-100")
            marker.snippet = dbin.coordinatesString
            marker.map = self.mapView

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension LocateDustbinViewController : CLLocationManagerDelegate
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




