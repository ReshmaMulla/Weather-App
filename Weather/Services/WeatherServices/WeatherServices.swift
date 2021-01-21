//
//  WeatherServices.swift
//  Weather
//
//  Created by kartheek.p on 21/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import Foundation

enum WeatherResult {
    case Success(WeatherTodayResponse)
    case Error(String)
}
enum WeatherFiveDayResult {
    case Success(WeatherFiveDayForeCastResponse)
    case Error(String)
}
class WeatherServices {
    func getTodayWeather(param: [String: Any], completionHandler: @escaping (WeatherResult) -> Void) {
        ServiceLayer.request(router: Router.getTodayForecast(parameters: param)) { (result: Result<WeatherTodayResponse, Error>) in
            switch result {
            case .success (let responseData):
                guard let status = responseData.statusCode,status == StatusCode.success.rawValue else {
                     completionHandler(.Error("No data found"))
                    return
                }
                completionHandler(.Success(responseData))
            case .failure(let error):
                completionHandler(.Error(error.localizedDescription))
                print(error.localizedDescription)
            }
        }
    }
    func getFiveDayWeather(param: [String: Any], completionHandler: @escaping (WeatherFiveDayResult) -> Void) {
           ServiceLayer.request(router: Router.getFiveDaysWeather(parameters: param)) { (result: Result<WeatherFiveDayForeCastResponse, Error>) in
               switch result {
               case .success (let responseData):
                   guard let status = responseData.statusCode,status == String(StatusCode.success.rawValue) else {
                        completionHandler(.Error("No data found"))
                       return
                   }
                   completionHandler(.Success(responseData))
               case .failure(let error):
                   completionHandler(.Error(error.localizedDescription))
                   print(error.localizedDescription)
               }
           }
       }
}
