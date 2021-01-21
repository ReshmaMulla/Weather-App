//
//  WeatherResponse.swift
//  Weather
//
//  Created by kartheek.p on 20/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import Foundation

struct WeatherFiveDayForeCastResponse: Codable {
     let statusCode: String?
    let foreCastlist:[WeatherTodayResponse]?
    enum CodingKeys: String, CodingKey {
    case statusCode = "cod"
    case foreCastlist = "list"
    }
}
struct WeatherTodayResponse: Codable {
    let statusCode: Int?
    let date: String?
    let weather: [Weather]?
    let details: Details?
    let wind: Wind?
    enum CodingKeys: String, CodingKey {
        case statusCode = "cod"
        case details = "main"
        case date = "dt_txt"
        case weather,wind
    }
    var dateTrimmied: String {
        guard let date = date else {
            return ""
        }
        return date.components(separatedBy: " ")[0]
    }
    
}
struct Weather: Codable {
    let main: String?
    let description: String?
    let icon: String?
}
struct Wind: Codable {
    let speed: Double?
    let deg: Double?
    
}
struct Details: Codable {
    let temp: Double?
    let humidity: Double?
    var tempInCelsius: Double {
        guard let temp = temp else { return -273.15 }
        return temp - 273.15
    }
}
