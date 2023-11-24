//
//  VehiclesDriversEditViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 19/5/21.
//

import UIKit

class VehiclesDriversEditViewController: IABaseViewController, StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesDriversEditViewModel! { get { return baseViewModel as? VehiclesDriversEditViewModel }}
    
    var bottomSheetController: BottomSheetViewController?
    var driverType = 0
    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesDriversEditViewModel) -> VehiclesDriversEditViewController {
        let view = VehiclesDriversEditViewController.instantiateViewController()
        view.baseViewModel = viewModel
        view.driverType = viewModel.driver.type ?? 0
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = DriverEditCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DriverEditCell.self, forCellReuseIdentifier: DriverEditCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        continueButton.setTitle("save".localized(), for: .normal)
        cancelButton.setTitle("delete".localized(), for: .normal)
        cancelButton.setTitleColor(UIColor.app(.errorPrimary), for: .normal)
        
        setUpNavigation()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage.app( "Close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closePressed))
        closeButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func configureDeleteBottomSheet() {
        
        let view = VehiclesDeleteBottomSheetView()
       
        view.configure(delegate: self, title: String(format: "delete_driver_message".localized(), viewModel.driver.name ?? ""), firstButtonText: "cancel".localized(), secondButtonText: "delete".localized(), identifier: "delete")
      
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
    
    private func configureBottomSheet()
    {
        let message = "select_type_driver".localized()
        let identifier = "driver"
        
        let view = HomeBottomSheetView()
        view.configure(delegate: self, title: "", description: message, firstButtonText: "driver_primary".localized(), secondButtonText: "driver_secondary".localized(), identifier: identifier)
      
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any)
    {
        configureDeleteBottomSheet()
        navigationController?.present(bottomSheetController!, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if (driverType != viewModel.driver.type)
        {
            if let driverId = viewModel.driver.id, let vehicleId = viewModel.vehicle.id {
                
                let user = Core.shared.getUser()
                let isUserPrimary = Core.shared.isUserPrimaryForVehicle(viewModel.vehicle)
                
                if (isUserPrimary)
                {   //El usuario es el principal con lo que puede gestionar el cambio directamente
                    showHUD()
                    Api.shared.changeVehicleDriver(vehicleId: String(vehicleId), userId: String(driverId), completion: { result in
                        self.hideHUD()
                        if (result.isSuccess())
                        {
                            if let drs = self.viewModel.vehicle.drivers {
                                for dr in drs {
                                    
                                    if let userId = user?.id, userId == dr.id {
                                        //el usuario pasa a ser secundario.
                                        dr.type = 0
                                    }
                                    else if (dr.id == self.viewModel.driver.id)
                                    {
                                        dr.type = self.driverType
                                    }
                                }
                                Core.shared.saveVehicle(vehicle: self.viewModel.vehicle)
                                EventNotification.post(code: .VEHICLE_UPDATED, object: self.viewModel.vehicle)
                            }
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        else
                        {
                            self.onBadResponse(result: result)
                        }
                   })
                }
                else
                {   //El usuario es el secundario y solicita ser principal.
                    
                    showHUD()
                    Api.shared.requestAddVehicleDriver(vehicleId: String(vehicleId), type: String(driverType), completion: { result in
                        self.hideHUD()
                        if (result.isSuccess())
                        {
                            EventNotification.post(code: .VEHICLE_DRIVER_UPDATED)
                            self.navigationController?.popViewController(animated: true)
                        }
                        else
                        {
                            self.onBadResponse(result: result)
                        }
                   })
                }
            }
        }
    }
}

extension VehiclesDriversEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DriverEditCell.reuseIdentifier, for: indexPath) as? DriverEditCell else {
            assertionFailure("Cannot dequeue reusable cell \(DriverEditCell.self) with reuseIdentifier: \(DriverCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        var str = viewModel.driver.name ?? ""
        if (indexPath.row == 1)
        {
            str = driverType == 1 ? "driver_primary".localized() : "driver_secondary".localized()
        }

        cell.configure(with: str, editable: indexPath.row == 1)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DriverEditCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 1)
        {
            configureBottomSheet()
            navigationController?.present(bottomSheetController!, animated: true, completion: nil)
        }
    }
}

extension VehiclesDriversEditViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        
        bottomSheetController?.dismiss(animated: true, completion: {
            
            
            if let identifier = identifier as? String, identifier == "driver" {
                self.driverType = 1
                self.tableView.reloadData()
            }
            else
            {
                
            }
        })
        
    }
    
    func secondButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: {
            
            
            if let identifier = identifier as? String, identifier == "driver" {
                self.driverType = 0
                self.tableView.reloadData()
            }
            else
            {
                //delete driver
                
                if let driverId = self.viewModel.driver.id, let vehicleId = self.viewModel.vehicle.id {
                    
                    let user = Core.shared.getUser()
                    var isDriverUser = false
                    if let userId = user?.id, userId == driverId {
                        isDriverUser = true
                    }
                    
                    self.showHUD()
                    Api.shared.deleteVehicleDriver(vehicleId: String(vehicleId), userId: String(driverId), completion: { result in
                        self.hideHUD()
                        if (result.isSuccess())
                        {
                            if (isDriverUser)
                            {
                                Core.shared.deleteVehicle(vehicle: self.viewModel.vehicle)
                                EventNotification.post(code: .VEHICLE_DELETED, object: self.viewModel.vehicle)
                                
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            else
                            {
                                var list = [Driver]()
                                if let drs = self.viewModel.vehicle.drivers {
                                    for dr in drs {
                                        if (dr.id != self.viewModel.driver.id)
                                        {
                                            list.append(dr)
                                        }
                                    }
                                    
                                }
                                
                                self.viewModel.vehicle.drivers = list
                                Core.shared.saveVehicle(vehicle: self.viewModel.vehicle)
                                EventNotification.post(code: .VEHICLE_UPDATED, object: self.viewModel.vehicle)
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        else
                        {
                            self.onBadResponse(result: result)
                        }
                   })
                }
                
            }
            
        })
    }
}
