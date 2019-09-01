//
//  ViewController.swift
//  weather app
//
//  Created by Neill Barnard on 2019/08/27.
//  Copyright © 2019 Neill Barnard. All rights reserved.
//

import UIKit
import CoreLocation

class allowAccesVC: UIViewController, CLLocationManagerDelegate {
// Variables
    let locationManager = CLLocationManager()
 
   
    
//Outlets
    @IBOutlet weak var ShowMeTheWeatherButton: UIButton!
    @IBOutlet weak var allowAccessButton: UIButton!
     @IBOutlet weak var welcomeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

       welcomeText.text = "My name is 'The Weather Guy', and these are my friends. \n  Weather it up by allowing me to see your location? "
    
        
        
    }


    @IBAction func allowAccessButtonWasPressed(_ sender: Any) {
       
        self.locationManager.requestWhenInUseAuthorization()
       getPremission()
    
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        switch status {
        case .authorizedWhenInUse:
            ChangeScreen()
        default:
            getPremission()
        }
        
        
    }// END OF FUNC
    
    
    func getPremission(){
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .authorizedWhenInUse:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            ShowMeTheWeatherButton.isHidden = false
            allowAccessButton.isHidden = true
            welcomeText.text = "Nice work! Now click on the button already so i can show you, your weather!"
        case .denied:
            allowAccessButton.setTitle("ACCESS DENIED", for: UIControl.State.normal)
            
            
            let alert = UIAlertController(title: "ACCESS DENIED", message: "You denied access for us to see your location, unfortunately this app won't work if we don't have your location. If you want to change this please go to settings and manually change it.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "SETTINGS", style: .default, handler: { action in
                if !CLLocationManager.locationServicesEnabled() {
                    if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                        // If general location settings are disabled then open general location settings
                        //UIApplication.shared.openURL(url)
                        UIApplication.shared.open(url)
                    }
                } else {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        // If general location settings are enabled then open location settings for the app
                        //UIApplication.shared.openURL(url)
                        UIApplication.shared.open(url)
                    }
                }
                
            }))
            alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { action in
                print("CANCEL")
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            
            
            
            
            
        default:
            print("Nothing selected")
        }
        
        
        
    }
    
    // CHANGE TO THE MAIN SCREEN
    
    func ChangeScreen(){
        performSegue(withIdentifier: "MainScreen", sender: nil)
        
        
        
    }
    
}// END OF CLASS

