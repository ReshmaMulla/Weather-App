//
//  RouterAPI.swift
//  Appointments
//  Created by Reshma on 10/05/20.
//  Copyright © 2020 Saif Jagirdar. All rights reserved.
//
//

import Foundation
let environment: Environment = .PRODUCTION
enum MethodType:String {
    case GET
    case POST
    case PUT
    case DELETE
}
enum Environment {
    case UAT
    case PreProd
    case PRODUCTION
}
enum Router {
    
    case getTodayForecast(parameters: [String:Any])
    case getFiveDaysWeather(parameters: [String:Any])
    // Scheme
    var scheme: String {
        switch self {
        default:
            switch environment {
            case .PRODUCTION,.PreProd:
              return "https"
            default:
             return "http"
            }
        }
    }

    var host: String {
        switch self {
         default:
            switch environment {
            case .PRODUCTION,.PreProd:
              return "api.openweathermap.org"
            default:
             return "api.openweathermap.org"
            }
            
        }
    }
    var subBase: String {
        switch self {
        default:
            switch environment {
        case .PRODUCTION:
          return "/data/2.5"
        case .PreProd:
                 return "/data/2.5"
        default:
         return  "/data/2.5"
        }
    }
    }
    
    // 4. Path
    var path: String {
        switch self {
        case .getTodayForecast:
            return "/weather"
        case .getFiveDaysWeather:
            return "/forecast"
        }
    }
    var method: MethodType {
        switch self {
        case  .getTodayForecast,.getFiveDaysWeather:
               return MethodType.GET
        }
    }
    
    // 5. Parameters
    var parameters: [String: Any] {
        switch self {
        
        case .getTodayForecast(let param),.getFiveDaysWeather(let param):
            return param
        }
    }
    
    var header: [String: String] {
    return ["Content-Type": "application/json"]
    }
}

