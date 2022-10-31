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
    
    lazy var mapView: GMSMapView = {
        let map = GMSMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
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
        let camera = GMSCameraPosition.camera(withLatitude: 40.775036, longitude: -73.912034, zoom: 17.0)
        mapView.camera = camera
        self.view.addSubview(mapView)
        
        mapToggleButton.addTarget(self, action: #selector(mapToggleButtonTapped(_:)), for: .touchUpInside)
        elevatorEscalatorStatusButton.addTarget(self, action: #selector(elevatorEscalatorStatusButtonTapped(_:)), for: .touchUpInside)
        mapView.addSubview(mapToggleButton)
        mapView.addSubview(elevatorEscalatorStatusButton)

        setupConstraints()
        let _ = exits.map { exit in
            let mapExit = GMSMarker()
            mapExit.title = exit.stationName
            mapExit.isDraggable = false
            if camera.zoom < 16 {
                
                mapExit.snippet = "\(exit.route1) \(exit.route2) \(exit.route3) \(exit.route4) \(exit.route5) \(exit.route6)"
                mapExit.position = CLLocationCoordinate2D(latitude: exit.stationLatitude, longitude: exit.stationLongitude)
            } else {
                mapExit.position = CLLocationCoordinate2D(latitude: exit.latitude, longitude: exit.longitude)
                mapExit.snippet = "\(exit.route1) \(exit.route2) \(exit.route3) \(exit.route4) \(exit.route5) \(exit.route6) " + exit.entranceType.rawValue
                let imgColor = GMSMarker.markerImage(with: GuideColor.chooseColorFor(line: exit.route1))
                mapExit.icon = imgColor
            }
            
            mapExit.map = mapView
            return mapExit
        }
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        mapToggleButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16).isActive = true
        mapToggleButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16).isActive = true
        mapToggleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        elevatorEscalatorStatusButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16).isActive = true
        elevatorEscalatorStatusButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16).isActive = true
        elevatorEscalatorStatusButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
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
