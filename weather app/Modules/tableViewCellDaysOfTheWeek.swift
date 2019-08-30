//
//  tableViewCellDaysOfTheWeek.swift
//  weather app
//
//  Created by Neill Barnard on 2019/08/29.
//  Copyright © 2019 Neill Barnard. All rights reserved.
//

import UIKit

class tableViewCellDaysOfTheWeek: UITableViewCell {

    //Outlets
    @IBOutlet weak var DayOfTheWeekLabel: UILabel!
    @IBOutlet weak var WeatherConditionImage: UIImageView!
    @IBOutlet weak var MinLabel: UILabel!
    @IBOutlet weak var MaxLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
