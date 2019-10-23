//
//  ViewController.swift
//  cautios
//
//  Created by Ajay Sridhar on 9/13/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class MapViewController: UIViewController {
    @IBOutlet weak var mapKitView: MKMapView!
    
    // TODO: Declare instance variables here:
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 100
    let realm = try! Realm(configuration: RealmConfig.main.configuration)
    var offenders: Results<OregonOffenders>?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOffenders()
        checkLocationServices()
    }
    
    // MARK: - Data Manipulation Methods
    /***************************************************************/
    
    func loadOffenders() {
        offenders = realm.objects(OregonOffenders.self)
    }
    
    // MARK: - Map Methods
    /***************************************************************/
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapKitView.setRegion(region, animated: true)
        }
    }
    
    func markOffenders() {
        if let offenders = self.offenders {
            if offenders.count <= 0 {
                return
            }
            for offender in offenders {
            // print("Clustering item \(i)")
//             let lat = offender.residenceLatitude
//             let lng = offender.residenceLongitude
//             let name = offender.firstName + " " + offender.middleName + " " + offender.lastName
            }
        }
    }
    
    // MARK: - Location Functions
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            locationManager.startUpdatingLocation()
        }
        else {
            // let user use app without location services or show alert
        }
    }
    
    func setupLocationManager() {
            // Get the user's location.
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.requestWhenInUseAuthorization()
    //        locationManager.startUpdatingLocation()
        }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapKitView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            // show alert instructing them how to turn on permission
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert letting them know what is up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapKitView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

