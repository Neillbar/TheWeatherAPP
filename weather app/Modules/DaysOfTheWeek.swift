//
//  DaysOfTheWeek.swift
//  weather app
//
//  Created by Neill Barnard on 2019/08/29.
//  Copyright © 2019 Neill Barnard. All rights reserved.
//

import Foundation


class daysOfTheWeek {
    
    var tempMinandMax : [Double]?
    var date : String?
    var dayoftheweek : String?
    var mainWeather : String?
    
    init(TempMinandMax: [Double], Date:String, Dayoftheweek: String, MainWeather: String?) {
        tempMinandMax = TempMinandMax
        date = Date
        dayoftheweek = Dayoftheweek
        mainWeather = MainWeather
    }
    
    
    
    
    
}
