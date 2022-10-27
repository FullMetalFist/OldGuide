//
//  MapViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/24/22.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController {
    
    var exits: [Exit] = []
    private var userCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 1)
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         viewModel
            user lat, lng
            nearest subway station lat, lng (marker)
            walking directions to nearest subway station
         */
        let mapViewModel = MapViewModel()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapViewModel.fetchExitLocations { result in
            switch result {
            case .success(let exits):
                self.exits = exits
            case .error(let error):
                print("\(error)")
            }
        }
        
        let bounds = GMSCoordinateBounds.init()
        var camera = GMSCameraPosition.camera(withLatitude: 40.7128, longitude: -74.0060, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        let markers = exits.map { exit in
            let mapExit = GMSMarker()
            mapExit.title = exit.stationName
            mapExit.isDraggable = false
            if camera.zoom < 16 {
                mapExit.snippet = "\(exit.route1) \(exit.route2) \(exit.route3) \(exit.route4) \(exit.route5) \(exit.route6)"
                mapExit.position = CLLocationCoordinate2D(latitude: exit.stationLatitude, longitude: exit.stationLongitude)
            } else {
                mapExit.position = CLLocationCoordinate2D(latitude: exit.latitude, longitude: exit.longitude)
                mapExit.snippet = exit.entranceType.rawValue
            }
            
            mapExit.map = mapView
            return mapExit
        }
    }
    
    private func setup() {
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let accuracyStatus = manager.authorizationStatus
        switch accuracyStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("thanks")
        case .denied, .restricted, .notDetermined:
            print("could be trouble")
        @unknown default:
            print("what is this")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("we need user location")
    }
}

extension MapViewController: GMSMapViewDelegate {
//    func 
}
