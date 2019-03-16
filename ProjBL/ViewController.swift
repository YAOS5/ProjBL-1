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

class ViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        locationManager.requestWhenInUseAuthorization()
        checkLocationServices()
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        
        // Table View Cell config
        let SearchCell = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(SearchCell, forCellReuseIdentifier: "SearchCell")
        
        let BuildingCell = UINib(nibName: "BuildingCell", bundle: nil)
        tableView.register(BuildingCell, forCellReuseIdentifier: "BuildingCell")
        
        let FilterCell = UINib(nibName: "FilterCell", bundle: nil)
        tableView.register(FilterCell, forCellReuseIdentifier: "FilterCell")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
////        tableView.cellForRow(at: [0, 0])!.isHidden = true
//    }

}



extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {   
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.tableViewHeightConstraint.constant = 750
            self.view.layoutIfNeeded()
            let filterCell = self.tableView.cellForRow(at: [0, 0])! as! FilterCell
            filterCell.changeToFilter()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}

