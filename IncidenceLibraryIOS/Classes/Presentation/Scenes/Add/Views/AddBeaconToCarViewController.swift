//
//  AddBeaconToCarViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import UIKit

class AddBeaconToCarViewController: IABaseViewController, StoryboardInstantiable {

    static var storyboardFileName = "AddScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var tableView: UITableView!
    
    var bottomSheetController: BottomSheetViewController?
    

    private var viewModel: AddBeaconToCarViewModel! { get { return baseViewModel as? AddBeaconToCarViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: AddBeaconToCarViewModel) -> AddBeaconToCarViewController {
        let view = AddBeaconToCarViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
     
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.estimatedRowHeight = VehicleCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(VehicleCell.self, forCellReuseIdentifier: VehicleCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
    }
    
    override func loadData() {
        showHUD()
        Api.shared.getVehicles(completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let vehicles = result.getList(key: "vehicles") ?? [Vehicle]()
                
                self.viewModel.vehicles = vehicles
                self.tableView.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    private func configureBottomSheet(model: Vehicle) {
        let view = LinkToCarBottomSheetView()
  
        let title = String(format: "ask_link_beacon_to_vehicle_linked".localized(), model.getName())
        view.configure(delegate: self, title: title, firstButtonText: "cancel".localized(), secondButtonText: "replace_beacon".localized(), identifier: model)
        
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
    
    
    private func vinculateBeaconToVehicle(_ vehicle:Vehicle)
    {
        showHUD()
        Api.shared.addBeacon(beacon: viewModel.beacon, vehicle: vehicle, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                vehicle.beacon = result.get(key: "beacon")
                Core.shared.saveVehicle(vehicle: vehicle)
                EventNotification.post(code: .VEHICLE_UPDATED, object: vehicle)
                EventNotification.post(code: .BEACON_ADDED, object: vehicle.beacon)
                
                //Show beacon added view
                let vm = RegistrationSuccessBeaconViewModel(origin: .addBeacon, isIoT: (vehicle.beacon?.iot != nil))
                let viewController = RegistrationSuccessBeaconViewController.create(with: vm)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
}

extension AddBeaconToCarViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: nil)
    }
    
    func secondButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: {
            self.vinculateBeaconToVehicle(identifier as! Vehicle)
        })
    }
    
    
}

extension AddBeaconToCarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vehicles.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleCell.reuseIdentifier, for: indexPath) as? VehicleCell else {
            assertionFailure("Cannot dequeue reusable cell \(VehicleCell.self) with reuseIdentifier: \(VehicleCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        if indexPath.row < viewModel.vehicles.count {
            cell.configure(with: viewModel.vehicles[indexPath.row])
        } else {
            cell.configure(with: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < viewModel.vehicles.count {
            
            if let model = viewModel.vehicles[indexPath.row] {
                
                if model.beacon != nil {
                    configureBottomSheet(model: model)
                    present(bottomSheetController!, animated: true, completion: nil)
                } else {
                    vinculateBeaconToVehicle(model)
                }
            }
            
        } else {
            let vm = RegistrationVehicleViewModel(origin: .add)
            vm.becomeFromAddBeacon = true
            let viewController = RegistrationVehicleViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VehicleCell.height
    }
}
