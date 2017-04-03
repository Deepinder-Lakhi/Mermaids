//
//  ShowMapViewController.swift
//  Mermaids
//
//  Created by DEEPINDERPAL SINGH on 17/02/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ShowMapViewController:  UIViewController,MKMapViewDelegate ,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var showmapListcomming = String()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
    }
    
    
    func loadLocation() {
        // Show Map
        
        var myStringArrctakes = showmapListcomming.components(separatedBy: ",")
        
        
        let annotation = MKPointAnnotation()
        let latitude:CLLocationDegrees = (myStringArrctakes[6] as NSString).doubleValue
        let longitude:CLLocationDegrees = (myStringArrctakes[5] as NSString).doubleValue
        let latDelta:CLLocationDegrees = 30
        let lonDelta:CLLocationDegrees = 30
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let locations:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(locations, span)
        
        mapView.setRegion(region, animated: false)
        
        annotation.coordinate = locations
        annotation.title = myStringArrctakes[1]
        annotation.subtitle = "\(myStringArrctakes[2])"
        mapView.addAnnotation(annotation)

    }
    
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKPinAnnotationView()
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        if let location = locations.last {
            print("Found User's location: \(location)")
            print("Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)")
        }
        
//        loadLocation()
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
