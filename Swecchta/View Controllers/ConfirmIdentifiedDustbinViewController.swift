//
//  ConfirmIdentifiedDustbinViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 18/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
import Firebase

class ConfirmIdentifiedDustbinViewController: UIViewController {
    
    var recievedLocation : LocationAddress?
    var snappedImage : UIImage?
    
    @IBOutlet weak var dustbinImage: RoundImageView!
    
    @IBOutlet weak var dustbinCoordinates: UILabel!
    
    @IBOutlet weak var confirmButton: RoundButton!
    
    @IBOutlet weak var dustbinLocationAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        if recievedLocation != nil
        {
            dustbinCoordinates.text = "\(recievedLocation!.coordinates.coordinate.latitude), \(recievedLocation!.coordinates.coordinate.longitude)"
            dustbinLocationAddress.text = recievedLocation!.address
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ConfirmIdentifiedDustbinViewController.handleSelectPostImageView))
        dustbinImage.addGestureRecognizer(tapGesture)
        dustbinImage.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handlePost()
    }
    
    
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        ProgressHUD.show("Submtting...Thanks for your support!", interaction: false)
        
        if let dbinImage = self.snappedImage, let imgData = UIImageJPEGRepresentation(dbinImage, 0.4)
        {
            let dbinID = NSUUID().uuidString
            let storageRef = Config.STORAGE_ROOT_REFERENCE.child("dbins").child(dbinID)
            storageRef.put(imgData, metadata: nil, completion: { (meta, error) in
                if error != nil
                {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                let dbinImageURL = meta?.downloadURL()?.absoluteString
                self.sendDataToDatabase(dbinImageURL: dbinImageURL!)
                
            })
        }
        else
        {
            ProgressHUD.showError("No Image Snapped")
        }
        
        
    }
    
    // send the stored image url to database...
    
    func sendDataToDatabase(dbinImageURL : String)
    {
        let dbRef = Config.DB_ROOT_REFERENCE
        let uid = FIRAuth.auth()?.currentUser?.uid
        let dbinRef = dbRef.child("users").child(uid!).child("dustbins_Identified")
        let newDbinRef = dbinRef.child(dbinRef.childByAutoId().key)
        let globalDbinRef = dbRef.child("dbins")
        
        let newGlobalDbinRef = globalDbinRef.child(globalDbinRef.childByAutoId().key)
        
        
        newDbinRef.setValue(["dbinImageURL" : dbinImageURL, "coordinates" : dustbinCoordinates.text!, "address" : recievedLocation?.address, "date": getFormattedDate()]) { (error, ref) in
            if error != nil
            {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            // posting the data globally for locating ...
            newGlobalDbinRef.setValue(["dbinImageURL" : dbinImageURL, "coordinates" : self.dustbinCoordinates.text!, "address" : self.recievedLocation?.address, "date": self.getFormattedDate(), "Identifier_User" : uid], withCompletionBlock: { (err, reference) in
                
                if err != nil
                {
                    ProgressHUD.showError(err!.localizedDescription)
                    return
                }
                
                print("globally Posted Dustbin!")
                
            })
            
            ProgressHUD.showSuccess("Successfully Posted")
            //clearing out the fields
            self.cleaner()
            self.navigationController?.popToRootViewController(animated: true)
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
        self.dustbinCoordinates.text = ""
        self.dustbinLocationAddress.text = ""
        self.dustbinImage.image = UIImage(named: "placeholder.jpg")
        self.snappedImage = nil
        handlePost()
    }
    
    
    
    @objc func handleSelectPostImageView() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            pickerController.allowsEditing = false
            present(pickerController, animated: true, completion: nil)
        }
        
        handlePost()
        
    }
    
    func handlePost()
    {
        if snappedImage != nil {
            confirmButton.isEnabled = true
            confirmButton.setBackgroundImage(#imageLiteral(resourceName: "Ohhappiness"), for: .normal)
            
        }else
        {
            confirmButton.isEnabled = false
            confirmButton.setBackgroundImage(#imageLiteral(resourceName: "Lawrencium"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ConfirmIdentifiedDustbinViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            snappedImage = image
            dustbinImage.image = snappedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
