//
//  ReceiverMesssageCell.swift
//  RealtimeDB
//
//  Created by Admin on 04/03/22.
//

import UIKit
import MapKit

class ReceiverMesssageCell: UITableViewCell {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var msgStackView: UIView!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var lbl: UILabel!
    
    var coordinates = CLLocationCoordinate2D()
    var locManager = CLLocationManager()
    var delegate : openMapProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openMap))
        map.addGestureRecognizer(gesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func openMap(sender: UIGestureRecognizer) {
        delegate?.openMap(coordinates: self.coordinates)
    }
    
    
    func bindData(Messages: Messages){
        if Messages.MsgType == "text"{
            imgView.isHidden = true
            mapView.isHidden = true
            msgStackView.isHidden = false
            lbl.text = Messages.Msg
        }else if Messages.MsgType == "map"{
            imgView.isHidden = true
            mapView.isHidden = false
            msgStackView.isHidden = true
            
            guard let latLongArray = Messages.Msg?.split(separator: ",") else { return }
            
            let lat = latLongArray[0]
            let long = latLongArray[1]
            
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(long)!)
            self.coordinates = coordinates
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            map.addAnnotation(annotation)
            
        }else if Messages.MsgType == "video"{
            imgView.isHidden = false
            msgStackView.isHidden = true
            mapView.isHidden = true
            img.image = UIImage(named: "videoPreview")
        }else if Messages.MsgType == "image"{
            imgView.isHidden = false
            msgStackView.isHidden = true
            mapView.isHidden = true
            guard let imgUrl = URL(string: Messages.Msg ?? "-") else { return  }
            
            do{
                let data = try Data (contentsOf: imgUrl)
                img.image = UIImage(data: data)
            } catch{
                print("error")
            }
            
            
        }else{
            imgView.isHidden = false
            msgStackView.isHidden = true
            mapView.isHidden = true
            img.image = UIImage(named: "document")
        }
    }
    
}

extension ReceiverMesssageCell : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            //locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            print("location:: (location)")
        }
        
    }
    
}
