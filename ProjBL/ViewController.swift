//
//  ViewController.swift
//  ProjBL
//
//  Created by Peteski Shi on 16/3/19.
//  Copyright © 2019 Petech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import Foundation
import Alamofire
import SwiftyJSON

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}


class ViewController: UIViewController, MKMapViewDelegate{
    
    var coor: CLLocationCoordinate2D?
    var json = JSON()

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.tableViewHeightConstraint.constant = 300
            self.searchBarWidthConstraint.constant = 373
            self.view.layoutIfNeeded()
            self.cancelButton.isHidden = true
            self.cancelButton.isUserInteractionEnabled = false
            
            let filterCell = self.tableView.cellForRow(at: [0, 0])! as! FilterCell
            filterCell.mainLabel.text = "Nearby"
            filterCell.cafeButton.isHidden = true
            filterCell.computerButton.isHidden = true
            self.textFieldShouldReturn(self.searchBar)
        }
    }
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        locationManager.requestWhenInUseAuthorization()
        super.viewDidLoad()
        
        map.delegate = self
        map.showsBuildings = true
        map.showsUserLocation = true
        self.hideKeyboard()
        
        // Table View Cell config
        let SearchCell = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(SearchCell, forCellReuseIdentifier: "SearchCell")
        
        let BuildingCell = UINib(nibName: "BuildingCell", bundle: nil)
        tableView.register(BuildingCell, forCellReuseIdentifier: "BuildingCell")
        
        let FilterCell = UINib(nibName: "FilterCell", bundle: nil)
        tableView.register(FilterCell, forCellReuseIdentifier: "FilterCell")
        
        // configuring the cancel button
        cancelButton.isHidden = true
        cancelButton.isUserInteractionEnabled = false
        
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            setupMap()
        }
        if locationManager.location != nil {
            plotDirectionsTo(destName: "Baillieu Library", lat: -37.798503, long: 144.959575)
        }
    }
}


extension ViewController {
    func setupMap() {
        map.delegate = self
        map.showsBuildings = true
        map.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.purple
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func plotDirectionsTo(destName: String, lat: Double, long: Double) {
        let sourceCoordinates = locationManager.location!.coordinate
        let destinationCoordinates = CLLocationCoordinate2DMake(lat, long)
        
        let destinationPin = customPin(pinTitle: destName, pinSubTitle: "", location: destinationCoordinates)
        self.map.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinates)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinates)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResponse.routes[0]
            
            self.map.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }

}

let urlString = "https://572g8um8v0.execute-api.us-east-1.amazonaws.com/dev/getvenueinfo"

func getJSON(lat: CLLocationDegrees, long: CLLocationDegrees) -> JSON{
    var json = JSON()
    Alamofire.request(urlString, method: .post, parameters: ["lat": Double(lat), "long": Double(long)], encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
        switch response.result {
        case .success:
            json = JSON(response.result.value!)
            print(json)
        case .failure(let error):
            print(error)
        }
    }
    return json
}


extension ViewController: CLLocationManagerDelegate {
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations[locations.count - 1].horizontalAccuracy >= 0 {
            coor = locations[locations.count - 1].coordinate
            print(Double(coor!.latitude), Double(coor!.longitude))
            let lat = -37.7984
            let long = 144.9594
            
//            let lat = coor!.latitude
//            let long = coor!.longitude
            Alamofire.request(urlString, method: .post, parameters: ["lat": Double(lat), "long": Double(long)], encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    self.json = JSON(response.result.value!)
                    print("json: ", self.json)
                    manager.stopUpdatingLocation()
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource, plotPloylineDelegate {
    

    
    func getInfoAndPlotPloyline(buildingName: String) {
        plotDirectionsTo(destName: buildingName, lat: coor!.latitude, long: coor!.longitude)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {   
        return self.json["buildings"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.tableViewHeightConstraint.constant = 720
            // changing the appearence of thee search bar
            self.searchBarWidthConstraint.constant = 300
            self.cancelButton.isHidden = false
            self.cancelButton.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
            let filterCell = self.tableView.cellForRow(at: [0, 0])! as! FilterCell
            filterCell.changeToFilter()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
}

