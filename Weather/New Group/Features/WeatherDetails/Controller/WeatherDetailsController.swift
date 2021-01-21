//
//  WeatherDetailsController.swift
//  Weather
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit

class WeatherDetailsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var location: UserLocation?
    private var weatherList = [WeatherTodayResponse]()
    private var weatherTotalList = [WeatherTodayResponse]()
    private var dates = [String]()
    private var selectedWeatherType: WeatherTypes = .Today {
        didSet {
            switch selectedWeatherType {
            case .FiveDays:getFiveDaysForecastRecords()
            default:getTodaysForecastRecords()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIntialData()
        setUpWeatherDaysFromItsCount()
        // Do any additional setup after loading the view.
    }
    func setUpWeatherDaysFromItsCount() {
        if let date = Calendar.current.date(byAdding: .day, value: APIKeys.dayWiseWeatherCount, to: Date()) {
            let datesData = Date().allDates(till: date)
            dates = convertDatetoString(dates: datesData)
        }
    }
    func setUpIntialData() {
        self.title = location?.address
        tableView.register(UINib(nibName: "WeatherDetailsDataCell", bundle: nil), forCellReuseIdentifier: CellIdentifers.weatherDetailsDataCell)
        tableView.tableFooterView = UIView()
        selectedWeatherType = .Today
    }
    // MARK: - On change of segment its load the weather data
    @IBAction func weatherSegmentAction(_ sender: UISegmentedControl) {
        selectedWeatherType = sender.selectedSegmentIndex == 0 ? .Today : .FiveDays
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: - TableView Delegate & Data Source Methods

extension WeatherDetailsController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedWeatherType == .Today ? 1 : 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedWeatherType {
        case .FiveDays: return section == 0 ? 1 :  weatherList.count
        default:return weatherList.isEmpty ? 0 :  weatherList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedWeatherType {
        case .FiveDays:
            return indexPath.section == 0 ?  loadWeatherDateCell(indexPath: indexPath) :  loadWeatherDetailsCell(indexPath: indexPath)
        default: return loadWeatherDetailsCell(indexPath: indexPath)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func loadWeatherDetailsCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifers.weatherDetailsDataCell) as? WeatherDetailsDataCell else {return UITableViewCell()}
        cell.configureCell(data: weatherList[indexPath.row])
        return cell
    }
    func loadWeatherDateCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifers.weatherDetailTblCell) as? WeatherDetailsTableCell else {return UITableViewCell()}
        cell.dates = dates
        cell.delegate = self
        return cell
    }
    
    
    
}
// MARK: - SERVICE CALLS
//  Today's weather API
extension WeatherDetailsController {
        // ToDay's weather API
    func getTodaysForecastRecords() {
        showActivityView()
        weatherList = []
        WeatherServices().getTodayWeather(param:formTodayForeCastRequest()) { (result) in
            self.processResult(result: result)
        }
    }
    // Five Day's weather API
    func getFiveDaysForecastRecords() {
        weatherList = []
        showActivityView()
        WeatherServices().getFiveDayWeather(param: formTodayForeCastRequest()) { (result) in
            self.processFiveDayResult(result: result)
        }
    }
    // API Request Form
    func formTodayForeCastRequest() -> [String: Any] {
        var request = [String: Any]()
        request["lat"] = String(location?.lattitude ?? 0.0)
        request["lon"] = String(location?.longtitude ?? 0.0)
        request["appid"] = APIKeys.appId
        request["units"] = APIKeys.units
        return request
    }
    func processResult(result: WeatherResult) {
           DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
          self.hideActivityView()
        if case let .Error(error) = result {
            self.showAlert(message: error)
        }
            if case let .Success(result) = result {
        self.weatherList.append(result)
        self.tableView.reloadData()
                   }
        }
    }
    func processFiveDayResult(result: WeatherFiveDayResult) {
           DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
          self.hideActivityView()
        if case let .Error(error) = result {
            self.showAlert(message: error)
        }
        if case let .Success(result) = result {
       guard let fiveForeCastlist = result.foreCastlist, !fiveForeCastlist.isEmpty else {
           return
       }
       self.weatherTotalList = fiveForeCastlist
        self.weatherList = self.weatherTotalList.filter{$0.dateTrimmied == getCurrentDateStr(date: Date())}
       self.tableView.reloadData()
        }
        }
    }

}
// MARK: - On selection of Date call back to update weather deatils
extension WeatherDetailsController: DateCollectionCellDelegate {
    func dateSelected(index: Int) {
        let date = self.dates[index]
        self.weatherList = self.weatherTotalList.filter{$0.dateTrimmied == date}
        self.tableView.reloadSections([1], with: .automatic)
    }
    
    
}
// MARK: - Loading activity indicator view
extension WeatherDetailsController {
    func showActivityView() {
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.3))
        
    }
    func hideActivityView() {
        DispatchQueue.main.async {
            self.view.activityStopAnimating()
        }
    }
}
