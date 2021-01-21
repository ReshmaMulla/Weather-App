//
//  HomeViewController.swift
//  Weather
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var searchActive = false
    private var filtered = [UserLocations]()
    private var userBookMarks: [UserLocations] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSearchData()
        userBookMarks = UserLocalData().getUserBookedLocation() ?? []
        // Do any additional setup after loading the view.
    }
    func loadSearchData() {
        searchBar.textField?.textColor = .white
        searchBar.textField?.addDoneButtonOnKeyboard()
        searchBar.returnKeyType = .search
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let mapController = segue.destination as? MapViewController {
            mapController.isLocationAdded = { status in
                if status {
                    self.userBookMarks = UserLocalData().getUserBookedLocation() ?? []
                }
            }
        }
        if let weatherDetailsController = segue.destination as? WeatherDetailsController {
            guard let selectedIndex = tableView.indexPath(for: sender as! HomeViewCell) else {return}
            let data = self.userBookMarks[selectedIndex.row]
            weatherDetailsController.location = UserLocation(address: data.location ?? "", lattitude:data.latitude , longtitude: data.longitude )
        }
    }
    
    
}

// MARK: - TableView Delegate & Data Source Methods

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : userBookMarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifers.homeCell) as? HomeViewCell else {return UITableViewCell()}
        
        cell.addressLbl.text = searchActive ?  filtered[indexPath.row].location : userBookMarks[indexPath.row].location
        cell.locationLbl.text = "-"
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
// MARK: - On selection of remove book mark delete data from local data base

extension HomeViewController: HomeCellDelegate {
    func removeBookMarkCell<T>(cell: T) {
        showAlertOkandCancelCompletionHandler(message: AppMessages.removeBookMarks) { [weak self] (status) in
            
            if status {
                guard let self = self else {
                    return
                }
                if let cell = cell as? HomeViewCell {
                    guard let indexPath = self.tableView.indexPath(for: cell) else {return }
                    UserLocalData().deleteUserBookedLocation(deleteLocation:  self.searchActive ?  self.filtered[indexPath.row] : self.userBookMarks[indexPath.row]) {  status in
                        if status {
                            if  self.searchActive {
                                self.filtered.remove(at: indexPath.row)
                            }else {
                                self.userBookMarks.remove(at: indexPath.row)
                            }
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                        
                    }
                }
            }
        }
        
    }
    
    
}
// MARK: - Search Delegate Methods

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = userBookMarks.filter({$0.location?.range(of: searchText, options: .caseInsensitive) != nil})
        searchActive = filtered.count == 0 ? false : true
        self.tableView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
