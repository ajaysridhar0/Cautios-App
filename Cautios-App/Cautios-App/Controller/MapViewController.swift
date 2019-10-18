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
        
        do {
          // Set the map style by passing the URL of the local file.
          if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 44.9429, longitude: -123.0351, zoom: 10)
        mapView.mapType = .normal
        mapView.delegate = self
        view.addSubview(mapView)
    
        // Get the user's location.
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
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
            for offender in offenders {
                
                if let clusterMgn = clusterManager {
                    // print("Clustering item \(i)")
//                    let lat = offender.residenceLatitude
//                    let lng = offender.residenceLongitude
//                    let name = offender.firstName + " " + offender.middleName + " " + offender.lastName
//                    let item = POIItem(position: CLLocationCoordinate2D(latitude: lat, longitude: lng), name: name)
//                    clusterMgn.add(item)
//                    clusterMgn.cluster()
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: offender.residenceLatitude, longitude: offender.residenceLongitude)
                    marker.title = offender.firstName + " " + offender.middleName + " " +  offender.lastName
                    marker.snippet = "Age: " + String(offender.age) + " \nHeight: " + String(offender.height) + " \nWeight: " + String(offender.weight)
                    marker.map = mapView
                    mapView.delegate = self
                    self.generatePOIItems("Name unavailable", position: marker.position)
                    clusterMgn.cluster()
                }
                // clusterManager.cluster()
            }
        }
    }
    
    // MARK: - Add Marker to Cluster
    func generatePOIItems(_ name: String, position: CLLocationCoordinate2D) {
        let item = POIItem(position: position, name: name)
        clusterManager.add(item)
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
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//
//    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            print(poiItem.name)
        }
        return false
    }
}

