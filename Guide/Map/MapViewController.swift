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
    private let mapViewModel = MapViewModel()
    private let locationManager = CLLocationManager()

    
    lazy var mapView: GMSMapView = {
        let map = GMSMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.settings.compassButton = true
        
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
        locationManager.delegate = self
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }

        addTargets()
        setupConstraints()
        fetchExits()
    }
    
    private func addTargets() {
        mapToggleButton.addTarget(self, action: #selector(mapToggleButtonTapped(_:)), for: .touchUpInside)
        elevatorEscalatorStatusButton.addTarget(self, action: #selector(elevatorEscalatorStatusButtonTapped(_:)), for: .touchUpInside)
        serviceStatusButton.addTarget(self, action: #selector(serviceStatusButtonTapped(_:)), for: .touchUpInside)
        subwayTimesButton.addTarget(self, action: #selector(subwayTimesButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func fetchExits() {
        
        mapViewModel.fetchExitLocations { result in
            switch result {
            case .success(let exits):
                self.exits = exits
            case .error(let error):
                print("\(error)")
            }
        }
        mapView.clear()
        let _ = exits.map { exit in
            let mapExit = GMSMarker()
            mapExit.title = exit.stationName
            mapExit.isDraggable = false

            exitLevel(exit, marker: mapExit)
            
            markers.append(mapExit)
            mapExit.map = mapView

            return mapExit
        }
    }
    
    private func stationLevel(_ exit: Exit, marker: GMSMarker) {
        marker.snippet = "\(exit.route1)\(exit.route2)\(exit.route3)\(exit.route4)\(exit.route5)\(exit.route6)\(exit.route7)\(exit.route8)\(exit.route9)\(exit.route10)\(exit.route11) "
        marker.position = CLLocationCoordinate2D(latitude: exit.stationLatitude, longitude: exit.stationLongitude)
        let imgColor = GMSMarker.markerImage(with: GuideColor.chooseColorFor(line: exit.route1))
        marker.icon = imgColor
    }
    
    private func exitLevel(_ exit: Exit, marker: GMSMarker) {
        marker.position = CLLocationCoordinate2D(latitude: exit.latitude, longitude: exit.longitude)
        marker.snippet = "\(exit.route1)\(exit.route2)\(exit.route3)\(exit.route4)\(exit.route5)\(exit.route6)\(exit.route7)\(exit.route8)\(exit.route9)\(exit.route10)\(exit.route11) " + exit.entranceType.rawValue

        let imgColor = GMSMarker.markerImage(with: GuideColor.chooseColorFor(line: exit.route1))
        marker.icon = imgColor
    }
    
    private func setUserLocationOnMap(_ location: CLLocation) {
        mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 19, bearing: .zero, viewingAngle: 0)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        
        let tempBox = ExitCalloutView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tempBox.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        self.view.addSubview(mapToggleButton)
        self.view.addSubview(elevatorEscalatorStatusButton)
        self.view.addSubview(serviceStatusButton)
        self.view.addSubview(subwayTimesButton)
        self.view.addSubview(tempBox)
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        mapToggleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26).isActive = true
        mapToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        mapToggleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        elevatorEscalatorStatusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26).isActive = true
        elevatorEscalatorStatusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        elevatorEscalatorStatusButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        serviceStatusButton.bottomAnchor.constraint(equalTo: elevatorEscalatorStatusButton.topAnchor, constant: 8).isActive = true
        serviceStatusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        serviceStatusButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        serviceStatusButton.isHidden = true
        
        subwayTimesButton.bottomAnchor.constraint(equalTo: mapToggleButton.topAnchor, constant: 8).isActive = true
        subwayTimesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        subwayTimesButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        subwayTimesButton.isHidden = true
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
            print("good 2 go")
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                setUserLocationOnMap(location)
            }
            return
        case .denied, .restricted, .notDetermined:
            print("requesting again")
            locationManager.requestWhenInUseAuthorization()
            return
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            setUserLocationOnMap(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("user location failed")
        print("error: \(error)")
    }
}

extension MapViewController: GMSMapViewDelegate {
    
}

extension MapViewController: GMSIndoorDisplayDelegate {

}
