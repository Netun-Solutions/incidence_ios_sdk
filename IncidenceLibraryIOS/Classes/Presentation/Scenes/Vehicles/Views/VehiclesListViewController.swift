//
//  VehiclesListViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import UIKit

class VehiclesListViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesListViewModel! { get { return baseViewModel as? VehiclesListViewModel }}
    
    private lazy var addVehicle: Vehicle = {
        let vehicle = Vehicle()
        vehicle.id = -1
        return vehicle
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesListViewModel) -> VehiclesListViewController {
        let view = VehiclesListViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .VEHICLE_UPDATED, selector: #selector(vehicleUpdated))
        EventNotification.addObserver(self, code: .VEHICLE_DELETED, selector: #selector(vehicleDeleted))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
        })?.removeFromSuperview()
    }
    
    override func setUpUI() {
        super.setUpUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = VehicleColorCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(VehicleColorCell.self, forCellReuseIdentifier: VehicleColorCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
    }
    
    override func loadDataDelay() -> Bool {
        return true
    }
    override func loadData()
    {
        showHUD()
        Api.shared.getVehicles(completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                var vehicles = result.getList(key: "vehicles") ?? [Vehicle]()
                //if (vehicles.count == 0) {
                    vehicles.append(self.addVehicle)
                //}
                
                self.viewModel.vehicles = vehicles
                self.tableView.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    @objc func vehicleUpdated(_ notification: Notification) {
        
        if let vehicle = notification.object as? Vehicle {
            
            var items = [Vehicle]()
            if (self.viewModel.vehicles != nil)
            {
                for ve in self.viewModel.vehicles {
                    
                    if (vehicle.id == ve.id) {
                        items.append(vehicle)
                    }
                    else {
                        items.append(ve)
                    }
                }
            }
            
            self.viewModel.vehicles = items
            self.tableView.reloadData()
        }
    }
    
    @objc func vehicleDeleted(_ notification: Notification) {
        
        if let vehicle = notification.object as? Vehicle {
            
            var items = [Vehicle]()
            if (self.viewModel.vehicles != nil)
            {
                for ve in self.viewModel.vehicles {
                    
                    if (vehicle.id != ve.id) {
                        items.append(ve)
                    }
                }
            }
            
            self.viewModel.vehicles = items
            self.tableView.reloadData()
        }
    }
}


extension VehiclesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleColorCell.reuseIdentifier, for: indexPath) as? VehicleColorCell else {
            assertionFailure("Cannot dequeue reusable cell \(VehicleColorCell.self) with reuseIdentifier: \(VehicleColorCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
     
        cell.configure(with: viewModel.vehicles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vehicle = viewModel.vehicles[indexPath.row]
            
        if (vehicle.id == self.addVehicle.id)
        {
            let vm = RegistrationVehicleViewModel(origin: .add)
            let viewController = RegistrationVehicleViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            let vm = VehiclesMenuViewModel(vehicle: vehicle)
            let vc = VehiclesMenuViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VehicleColorCell.height
    }
}

