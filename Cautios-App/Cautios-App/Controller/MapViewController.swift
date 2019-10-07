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
import Google_Maps_iOS_Utils
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate{
    
    // TODO: Declare constants here:
    let API_KEY = "AIzaSyDjVRTh-kyxGtb8CRzvBzOsY6Ga8T5JsXM"
    
    // TODO: Declare instance variables here:
    let realm = try! Realm(configuration: RealmConfig.main.configuration)
    var offenders: Results<OregonOffenders>?
    var offenderMarkers = [GMSMarker]()
    let locationManager = CLLocationManager()
    var camera: GMSCameraPosition?
    var mapView: GMSMapView!
    var clusterManager: GMUClusterManager!
    let isClustering: Bool = true
    // let isCustom: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOffenders()
        // Generate Google Maps.
        GMSServices.provideAPIKey(API_KEY)
        mapView = GMSMapView(frame: view.frame)
        mapView.camera = GMSCameraPosition.camera(withLatitude: 44.9429, longitude: -123.0351, zoom: 10)
        mapView.mapType = .normal
        mapView.delegate = self
        view.addSubview(mapView)
    
        // Get the user's location.
//      locationManager.delegate = self
//      locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//      locationManager.requestWhenInUseAuthorization()
//      locationManager.startUpdatingLocation()
        
        if isClustering {
            // Set up the cluster manager with default icon generator, clustering algorithm, and renderer.
            let iconGenerator = GMUDefaultClusterIconGenerator()
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
            // Perform the clustering after all the marker have been loaded with markers.
            clusterManager.cluster()
            clusterManager.setDelegate(self, mapDelegate: self)
            markOffenders()
        }
        
//        // Load the Oregon Sex offenders from the Realm database.
//        loadOffenders()
//        GMSServices.provideAPIKey(API_KEY)
//        // Get the user's location.
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        // Default location in Salem, Oregon.
//        setMapViewLocation(latitude: 44.9429, longitude: -123.0351, zoom: 10)
//        mapView.delegate = self
//        if isClustering {
//            // Set up the cluster manager with default icon generator. clustering algorithm, and renderer.
//            let iconGenerator = GMUDefaultClusterIconGenerator()
//            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//            let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
//            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
//            // Perform the clustering after all the marker have been loaded with markers.
//            clusterManager.cluster()
//            clusterManager.setDelegate(self, mapDelegate: self)
//            view = mapView
//        }
    }
    
    // MARK: - Data Manipulation Methods
    /***************************************************************/
    
    func loadOffenders() {
        offenders = realm.objects(OregonOffenders.self)
    }
    
    // MARK: - Map Methods
    /***************************************************************/
    
    func setMapViewLocation(latitude: Double, longitude: Double, zoom: Float) {
        camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: zoom)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera!)
        markOffenders()
        view = mapView
    }
    
    func markOffenders() {
        if let offenders = self.offenders {
            if offenders.count <= 0 {
                return
            }
            for i in 0...offenders.count - 1 {
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: offenders[i].residenceLatitude, longitude: offenders[i].residenceLongitude)
//                marker.title = offenders[i].firstName + " " + offenders[i].middleName + " " +  offenders[i].lastName
//                marker.snippet = "Age: " + String(offenders[i].age) + " \nHeight: " + String(offenders[i].height) + " \nWeight: " + String(offenders[i].weight)
//                marker.map = mapView
                if let clusterMgn = clusterManager {
                    print("Clustering item \(i)")
                    let lat = offenders[i].residenceLatitude
                    let lng = offenders[i].residenceLongitude
                    let name = offenders[i].firstName + " " + offenders[i].lastName
                    let item = POIItem(position: CLLocationCoordinate2D(latitude: lat, longitude: lng), name: name)
                    clusterMgn.add(item)
                    clusterMgn.cluster()
                }
            }
        }
    }
    
    // MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    // Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            // Make sure that the location data only comes in once.
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

    // MARK: - GMU Cluster Manger Delegate Methods
    /***************************************************************/
    private func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
    }
    
    // MARK: - GMU Map Manger Delegate Methods
    /***************************************************************/
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    
    }
}

