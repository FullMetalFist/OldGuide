//
//  ViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/24/22.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        /*
         viewModel
            user lat, lng
            nearest subway station lat, lng (marker)
            walking directions to nearest subway station
            
         
         */
        let mapViewModel = MapViewModel()
        mapViewModel.fetchExitLocations()
        
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 40.7128, longitude: -74.0060, zoom: 11.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    private func setup() {
        
    }
}

