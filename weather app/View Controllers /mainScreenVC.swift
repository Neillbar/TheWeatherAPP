//
//  mainScreenVC.swift
//  weather app
//
//  Created by Neill Barnard on 2019/08/28.
//  Copyright © 2019 Neill Barnard. All rights reserved.
//

import UIKit
import CoreLocation

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
    var i = 0
    var MainBackGroundColor = UIColor()
    
    
    
    
    //Outlets
    
    @IBOutlet weak var MainCurrentTempLabel: UILabel!
    @IBOutlet weak var smallCurrentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var WeatherTypeLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var middleBarView: UIView!
    @IBOutlet weak var DaysOfTheWeektableView: UITableView!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        DaysOfTheWeektableView.dataSource = self
        DaysOfTheWeektableView.delegate = self
       DaysOfTheWeektableView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        getCurrentWeather()
       getNextFiveDaysWeather()
        
        
        
        
    }
    
    
    func getNextFiveDaysWeather(){
        var lat : Double!
        var long : Double!
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if  let latitude = locationManager.location?.coordinate.latitude {
            
            lat = latitude
           // lat = -25.868876232267652
        }
        if let longitude = locationManager.location?.coordinate.longitude{
            
            long = longitude
           // long = 28.174742713825285
            
        }
   
       // let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat!)&lon=\(long!)&appid=\(api)")!)
        let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=london,uk&appid=e4cd138deab3aca9ade2a8b4d390b11b")!)
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
              // print(json)
                let allInformation = json["list"]! as? [NSDictionary]
               
                
                
                for _ in allInformation!{
                    let dateSelected = allInformation![self.i]["dt_txt"] as? String
                    let ConvertedDate = self.helpFunctions.ConvertStringToDate(date: dateSelected!)
                    let CompareDate = self.helpFunctions.CompareDates(newestDate: ConvertedDate)
                   // print(CompareDate)
                    let MainData = allInformation![self.i]["main"] as? NSDictionary
                    let MinTemp = MainData!["temp_min"] as? Double
                    let MaxTemp = MainData!["temp_max"] as? Double
                    let Date = allInformation![self.i]["dt_txt"] as? String
                    let WeatherData = allInformation![self.i]["weather"] as? [[String:Any]]
                    let WeatherMain = WeatherData![0]["main"] as? String
                    let dayoftheweekint = self.helpFunctions.getDayOfWeek(Date!)
                    let dayoftheweek = self.helpFunctions.determineWhatDayItIs(intDay: dayoftheweekint!)
                   
                    print(WeatherMain!)
                    
                    switch CompareDate{
                        
                        case 1:
                            
                            self.Day1Test["Day1"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day1"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day1"]?.append(WeatherMain!)
                            var MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day1"]! )
                            
                            
                            let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day1"]! , Date: Date!,Dayoftheweek: dayoftheweek, MainWeather: MostFrequentWeather)]
                           self.Day1.append(contentsOf: newData)
                       
                        case 2:
                            self.Day1Test["Day2"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day2"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day2"]?.append(WeatherMain!)
                            var MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day2"]! )
                           let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day2"]! , Date: Date!,Dayoftheweek: dayoftheweek,MainWeather: MostFrequentWeather)]
                            self.Day2.append(contentsOf: newData)
                        
                        case 3:
                            self.Day1Test["Day3"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day3"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day3"]?.append(WeatherMain!)
                            var MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day3"]! )
                            let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day3"]! , Date: Date!,Dayoftheweek: dayoftheweek, MainWeather:MostFrequentWeather)]
                            self.Day3.append(contentsOf: newData)
                        
                        case 4:
                            self.Day1Test["Day4"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day4"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day4"]?.append(WeatherMain!)
                            var MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day4"]! )
                           let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day4"]! , Date: Date!,Dayoftheweek: dayoftheweek,MainWeather: MostFrequentWeather)]
                            self.Day4.append(contentsOf: newData)
                        
                        case 5:
                            self.Day1Test["Day5"]?.append((MinTemp! - self.kelvinAbsoluteZero).rounded())
                            self.Day1Test["Day5"]?.append((MaxTemp! - self.kelvinAbsoluteZero).rounded())
                            self.MainWeatherTest["Day5"]?.append(WeatherMain!)
                            var MostFrequentWeather = self.helpFunctions.getMostCommonString(array: self.MainWeatherTest["Day5"]! )
                           let newData = [daysOfTheWeek(TempMinandMax: self.Day1Test["Day5"]! , Date: Date!,Dayoftheweek: dayoftheweek,MainWeather: MostFrequentWeather)]
                            self.Day5.append(contentsOf: newData)
                        
                     default:
                        print("Nothing")
                        
                        
                    }
                    
        
                    self.i = self.i + 1
                   
              
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
    
  
    
    
    // GET CURRENT WEATHER
    func getCurrentWeather(){
        var lat : Double!
        var long : Double!
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if  let latitude = locationManager.location?.coordinate.latitude {
            
             lat = latitude
            //lat = -25.868876232267652
        }
        if let longitude = locationManager.location?.coordinate.longitude{
            
             long = longitude
           // long = 28.174742713825285
        
        }
        
       // let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat!)&lon=\(long!)&appid=\(api)")!)
        let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?q=london,uk&appid=e4cd138deab3aca9ade2a8b4d390b11b")!)
        //print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
        print(json)
                // GET CURRENT TEMPRATURES
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
                
               
                
                
                
                 // DISPLAY CURRENT WEATHER ON SCREEN
                DispatchQueue.main.async {
                    self.MainCurrentTempLabel.text = "\(Int(finalCurrentTemp))°"
                    self.smallCurrentTempLabel.text = "\(Int(finalCurrentTemp))°"
                    self.minTempLabel.text = "\(Int(finalCurrentTempMin))°"
                    self.maxTempLabel.text = "\(Int(finalCurrentTempMax))°"
                    self.WeatherTypeLabel.text = weatherCondition
                    
                    
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
    
                }
               
                
                
            }catch{
                print(error.localizedDescription)
            }
            
            })
        task.resume()
        
        
    }
    
    
    
    
  
  
 
    
   
    
    
    
}
