//
//  SelectfavLocationVC.swift
//  weather app
//
//  Created by Neill Barnard on 2019/09/02.
//  Copyright © 2019 Neill Barnard. All rights reserved.
//

import UIKit
import Foundation


class SelectfavLocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    //VAR
    var ALlLat : [Double]?
    var Alllong: [Double]?
    var AllNames: [String]?
    var livelocation: Bool?
    
    var SelectedLong: Double?
    var SelectedLat: Double?
    
    let helpfunctions = HelpFunctions()
  
    @IBOutlet weak var FavTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavTableView.dataSource = self
        FavTableView.delegate = self
        let ALLData = helpfunctions.FetchAllLocations()
        ALlLat = ALLData.0
        Alllong = ALLData.1
        AllNames = ALLData.2
        FavTableView.reloadData()
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllNames!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? SelectfavLocationCell
        
        cell?.DisplayFavCity.text = AllNames![indexPath.row]
        
        
        return cell!
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(AllNames![indexPath.row])
        SelectedLat = ALlLat![indexPath.row]
        SelectedLong = Alllong![indexPath.row]
        livelocation = false
        
        performSegue(withIdentifier: "BackToMain", sender: self)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            helpfunctions.DeleteSelectedLocation(CityName: AllNames![indexPath.row])
            AllNames?.remove(at: indexPath.row)
            ALlLat?.remove(at: indexPath.row)
            Alllong?.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    
    
    @IBAction func CurrentLocationButtonWasPressed(_ sender: Any) {
        
        SelectedLat = nil
        SelectedLong = nil
        livelocation = true
        
        performSegue(withIdentifier: "BackToMain", sender: nil)
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainScrenVc = segue.destination as? mainScreenVC
        mainScrenVc?.currentLongitude = SelectedLong
        mainScrenVc?.currentLatitude = SelectedLat
        mainScrenVc?.liveLocation = livelocation!
        
    }
    
    
    

}
