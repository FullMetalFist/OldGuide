//
//  MapViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/24/22.
//

import UIKit
import CoreLocation
import GoogleMaps
import GoogleMapsUtils

class MapViewController: UIViewController {
    
    private var exits: [Exit] = []
    private var clusterManager: GMUClusterManager?
    private var markers: [GMSMarker] = []
    private let mapViewModel = MapViewModel()
    private let locationManager = CLLocationManager()
    
    lazy var mapView: GMSMapView = {
        let map = GMSMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.settings.compassButton = true
        
        return map
    }()
    
    lazy var polyLine: GMSPolyline = {
        let pL = GMSPolyline()
        return pL
    }()
    
    lazy var bottomAreaStackView: UIStackView = {
        return UIStackView()
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mapToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("PDF Map", for: .normal)
        button.titleLabel?.backgroundColor = .black
        return button
    }()
    
    lazy var elevatorEscalatorStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Status", for: .normal)
        button.titleLabel?.backgroundColor = .black
        return button
    }()
    
    lazy var serviceStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Service", for: .normal)
        button.titleLabel?.backgroundColor = .black
        return button
    }()
    
    lazy var subwayTimesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
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
    
    func fetchDirections(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        NetworkManager.shared.fetchPathFromURL(origin: "\(origin.latitude),\(origin.longitude)", destination: "\(destination.latitude),\(destination.longitude)", completion: { result in
            
            switch result {
            case .success(let r):
                
                let points = r.overviewPolyline.points
                DispatchQueue.main.async {
                    self.polyLine.strokeColor = .clear
                    let path = GMSPath.init(fromEncodedPath: points)
                    self.polyLine = GMSPolyline.init(path: path)
                    self.polyLine.strokeColor = .orange
                    self.polyLine.strokeWidth = 5
                    self.polyLine.map = self.mapView
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        })
    }
    
    private func addTargets() {
        mapToggleButton.addTarget(self, action: #selector(mapToggleButtonTapped(_:)), for: .touchUpInside)
        elevatorEscalatorStatusButton.addTarget(self, action: #selector(elevatorEscalatorStatusButtonTapped(_:)), for: .touchUpInside)
        serviceStatusButton.addTarget(self, action: #selector(serviceStatusButtonTapped(_:)), for: .touchUpInside)
        subwayTimesButton.addTarget(self, action: #selector(subwayTimesButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func fetchExits() {
        
        if exits.isEmpty {
            mapViewModel.fetchExitLocations { result in
                switch result {
                case .success(let exits):
                    self.exits = exits
                case .error(let error):
                    print("\(error)")
                }
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
//        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [NSNumber(value: 3)])
//        let distanceBased = GMUNonHierarchicalDistanceBasedAlgorithm(clusterDistancePoints: 1)
//        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
//        renderer.delegate = self
//        clusterManager = GMUClusterManager(map: mapView, algorithm: distanceBased!, renderer: renderer)
//        clusterManager?.add(markers)
//        clusterManager?.setMapDelegate(self)
//        clusterManager?.cluster()
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
        
        self.view.addSubview(mapView)
        self.view.addSubview(distanceLabel)
        self.view.addSubview(mapToggleButton)
        self.view.addSubview(elevatorEscalatorStatusButton)
        self.view.addSubview(serviceStatusButton)
        self.view.addSubview(subwayTimesButton)
        mapToggleButton.isHidden = true
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        if #available(iOS 16.0, *) {
            mapToggleButton.isHidden = false
        }
        
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
        do {
            if let url = mapViewModel.passCustomMapURL() {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: url)
            }
        }
        catch {
            print("\(error.localizedDescription)")
        }
        
    }
    
    @objc func mapToggleButtonTapped(_ sender: UIButton) {
        let pmvc = PDFMapViewController()
        navigationController?.pushViewController(pmvc, animated: true)
    }
    
    @objc func elevatorEscalatorStatusButtonTapped(_ sender: UIButton) {
        let ovc = OutageViewController()
        navigationController?.pushViewController(ovc, animated: true)
    }
    
    @objc func serviceStatusButtonTapped(_ sender: UIButton) {
        print("serviceStatusButtonTapped")
    }
    
    @objc func subwayTimesButtonTapped(_ sender: UIButton) {
        let location = locationManager.location
        let lmvc = LiveMapViewController(lat: location?.coordinate.latitude, lng: location?.coordinate.longitude)
        navigationController?.pushViewController(lmvc, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus
        switch authStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                setUserLocationOnMap(location)
            }
            return
        case .denied, .restricted, .notDetermined:
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
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let userLocation = locationManager.location else { return }
        fetchDirections(origin: userLocation.coordinate, destination: marker.position)
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        mapView.animate(toLocation: marker.position)
//
//        if marker.userData is GMUCluster {
//            mapView.animate(toZoom: mapView.camera.zoom + 1)
//            print("clustered marker")
//            return true
//        }
//        print("regular marker")
//        return false
//    }
}

extension MapViewController: GMUClusterRendererDelegate {

}
