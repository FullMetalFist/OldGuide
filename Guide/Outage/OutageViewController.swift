//
//  OutageViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/12/22.
//

import UIKit

class OutageViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tV = UITableView()
        tV.translatesAutoresizingMaskIntoConstraints = false
        return tV
    }()
    
    private let networkManager = NetworkManager.shared
    private var outages = [ElevatorEscalatorStatusModel]()

    var statusList: [ElevatorEscalatorStatusModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.fetchElevatorEscalatorStatus { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let outageList):
                    self.outages = outageList
                    self.tableView.reloadData()
                case .failure(let e):
                    print("error: \(e.localizedDescription)")
                }
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.elevatorEscalatorStatusCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension OutageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let outage = outages[indexPath.row]
        let odvc = OutageDetailViewController()
        odvc.displayWithOutage(outage: outage)
        navigationController?.pushViewController(odvc, animated: true)
    }
}

//extension OutageViewController: UITableViewDiffableDataSource
extension OutageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.elevatorEscalatorStatusCellIdentifier) else { return UITableViewCell() }
        cell.contentView.largeContentTitle = outages[indexPath.row].station
        cell.textLabel?.text = "\(outages[indexPath.row].station) \t\(outages[indexPath.row].type.rawValue)"
        return cell
    }
    
    
}
