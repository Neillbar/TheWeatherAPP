//
//  HelpFunctions.swift
//  weather app
//
//  Created by Neill Barnard on 2019/08/29.
//  Copyright © 2019 Neill Barnard. All rights reserved.
//

import Foundation


class HelpFunctions{
    
    
    // GET DAY OF THE WEEK EG. 1 = Sunday 2 = Monday
    
    func getDayOfWeek(_ date:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let todayDate = formatter.date(from: date) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    
    
    // CONVERT A STRING TO A DATE FORMAT
    func ConvertStringToDate(date: String) -> Date{
        
        let dateString = date
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFromString = dateFormatter.date(from: dateString)
        
        return dateFromString!
        
    }
    
    
    // COMPARE DATE FUNCTIONS
    
    func CompareDates(newestDate: Date) -> Int{
        
        let calendar = Calendar.current
        let currentDate = Date()
        let date1 = calendar.startOfDay(for: currentDate)
        let date2 = calendar.startOfDay(for: newestDate)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
        
    }
    
    // Determine what day it is
    func determineWhatDayItIs(intDay : Int) -> String{
        let day : String
        switch intDay {
        case 1:
            day = "Sunday"
        case 2:
            day = "Monday"
        case 3:
            day = "Tuesday"
        case 4:
            day = "Wednesday"
        case 5:
            day = "Thursday"
        case 6:
            day = "Friday"
        case 7:
            day = "Saturday"
        default:
            day = "nill"
        }
        
        return day
        
    }
    
  
    //GET MOST FREQUENT VALUE IN STRING ARRAY
    

    func getMostCommonString(array: [String]) -> String {
        var stringDictionary = [String: Int]()
        for string in array {
            stringDictionary[string] = (stringDictionary[string] ?? 0) + 1
        }
      print(stringDictionary)
        
        return stringDictionary.sorted(by: {$0.value > $1.value}).first!.key
        
    }
    
    
}
