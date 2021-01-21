//
//  WeatherDetailsDataCell.swift
//  Weather
//
//  Created by kartheek.p on 20/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit

class WeatherDetailsDataCell: UITableViewCell,CellConfiguration {
    @IBOutlet weak private var tempLbl: UILabel!
    @IBOutlet weak private var timeLbl: UILabel!
    @IBOutlet weak private var rainDescipLbl: UILabel!
    @IBOutlet weak private var humidityLbl: UILabel!
    @IBOutlet weak private var weatherLbl: UILabel!
    @IBOutlet weak private var bgView: UIView!
    @IBOutlet weak private var rainIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(data: WeatherTodayResponse) {
        if let date = data.date {
            timeLbl.text = convertDate(date, from: "yyyy-MM-dd HH:mm:ss", to: "h a")
        }else {
            timeLbl.text = "-"
        }
        rainDescipLbl.text = data.weather?[0].description
        humidityLbl.text = "\(data.details?.humidity ?? 0.0) Humidity"
        weatherLbl.text = "\(data.wind?.speed ?? 0.0) \nWind"
        rainIcon.image = UIImage(named: data.weather?[0].icon ?? "Cloudy")
    }
    
}
