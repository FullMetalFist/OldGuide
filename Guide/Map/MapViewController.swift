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
    var markers: [GMSMarker] = []
    var stations: [GMSMarker] = []
    private var userCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 1)
    private let locationManager = CLLocationManager()
    private let camera = GMSCameraPosition.camera(withLatitude: 40.775036, longitude: -73.912034, zoom: 15.0)

    
    lazy var mapView: GMSMapView = {
        let map = GMSMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var bottomAreaStackView: UIStackView = {
        return UIStackView()
    }()
    
    lazy var mapToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Toggle Map", for: .normal)
        button.titleLabel?.backgroundColor = .black
        return button
    }()
    
    lazy var elevatorEscalatorStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Status", for: .normal)
        button.titleLabel?.backgroundColor = .black
        return button
    }()
    
    lazy var serviceStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Service", for: .normal)
        button.titleLabel?.backgroundColor = .black
        return button
    }()
    
    lazy var subwayTimesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Times", for: .normal)
        button.titleLabel?.backgroundColor = .black
        return button
    }()
    
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
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
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
        mapView.delegate = self
//        mapView.camera = camera
        mapToggleButton.addTarget(self, action: #selector(mapToggleButtonTapped(_:)), for: .touchUpInside)
        elevatorEscalatorStatusButton.addTarget(self, action: #selector(elevatorEscalatorStatusButtonTapped(_:)), for: .touchUpInside)
        

        setupConstraints()
        let _ = exits.map { exit in
            let mapExit = GMSMarker()
            mapExit.title = exit.stationName
            mapExit.isDraggable = false
            if camera.zoom < 16 {
                
                mapExit.snippet = "\(exit.route1)\(exit.route2)\(exit.route3)\(exit.route4)\(exit.route5)\(exit.route6)\(exit.route7)\(exit.route8)\(exit.route9)\(exit.route10)\(exit.route11) "
                mapExit.position = CLLocationCoordinate2D(latitude: exit.stationLatitude, longitude: exit.stationLongitude)
                let imgColor = GMSMarker.markerImage(with: GuideColor.chooseColorFor(line: exit.route1))
                mapExit.icon = imgColor
            } else {
                mapExit.position = CLLocationCoordinate2D(latitude: exit.latitude, longitude: exit.longitude)
                mapExit.snippet = "\(exit.route1)\(exit.route2)\(exit.route3)\(exit.route4)\(exit.route5)\(exit.route6)\(exit.route7)\(exit.route8)\(exit.route9)\(exit.route10)\(exit.route11) " + exit.entranceType.rawValue
                
                let imgColor = GMSMarker.markerImage(with: GuideColor.chooseColorFor(line: exit.route1))
                mapExit.icon = imgColor
            }
            markers.append(mapExit)
            mapExit.map = mapView
            
            return mapExit
        }
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        
        let tempBox = ExitCalloutView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tempBox.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        self.view.addSubview(mapToggleButton)
        self.view.addSubview(elevatorEscalatorStatusButton)
        self.view.addSubview(tempBox)
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        mapToggleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        mapToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        mapToggleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        elevatorEscalatorStatusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36).isActive = true
        elevatorEscalatorStatusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        elevatorEscalatorStatusButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        tempBox.bottomAnchor.constraint(equalTo: elevatorEscalatorStatusButton.topAnchor, constant: -10).isActive = true
        tempBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
    }
    
    @objc func mapToggleButtonTapped(_ sender: UIButton) {
        print("map toggle button tapped")
    }
    
    @objc func elevatorEscalatorStatusButtonTapped(_ sender: UIButton) {
        print("elevatorEscalatorStatusButtonTapped")
    }
    
    @objc func serviceStatusButtonTapped(_ sender: UIButton) {
        print("serviceStatusButtonTapped")
    }
    
    @objc func subwayTimesButtonTapped(_ sender: UIButton) {
        print("subwayTimesButtonTapped")
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus
        switch authStatus {
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
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.title = "Me"
            marker.snippet = "I'm here"
        }
        
//        if let location = locations.first {
//
//            userCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            mapView.isMyLocationEnabled = true
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("we need user location")
    }
}

extension MapViewController: GMSMapViewDelegate {
}

extension MapViewController: GMSIndoorDisplayDelegate {
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        if markers.contains(marker) {
//            return ExitCalloutView(marker.snippet ?? "", station: marker.title ?? "", exitType: "")//ExitCalloutView(frame: CGRect(x: 0, y: 0, width: 170, height: 50))
//        }
//        return nil
//    }
}
