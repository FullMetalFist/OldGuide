//
//  OutageDetailViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/13/22.
//

import UIKit

class OutageDetailViewController: UIViewController {
    
    lazy var stationLabel: UILabel = {
        let sL = UILabel()
        sL.translatesAutoresizingMaskIntoConstraints = false
        return sL
    }()
    
    lazy var stationDetailLabel: UILabel = {
        let sdL = UILabel()
        sdL.translatesAutoresizingMaskIntoConstraints = false
        return sdL
    }()
    
    lazy var boroughLabel: UILabel = {
        let bL = UILabel()
        bL.translatesAutoresizingMaskIntoConstraints = false
        return bL
    }()
    
    lazy var boroughDetailLabel: UILabel = {
        let bdL = UILabel()
        bdL.translatesAutoresizingMaskIntoConstraints = false
        return bdL
    }()
    
    lazy var trainLabel: UILabel = {
        let tL = UILabel()
        tL.translatesAutoresizingMaskIntoConstraints = false
        return tL
    }()
    
    lazy var trainDetailLabel: UILabel = {
        let tdL = UILabel()
        tdL.translatesAutoresizingMaskIntoConstraints = false
        return tdL
    }()
    
    lazy var serviceLabel: UILabel = {
        let sL = UILabel()
        sL.translatesAutoresizingMaskIntoConstraints = false
        return sL
    }()
    
    lazy var serviceDetailLabel: UILabel = {
        let sdL = UILabel()
        sdL.translatesAutoresizingMaskIntoConstraints = false
        sdL.numberOfLines = 0
        return sdL
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = Constants.outageTitle
        setupViews()
    }
    
    func displayWithOutage(outage: ElevatorEscalatorStatusModel) {
        stationLabel.text = "station"
        stationDetailLabel.text = outage.station
        boroughLabel.text = "borough"
        boroughDetailLabel.text = outage.borough
        trainLabel.text = "train"
        trainDetailLabel.text = outage.train
        serviceLabel.text = "serving"
        serviceDetailLabel.text = outage.serving
    }
    
    private func setupViews() {
        view.addSubview(stationLabel)
        view.addSubview(stationDetailLabel)
        view.addSubview(boroughLabel)
        view.addSubview(boroughDetailLabel)
        view.addSubview(trainLabel)
        view.addSubview(trainDetailLabel)
        view.addSubview(serviceLabel)
        view.addSubview(serviceDetailLabel)
        
        let layoutMarginsGuide = view.layoutMarginsGuide
        
        stationLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 30.0).isActive = true
        stationLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        stationLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        stationLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        stationLabel.bottomAnchor.constraint(equalTo: stationDetailLabel.topAnchor, constant: -30.0).isActive = true
        stationDetailLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        stationDetailLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        stationDetailLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        stationDetailLabel.bottomAnchor.constraint(equalTo: boroughLabel.topAnchor, constant: -30.0).isActive = true
        
        boroughLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        boroughLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        boroughLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        boroughLabel.bottomAnchor.constraint(equalTo: boroughDetailLabel.topAnchor, constant: -30.0).isActive = true
        
        boroughDetailLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        boroughDetailLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        boroughDetailLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        boroughDetailLabel.bottomAnchor.constraint(equalTo: trainLabel.topAnchor, constant: -30).isActive = true
        
        trainLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        trainLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        trainLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        trainLabel.bottomAnchor.constraint(equalTo: trainDetailLabel.topAnchor, constant: -30.0).isActive = true
        
        trainDetailLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        trainDetailLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        trainDetailLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        trainDetailLabel.bottomAnchor.constraint(equalTo: serviceLabel.topAnchor, constant: -30.0).isActive = true
        
        serviceLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        serviceLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        serviceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        serviceLabel.bottomAnchor.constraint(equalTo: serviceDetailLabel.topAnchor, constant: -30).isActive = true
        
        serviceDetailLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        serviceDetailLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
    }
}
