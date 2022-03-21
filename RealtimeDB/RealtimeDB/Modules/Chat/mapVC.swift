//
//  mapVC.swift
//  RealtimeDB
//
//  Created by Admin on 16/03/22.
//

import UIKit
import MapKit
import CoreLocation

class mapVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnFixedPin: UIButton!
    @IBOutlet weak var btnCurrentLoc: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var btnSendLoc: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var isOpen = true
    var currentLoc = CLLocationCoordinate2D()
    var type = ""
    let viewModel = chatModel()
    var data: Users?
    var placeMark = String()
    var locManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var latlong = String()
    var coordinates = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
        
        if type == Constants.Sender{
            btnSendLoc.isHidden = false
            btnCurrentLoc.isHidden = false
            btnFixedPin.isHidden = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(getLocOnTapped))
            map.addGestureRecognizer(gesture)
        }else if type == Constants.Receiver{
            btnSendLoc.isHidden = true
            btnCurrentLoc.isHidden = true
            btnFixedPin.isHidden = true
            address(coordinates: coordinates)
        }
        
    }
    
    @IBAction func currentLoc(_ sender: Any) {
        address(coordinates: self.currentLoc)
    }
    @IBAction func segmentAction(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            map.mapType = .standard
        }else if segment.selectedSegmentIndex == 1{
            map.mapType = .hybrid
        }else if segment.selectedSegmentIndex == 2{
            map.mapType = .satellite
        }
    }
    
    @IBAction func sendLoc(_ sender: Any) {
        self.navigationController?.popViewControllerWithHandler{
            self.viewModel.sendMessage(message: self.latlong, receiverID: self.data?.userId ?? "-", senderID: UserDefaults.standard.string(forKey: "UserID") ?? "-", type: "map")
        }
    }
    
    @objc func getLocOnTapped(sender: UIGestureRecognizer) {
        let location = sender.location(in: map)
        let coordinates = map.convert(location, toCoordinateFrom: map)
        isOpen = false
        btnFixedPin.isHidden = false
        self.map.removeAnnotation(self.annotation)
        address(coordinates: coordinates)
    }
    
    func address(coordinates: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.latlong = "\(coordinates.latitude),\(coordinates.longitude)"
        geoCoder.reverseGeocodeLocation(location, completionHandler:
                                            { placemarks, error -> Void in
            guard let placeMark = placemarks?.first else { return }
            guard let locName = placeMark.name else { return }
            // guard let city = placeMark.locality else { return }
            self.placeMark = "\(locName)"
            
            if self.type == Constants.Receiver{
                self.map.removeAnnotation(self.annotation)
                self.annotation.coordinate = coordinates
                self.annotation.title = self.placeMark
                self.map.addAnnotation(self.annotation)
            }else if self.type == Constants.Sender{
                if self.isOpen == true{
                    self.map.removeAnnotation(self.annotation)
                    self.annotation.coordinate = coordinates
                    self.annotation.title = self.placeMark
                    self.map.addAnnotation(self.annotation)
                }
            }
            
            let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.map.setRegion(region, animated: true)
        })
    }
    
    
    func searchLocation(searchAddress: String) {
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchAddress
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [weak self] response, error in
            guard error == nil else {return}
            guard let response = response else {return}
            let coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
            
            self?.address(coordinates: coordinate)
        }
    }
}

extension mapVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
        self.view.makeToast(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if type == Constants.Sender{
            if let location = locations.last{
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.currentLoc = center
                address(coordinates: center)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinates = mapView.centerCoordinate
        address(coordinates: coordinates)
    }
}

extension mapVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchLocation(searchAddress: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
