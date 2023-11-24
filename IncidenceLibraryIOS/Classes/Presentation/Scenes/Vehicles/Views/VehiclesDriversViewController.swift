//
//  VehiclesDriversViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 19/5/21.
//

import UIKit

class VehiclesDriversViewController: IABaseViewController, StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesDriversViewModel! { get { return baseViewModel as? VehiclesDriversViewModel }}
    private var drivers: [Driver] = []
    
    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesDriversViewModel) -> VehiclesDriversViewController {
        let view = VehiclesDriversViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = DriverCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DriverCell.self, forCellReuseIdentifier: DriverCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        setUpNavigation()
    }
    
    private func setUpNavigation() { /*
        let editButton = UIBarButtonItem(image: UIImage.app( "icon_edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editPressed))
        editButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = editButton
        */
    }
    /*
    @objc func editPressed() {
        let vm = VehiclesDriversEditViewModel()
        let vc = VehiclesDriversEditViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .VEHICLE_UPDATED, selector: #selector(vehicleUpdated))
    }
    
    override func loadData() {
        
        drivers.removeAll()
        
        if let list = viewModel.vehicle.drivers {
            
            for dr in list {
                
                if (dr.isTypePrimary())
                {
                    drivers.insert(dr, at: 0)
                }
                else
                {
                    drivers.append(dr)
                }
            }
        }
    }
    
    @objc func vehicleUpdated(_ notification: Notification) {
        
        if let vehicle = notification.object as? Vehicle {
            if (vehicle.id == viewModel.vehicle.id) {
                viewModel.vehicle = vehicle
                
                self.loadData()
                self.tableView.reloadData()
            }
        }
    }
}

extension VehiclesDriversViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DriverCell.reuseIdentifier, for: indexPath) as? DriverCell else {
            assertionFailure("Cannot dequeue reusable cell \(DriverCell.self) with reuseIdentifier: \(DriverCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        let isUserPrimary = Core.shared.isUserPrimaryForVehicle(viewModel.vehicle)
        
        cell.configure(with: drivers[indexPath.row], isUserPrimary: isUserPrimary)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DriverCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let driver = drivers[indexPath.row]
        let user = Core.shared.getUser()
        var isDriverUser = false
        if let userId = user?.id, userId == driver.id {
            isDriverUser = true
        }
        let isUserPrimary = Core.shared.isUserPrimaryForVehicle(viewModel.vehicle)
        
        if (driver.isTypePrimary())
        {
            //no se edita
        }
        else
        {
            if (isUserPrimary || isDriverUser)
            {
                let vm = VehiclesDriversEditViewModel()
                vm.driver = driver
                vm.vehicle = viewModel.vehicle
                let vc = VehiclesDriversEditViewController.create(with: vm)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
