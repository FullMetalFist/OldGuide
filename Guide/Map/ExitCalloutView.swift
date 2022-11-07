//
//  ExitCalloutView.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/1/22.
//

import UIKit

class ExitCalloutView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private var stackView = UIStackView()
    private var contentView = UIView()
    let trainAvailableLabel = UILabel()
    let stationLabel = UILabel()
    let exitTypeLabel = UILabel()
    
    init(_ trainAvailable: String, station: String, exitType: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 170, height: 50))
        self.trainAvailableLabel.text = trainAvailable
        self.stationLabel.text = station
        self.exitTypeLabel.text = exitType
        setup()
    }
    
    /*
     stackview on side to show trunk line
     in center show top trains available
     below station name
     under station name type of exit
     */
    
    private func setup() {
        guard let rView = inputView else { return }
        rView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        contentView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        contentView.addSubview(trainAvailableLabel)
        trainAvailableLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        trainAvailableLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        trainAvailableLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        trainAvailableLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        trainAvailableLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }
}
