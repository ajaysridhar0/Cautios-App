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
import MapViewPlus

class OffenderMapViewController: UIViewController {
    // Outlets
    @IBOutlet weak var mapView: MapViewPlus!
    
    // TODO: Declare instance variables here:
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var currentCoordinate: CLLocationCoordinate2D!
    let realm = try! Realm(configuration: RealmConfig.main.configuration)
    var offenders: Results<OregonOffenders>?
    var annotations: [AnnotationPlus] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self as MKMapViewDelegate
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
            mapView.setRegion(region, animated: true)
        }
    }
    
    func annotateOffenders() {
        if let offenders = self.offenders {
            if offenders.count <= 0 {
                return
            }
            for offender in offenders {
                let lat = offender.residenceLatitude
                let lng = offender.residenceLongitude
                let viewModel = OffenderCalloutViewModel(offender: offender)
                let annotation = AnnotationPlus(viewModel: viewModel, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                annotations.append(annotation)
            }
            let navListTab = self.tabBarController?.viewControllers?[1] as! UINavigationController
            let offenderListTab = navListTab.topViewController as! OffenderListTableViewController
            offenderListTab.annotations = annotations
            mapView.setup(withAnnotations: annotations)
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
            // TODO: - let user use app without location services or show alert
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
            mapView.showsUserLocation = true
//            mapView.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
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
        @unknown default:
            fatalError()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension OffenderMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        if let userLocation: CLLocationCoordinate2D = currentCoordinate {
            let navigationTab = self.tabBarController?.viewControllers?[2] as! UINavigationController
            let sosMessageTab = navigationTab.topViewController as! SOSMessageViewController
            sosMessageTab.userLocation = userLocation
            print("user location sent: \(userLocation)")
        }
        mapView.userTrackingMode = .followWithHeading
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapKitView.setRegion(region, animated: true)
//
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
extension OffenderMapViewController: MapViewPlusDelegate {
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus) -> UIImage {
        return UIImage(named: "annotation-1.png")!
    }
    
    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus {
        let calloutView = Bundle.main.loadNibNamed("OffenderCalloutView", owner: nil, options: nil)!.first as! OffenderCalloutView
        return calloutView
    }
}
