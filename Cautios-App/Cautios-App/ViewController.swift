//
//  ViewController.swift
//  cautios
//
//  Created by Ajay Sridhar on 9/13/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // TODO: Declare constants here:
    let API_KEY = "AIzaSyDjVRTh-kyxGtb8CRzvBzOsY6Ga8T5JsXM"
    
    // TODO: Declare instance variables here:
    let locationManager = CLLocationManager()
    var camera: GMSCameraPosition?
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey(API_KEY)
        // Get the location.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setMapViewLocation(latitude: 37.621262, longitude: -122.378945, zoom: 10)
    }
    
    func setMapViewLocation(latitude: Double, longitude: Double, zoom: Float) {
        camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: zoom)
        if let mycamera = camera {
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: mycamera)
            view = mapView
        }
    }
    
    // MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    // Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            // Make sure that the weather data only comes in once.
            locationManager.delegate = nil
            print("longitude = \(location.coordinate.longitude)")
            print("latitude = \(location.coordinate.latitude)")
            setMapViewLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10)
        }
    }
    
    // Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

