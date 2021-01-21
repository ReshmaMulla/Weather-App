//
//  MapViewController.swift
//  Weather
//
//  Created by kartheek.p on 19/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    
    @IBOutlet weak  var mapView: MKMapView!
    @IBOutlet weak  var currentLocationLbl: UILabel!
    private lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        _locationManager.activityType = . automotiveNavigation
        // _locationManager.distanceFilter = 1000.0
        return _locationManager
    }()
    
    private  var userAddress: String = "Current location" {
        didSet {
            DispatchQueue.main.async {
                self.currentLocationLbl.text = self.userAddress
            }
        }
    }
    var isLocationAdded: ((Bool) -> Void)?
    private  var userLoc: UserLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //get current user location for startup
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    //MARK:- Add Book Mark action
    @IBAction func addToBookMarkAction(_ sender: Any) {
        guard let _ = userLoc?.lattitude,let _ = userLoc?.longtitude else {
            self.showAlert(message: AppMessages.noLocationSelected)
            return
        }
        UserLocalData().saveUserData(userLoc: userLoc!) { (status) in
            if status {
                isLocationAdded?(status)
                self.showAlertOkCompletionHandler(message:AppMessages.addBookMarkSuccess) { [weak self] (okStatus) in
                    if okStatus {
                        guard let self = self else {
                            return
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                
            }
        }
    }
    
    //MARK:- To get Addres from selected location
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) {
        DispatchQueue.global(qos: .userInteractive).async {
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
            
            geoCoder.reverseGeocodeLocation(location) { (placemarksArray, error) in
                print(placemarksArray!)
                if (error) == nil {
                    if placemarksArray!.count > 0 {
                        let placemark = placemarksArray?[0]
                        self.userAddress = (placemark?.administrativeArea ?? "") + " " + (placemark?.country ?? "")
                        self.userLoc = UserLocation(address: self.userAddress, lattitude: Double(mLattitude), longtitude: Double(mLongitude))
                    }
                }
                
            }
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        default:
            break
        }
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
// MARK: - Map view And CLLocation Delegate Methods
extension MapViewController: CLLocationManagerDelegate,MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mRegion, animated: true)
        addAnnotation(location: center)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    // Adding annotation to map 
    func addAnnotation(location: CLLocationCoordinate2D) {
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        mapView.removeAnnotations(annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        mapView.addAnnotation(annotation)
        setUsersClosestLocation(mLattitude: location.latitude, mLongitude: location.latitude)
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinReuseId")
            pin.isDraggable = true
            return pin
        } else {
            return nil
        }
    }
    // On Moving the map changing the pin location
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        addAnnotation(location: mapView.centerCoordinate)
        
    }
    
}
