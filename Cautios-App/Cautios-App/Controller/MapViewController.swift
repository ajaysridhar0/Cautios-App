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
    let regionInMeters: Double = 10000
    var currentCoordinate: CLLocationCoordinate2D!
    let realm = try! Realm(configuration: RealmConfig.main.configuration)
    var offenders: Results<OregonOffenders>?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        checkLocationServices()
        loadOffenders()
        annotateOffenders()
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
    
    func annotateOffenders() {
        if let offenders = self.offenders {
            if offenders.count <= 0 {
                return
            }
            for offender in offenders {
            // print("Clustering item \(i)")
                let lat = offender.residenceLatitude
                let lng = offender.residenceLongitude
                let name = offender.firstName + " " + offender.middleName + " " + offender.lastName + " " + offender.suffix
                let address = (offender.residenceStreetNumber + " " + offender.residenceStreetName + " " + offender.residenceCity + ", " + offender.residenceState + " " + String(offender.residenceZip)).uppercased()
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "MM/dd/yyyy"
                guard let birthDate : Date = inputFormatter.date(from: "07/07/1960") else { fatalError() }
                let form = DateComponentsFormatter()
                form.maximumUnitCount = 1
                form.unitsStyle = .full
                form.allowedUnits = [.year]
                let age = form.string(from: birthDate, to: Date())
                var height: String = String(offender.height / 100) + "' " + String(offender.height % 100) + "\""
                var weight = offender.weight
                var eyeColor = offender.eyes == "BLU" ? "BLUE" : (offender.eyes  == "BRO" ? "BROWN" : (offender.eyes  == "HAZ" ? "HAZEL" : (offender.eyes  == "GRY" ? "GRAY" : (offender.eyes  == "GRN" ? "GREEN" : (offender.eyes  == "BLK" ? "BLACK" : ("Not available"))))))
                var hairColor = offender.hair == "BLN" ? "BLOND" : (offender.hair  == "BRO" ? "BROWN" : (offender.hair  == "WHI" ? "WHITE" : (offender.hair  == "GRY" ? "GRAY" : (offender.hair  == "RED" ? "RED" : (offender.hair  == "BLK" ? "BLACK" : ("Not available"))))))
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
                annotation.title = name
                annotation.subtitle = "Address: \(address) \nAge: \(age!) Height: \(height) \nWeight: \(weight) lbs \nHair Color: \(hairColor) \nEye Color: \(eyeColor)"
                mapKitView.addAnnotation(annotation)
                
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
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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
        locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        mapKitView.userTrackingMode = .followWithHeading
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapKitView.setRegion(region, animated: true)
//
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
//        }
//
//        annotationView?.canShowCallout = true
//        return annotationView
//    }
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        print("The annotation was selected \(view.annotation?.title)")
//    }
}
