//
//  mainScreenVC.swift
//  weather app
//
//  Created by Neill Barnard on 2019/08/28.
//  Copyright © 2019 Neill Barnard. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class mainScreenVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
   

    //VAR & LET

    let locationManager = CLLocationManager()
    let api = "e4cd138deab3aca9ade2a8b4d390b11b"
    let kelvinAbsoluteZero :Double =  273.15
    let helpFunctions = HelpFunctions()
    var Day1 = [daysOfTheWeek]()
    var Day2 = [daysOfTheWeek]()
    var Day3 = [daysOfTheWeek]()
    var Day4 = [daysOfTheWeek]()
    var Day5 = [daysOfTheWeek]()
    var fullWeek = [daysOfTheWeek]()
    var Day1Test : [String:[Double]] = ["Day1":[],"Day2":[],"Day3":[],"Day4":[],"Day5":[]]
    var MainWeatherTest : [String:[String]] = ["Day1":[],"Day2":[],"Day3":[],"Day4":[],"Day5":[]]
    var Counter = 0
    var MainBackGroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    var city = ""
    var currentLatitude:  Double!
    var currentLongitude:  Double!
    var currentCityNameJson: String!
    var currentCityNameCLLocationManager: String?
    var liveLocation = true
    var TimerToCHeckForLocationChanges = Timer()
    var TimerTOrefreshAllData = Timer()
    
    
    
    //Outlets
    
    @IBOutlet weak var MainCurrentTempLabel: UILabel!
    @IBOutlet weak var smallCurrentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var WeatherTypeLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var middleBarView: UIView!
    @IBOutlet weak var DaysOfTheWeektableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var LikeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            DispatchQueue.main.async {
            self.performSegue(withIdentifier: "AccessLocationVC", sender: nil)
            }
            
        case .denied:
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "AccessLocationVC", sender: nil)
            }
        case .authorizedWhenInUse:
            
            locationManager.delegate = self
            DaysOfTheWeektableView.dataSource = self
            DaysOfTheWeektableView.delegate = self
            DaysOfTheWeektableView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            getCurrentWeather()
            getNextFiveDaysWeather()
            
            TimerToCHeckForLocationChanges = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (Timer) in
            
                self.locationManager.startUpdatingLocation()

            })
            TimerTOrefreshAllData = Timer.scheduledTimer(withTimeInterval: 600, repeats: true, block: { (Timer) in
                
                
                self.getCurrentWeather()
                self.getNextFiveDaysWeather()
   
            })
            
            
        default:
            print("Not yet Determined")
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    // GET CURRENT WEATHER
    func getCurrentWeather(){
        refreshAllData()
        
        if liveLocation == true{
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            currentLatitude = locationManager.location?.coordinate.latitude
            currentLongitude = locationManager.location?.coordinate.longitude
            
            
            
            
            
            
            let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                
                
                if placemarks?.first!.subLocality != nil {
                    self.city = (placemarks?.first!.subLocality)!
                    self.currentCityNameCLLocationManager = self.city
                    
                }
                
                
            })
            
        }// IF statement for current lat and long
        
        let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(currentLatitude!)&lon=\(currentLongitude!)&appid=\(api)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
        
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                // print(json)
                // GET CURRENT TEMPRATURES
            
               //print(json)
                
                if json["cod"] as? String == "404"{
                    DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Oops", message: "Something Goofed, Unfortunately we can't show you all the data now, we will try again in a bit", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                        
                    }
                }else{
       
                let main = json["main"]! as? NSDictionary
                let TempWithoutKelvin = main!["temp"] as? Double
                let TempMaxWithoutKelvin = main!["temp_max"] as? Double
                let TempMinWithoutKelvin = main!["temp_min"] as? Double
                let finalCurrentTemp = (TempWithoutKelvin! - self.kelvinAbsoluteZero).rounded()
                let finalCurrentTempMin = (TempMinWithoutKelvin! - self.kelvinAbsoluteZero).rounded()
                let finalCurrentTempMax = (TempMaxWithoutKelvin! - self.kelvinAbsoluteZero).rounded()
                
                // GET CURRENT WEATHER CONDITIONS
                let weatherArray = json["weather"]! as? [[String:Any]]
                let weatherCondition = weatherArray![0]["main"]! as? String
                
                // GET LOCATION
                let CityID = json["name"]! as? String
                
                
                
                
                // DISPLAY CURRENT WEATHER ON SCREEN
                DispatchQueue.main.async {
                    
                    
                    
                    self.MainCurrentTempLabel.text = "\(Int(finalCurrentTemp))°"
                    self.smallCurrentTempLabel.text = "\(Int(finalCurrentTemp))°"
                    self.minTempLabel.text = "\(Int(finalCurrentTempMin))°"
                    self.maxTempLabel.text = "\(Int(finalCurrentTempMax))°"
                    self.WeatherTypeLabel.text = weatherCondition
                    self.cityNameLabel.text = CityID
                    self.currentCityNameJson = CityID!
                    
                    
                    
                    switch weatherCondition{
                    case "Clouds" :
                        self.backgroundImage.image = #imageLiteral(resourceName: "sea_cloudy")
                        self.middleBarView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.4431372549, blue: 0.4784313725, alpha: 1)
                        self.MainBackGroundColor = #colorLiteral(red: 0.3294117647, green: 0.4431372549, blue: 0.4784313725, alpha: 1)
                        self.view.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.4431372549, blue: 0.4784313725, alpha: 1)
                        self.DaysOfTheWeektableView.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.4431372549, blue: 0.4784313725, alpha: 1)
                        
                    case "Clear" :
                        self.backgroundImage.image = #imageLiteral(resourceName: "sea_sunnypng")
                        self.MainBackGroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                        self.DaysOfTheWeektableView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                        
                    case "Rain" :
                        self.backgroundImage.image = #imageLiteral(resourceName: "sea_rainy")
                        self.middleBarView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3647058824, alpha: 1)
                        self.MainBackGroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3647058824, alpha: 1)
                        self.view.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3647058824, alpha: 1)
                        self.DaysOfTheWeektableView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3647058824, alpha: 1)
                        
                    default:
                        self.backgroundImage.image = #imageLiteral(resourceName: "sea_sunnypng")
                        self.MainBackGroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                        
                        
                    }
                    
                    
                    // SEE IF CURRENT CITY IS SAVED UNDER FAVOURITES
                    let AllFavLocations = self.helpFunctions.FetchAllLocations()
                    if AllFavLocations.2.contains(self.currentCityNameJson){
                        
                        self.LikeButton.isSelected = true
                    }else{
                        self.LikeButton.isSelected = false
                        
                    }
                    
                    
                    
                }
    
                 }// If there are no errors
            }catch{
                print(error.localizedDescription)
            }
            
        })
        task.resume()
     
        
    }
    
    
    
    
    
    
    
    
    //GET The next 5 days weather
    
    func getNextFiveDaysWeather(){
        
        refreshAllData()
   
        let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(currentLatitude!)&lon=\(currentLongitude!)&appid=\(api)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
               print(json)
                let allInformation = json["list"]! as? [NSDictionary]
           
                for _ in allInformation!{
                    
                    if self.Counter < allInformation!.count{
                    let dateSelected = allInformation![self.Counter]["dt_txt"] as? String
                    let ConvertedDate = self.helpFunctions.ConvertStringToDate(date: dateSelected!)
                    let CompareDate = self.helpFunctions.CompareDates(newestDate: ConvertedDate)
                   // print(CompareDate)
                    let MainData = allInformation![self.Counter]["main"] as? NSDictionary
                    let MinTemp = MainData!["temp_min"] as? Double
                    let MaxTemp = MainData!["temp_max"] as? Double
                    let Date = allInformation![self.Counter]["dt_txt"] as? String
                    let WeatherData = allInformation![self.Counter]["weather"] as? [[String:Any]]
                    let WeatherMain = WeatherData![0]["main"] as? String
                    let dayoftheweekint = self.helpFunctions.getDayOfWeek(Date!)
                    let dayoftheweek = self.helpFunctions.determineWhatDayItIs(intDay: dayoftheweekint!)
                   
                    
                    
                 //   print(WeatherMain!)
                    
                    switch CompareDate{
                        
                        case 1:
                            
                            self.Day1Test["Day1"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day1"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day1"]?.append(WeatherMain!)
                            let MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day1"]! )
                            
                            
                            let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day1"]! , Date: Date!,Dayoftheweek: dayoftheweek, MainWeather: MostFrequentWeather)]
                           self.Day1.append(contentsOf: newData)
                       
                        case 2:
                            self.Day1Test["Day2"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day2"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day2"]?.append(WeatherMain!)
                            let MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day2"]! )
                           let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day2"]! , Date: Date!,Dayoftheweek: dayoftheweek,MainWeather: MostFrequentWeather)]
                            self.Day2.append(contentsOf: newData)
                        
                        case 3:
                            self.Day1Test["Day3"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day3"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day3"]?.append(WeatherMain!)
                            let MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day3"]! )
                            let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day3"]! , Date: Date!,Dayoftheweek: dayoftheweek, MainWeather:MostFrequentWeather)]
                            self.Day3.append(contentsOf: newData)
                        
                        case 4:
                            self.Day1Test["Day4"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day4"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day4"]?.append(WeatherMain!)
                            let MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day4"]! )
                           let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day4"]! , Date: Date!,Dayoftheweek: dayoftheweek,MainWeather: MostFrequentWeather)]
                            self.Day4.append(contentsOf: newData)
                        
                        case 5:
                            self.Day1Test["Day5"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day5"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day5"]?.append(WeatherMain!)
                            let MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day5"]! )
                           let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day5"]! , Date: Date!,Dayoftheweek: dayoftheweek,MainWeather: MostFrequentWeather)]
                            self.Day5.append(contentsOf: newData)
                        
                     default:
                        print("Nothing")
                        
                        
                    }
                    
        
                   }// IF Counter is smaller than the rest
                   
                    self.Counter = self.Counter + 1
                }
                
                DispatchQueue.main.async {
                    
                   // print(self.Day1.last!.dayoftheweek!)
                    self.fullWeek.append(self.Day1.last!)
                    self.fullWeek.append(self.Day2.last!)
                    self.fullWeek.append(self.Day3.last!)
                    self.fullWeek.append(self.Day4.last!)
                    if self.Day5.isEmpty == false{
                      self.fullWeek.append(self.Day5.last!)
                    }
                    self.DaysOfTheWeektableView.reloadData()
   
                 
                    
                    
                    
                }
                
                
            }catch{
                
              
            }
            
        })// end of task
    task.resume()
        
    
        
    
    }
    
    
   
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? tableViewCellDaysOfTheWeek
        
        if fullWeek.isEmpty == false{
           
            cell?.DayOfTheWeekLabel.text = fullWeek[indexPath.row].dayoftheweek
            cell?.MinLabel.text = "\(Int((fullWeek[indexPath.row].tempMinandMax?.min())!))°"
           cell?.MaxLabel.text = "\(Int((fullWeek[indexPath.row].tempMinandMax?.max())!))°"
            
            switch fullWeek[indexPath.row].mainWeather{
                
            case "Clouds":
                cell?.WeatherConditionImage.image = #imageLiteral(resourceName: "partlysunny")
                cell?.backgroundColor = MainBackGroundColor
                
            case "Clear":
                 cell?.WeatherConditionImage.image = #imageLiteral(resourceName: "clear")
                cell?.backgroundColor = MainBackGroundColor
            case "Rain":
                
                cell?.WeatherConditionImage.image = #imageLiteral(resourceName: "rain")
                cell?.backgroundColor = MainBackGroundColor
                
            case "Default":
                print("error")
                
            case .none:
                print("None")
            case .some(_):
                print("Some")
            }
            
          
            
            
            
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return CGSize(width: view.frame.width, height: DaysOfTheWeektableView.frame.height/4)
        return CGFloat(DaysOfTheWeektableView.frame.height/5)
        
    }
    
  
    
    

    
    
    
    
    @IBAction func LikeButtonWasPressed(_ sender: Any) {
        
       
        if LikeButton.isSelected == false{
            
            helpFunctions.SaveFavLocation(lat: currentLatitude!, long: currentLongitude!, Name: currentCityNameJson!)
            LikeButton.isSelected = true
            
        }else{
            
            helpFunctions.DeleteSelectedLocation(CityName: currentCityNameJson)
            LikeButton.isSelected = false
            
        }
       
        
        
    }
    
    
  
 
    @IBAction func LocationButtonWasPressed(_ sender: Any) {
        
    
    let AllLocations = helpFunctions.FetchAllLocations()
    
        if AllLocations.2.isEmpty == false{
            
            performSegue(withIdentifier: "FavScreen", sender: nil)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
      
        var lat: Double?
        var Long: Double?
        
        
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            
            if  let latitude = locationManager.location?.coordinate.latitude {
                
                
                lat = latitude
                
            }
            if let longitude = locationManager.location?.coordinate.longitude{
                
                Long = longitude
                
                
            }
        
        
        let location = CLLocation(latitude: lat!, longitude: Long!)
        
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        
                  
                    if placemarks?.first!.subLocality != nil {
                        self.city = (placemarks?.first!.subLocality)!
                       // print(self.city)
                    if self.city != self.currentCityNameCLLocationManager && self.liveLocation == true {
                       
                       
                        self.getCurrentWeather()
                        self.getNextFiveDaysWeather()
                        self.locationManager.stopUpdatingLocation()
                        //print("updating")
                       
                        
                        
                    }else{
                       // print("Nothing to update")
                        
                         self.locationManager.stopUpdatingLocation()
                      
                        
                        }
                    }// is locality available?
        
                })
        
 
            
    }
    
    func refreshAllData(){
        Day1.removeAll()
        Day2.removeAll()
        Day3.removeAll()
        Day4.removeAll()
        Day5.removeAll()
        fullWeek.removeAll()
        Counter = 0
        Day1Test  = ["Day1":[],"Day2":[],"Day3":[],"Day4":[],"Day5":[]]
        MainWeatherTest = ["Day1":[],"Day2":[],"Day3":[],"Day4":[],"Day5":[]]
        
        
    }
    
    
    
}// END OF CLASS
