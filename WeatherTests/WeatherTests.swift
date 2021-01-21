//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {

    private let weatherService = WeatherServices()
    private var session = URLSession(configuration: .default)
    
    func testParseNonForOneDayJson() {
        let data = "Just a plain error".data(using: String.Encoding.utf8)!
        guard case .failure = ServiceLayer.decode(WeatherTodayResponse.self, from: data) else {
            XCTFail("Couldn't recognize JSON response")
            return
        }
    }
    func testParseNonForFiveDayJson() {
        let data = "Just a plain error".data(using: String.Encoding.utf8)!
        guard case .failure = ServiceLayer.decode(WeatherFiveDayForeCastResponse.self, from: data) else {
            XCTFail("Couldn't recognize JSON response")
            return
        }
    }

    func testParseJsonWithoutExpectedOneDayWeatherData() {
        let data = "{ \"temp\": 42.0, \"main\": \"hello\" }".data(using: String.Encoding.utf8)!
        guard case .failure = ServiceLayer.decode(WeatherTodayResponse.self, from: data) else {
            XCTFail("Couldn't recognize JSON response")
            return
        }
    }
    func testParseJsonWithoutExpectedFiveDayWeatherData() {
        let data = "{ \"temp\": 42.0, \"main\": \"hello\"}".data(using: String.Encoding.utf8)!
        guard case .failure = ServiceLayer.decode(WeatherFiveDayForeCastResponse.self, from: data) else {
            XCTFail("Couldn't recognize JSON response")
            return
        }
    }
    func testValidJsonOneDay() {
        let data = "{\"coord\":{\"lon\":0,\"lat\":0},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03d\"}],\"base\":\"stations\",\"main\":{\"temp\":300.11,\"feels_like\":300.89,\"temp_min\":300.11,\"temp_max\":300.11,\"pressure\":1011,\"humidity\":79,\"sea_level\":1011,\"grnd_level\":1011},\"visibility\":10000,\"wind\":{\"speed\":6.37,\"deg\":174},\"clouds\":{\"all\":49},\"dt\":1611231023,\"sys\":{\"sunrise\":1611209257,\"sunset\":1611252881},\"timezone\":0,\"id\":6295630,\"name\":\"Globe\",\"cod\":200}".data(using: String.Encoding.utf8)!
        guard case let .success(result) = ServiceLayer.decode(WeatherTodayResponse.self, from: data) else {
            XCTFail("Valid JSON was not parsed successfully")
            return
        }
        XCTAssertEqual(79, result.details?.humidity)
        XCTAssertEqual(300.11-273.15, result.details?.tempInCelsius ?? 0.0, accuracy: 0.01)
        XCTAssertEqual("scattered clouds", result.weather?[0].description)
        
    }
    
    func testValidateWeatheOndayHTTPStatusCode200() {
      let url =
        URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=fae7190d7e6433ec3a45285ffcf55c86")
      let condition = expectation(description: "Status code: 200")
     let dataTask = session.dataTask(with: url!) { data, response, error in
          if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
          } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
              condition.fulfill()
            } else {
              XCTFail("Status code: \(statusCode)")
            }
          }
        }
        dataTask.resume()
        wait(for: [condition], timeout: 5)
      }
    func testValidateWeatherFivedayHTTPStatusCode200() {
         let url =
           URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=0&lon=0&appid=fae7190d7e6433ec3a45285ffcf55c86")
         let condition = expectation(description: "Status code: 200")
        let dataTask = session.dataTask(with: url!) { data, response, error in
             if let error = error {
               XCTFail("Error: \(error.localizedDescription)")
               return
             } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
               if statusCode == 200 {
                 condition.fulfill()
               } else {
                 XCTFail("Status code: \(statusCode)")
               }
             }
           }
           dataTask.resume()
           wait(for: [condition], timeout: 5)
         }
}
