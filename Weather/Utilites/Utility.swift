//
//  Utility.swift
//  Weather
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import Foundation
import UIKit
typealias okComplition =  (_ status: Bool) -> Void

enum StatusCode: Int {
    case success = 200
     case failure = 404
}


struct  APIKeys {
    static let appId = "fae7190d7e6433ec3a45285ffcf55c86"
    static let units = "metric"
    static let dayWiseWeatherCount = 5
}
struct Colour {
    static let SecondaryColor = UIColor(named: "SecondaryColor")
    static let PrimaryColor = UIColor(named: "PrimaryColor")
}

struct AppMessages {
    static let removeBookMarks = "are you sure want to remove from Bookmarks?"
    static let noLocationSelected = "Select atleast one location to add Bookmarks"
    static let addBookMarkSuccess = "You have Bookmarked the location successfully"
}


struct CellIdentifers {
    static let homeCell = "HomeViewCell"
    static let weatherDetailTblCell = "WeatherDetailsTableCell"
    static let weatherDetailDateCollectionCell = "WeatherDateCollectionCell"
    static let weatherDetailsDataCell = "WeatherDetailsDataCell"
}
extension Optional where Wrapped == Data {
    
    func toString() -> String {
        return (self != nil) ? (String(data: self!, encoding: .utf8) ?? "") : ""
    }
}
enum WeatherTypes: CaseIterable {
    case Today
    case FiveDays
}
protocol CellConfiguration {
    associatedtype DataType
    func configureCell(data: DataType)
}
extension Date {

  func allDates(till endDate: Date) -> [Date] {
    var date = self
    var array: [Date] = []
    while date <= endDate {
      array.append(date)
      date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    return array
  }
}
func convertDatetoString(dates: [Date]) -> [String] {
    var datesList = [String]()
    for date in dates{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datesList.append(dateFormatter.string(from: date))
    }
    return datesList
}
func getCurrentDateStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.string(from: date)
}
func convertDate(_ date: String, from: String, to: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = from
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = to
    let newDate: Date? = dateFormatterGet.date(from: date)
    guard let dateValue = newDate else {
        return ""
    }
    return dateFormatterPrint.string(from: dateValue)
}
func celsiusFromKelvin(kelvin: Double) -> Double {
    return kelvin - 273.15
}
