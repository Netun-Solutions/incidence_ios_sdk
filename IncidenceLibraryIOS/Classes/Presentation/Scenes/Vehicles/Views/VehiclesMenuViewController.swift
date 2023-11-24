//
//  VehiclesMenuViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import UIKit

class VehiclesMenuViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesMenuViewModel! { get { return baseViewModel as? VehiclesMenuViewModel }}
    
    @IBOutlet weak var vehicleInfoMenuView: MenuView!
    @IBOutlet weak var insuranceMenuView: MenuView!
    @IBOutlet weak var beaconMenuView: MenuView!
    @IBOutlet weak var incidencesMenuView: MenuView!
    @IBOutlet weak var driversMenuView: MenuView!
    
    @IBOutlet weak var deleteMenuView: MenuView!
    
    var bottomSheetController: BottomSheetViewController?
    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesMenuViewModel) -> VehiclesMenuViewController {
        let view = VehiclesMenuViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .VEHICLE_UPDATED, selector: #selector(vehicleUpdated))
    }
    
    override func setUpUI() {
        super.setUpUI()
        vehicleInfoMenuView.configure(text: "vehicle_data".localized(), iconImage: UIImage.app( "Property"))
        vehicleInfoMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            
            let viewModel = VehiclesInfoViewModel(vehicle: strongSelf.viewModel.vehicle)
            let viewController = VehiclesInfoViewController.create(with: viewModel)
            strongSelf.navigationController?.pushViewController(viewController, animated: true)
        }
        
        insuranceMenuView.configure(text: "insurance_data".localized(), iconImage: UIImage.app( "Document"), showIndicator: self.viewModel.vehicle.hasPolicyIncompleted())
        insuranceMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            
            let viewModel = VehiclesInsuranceViewModel(vehicle: strongSelf.viewModel.vehicle)
            let viewController = VehiclesInsuranceViewController.create(with: viewModel)
            strongSelf.navigationController?.pushViewController(viewController, animated: true)
        }
        
        beaconMenuView.configure(text: "beacon".localized(), iconImage: UIImage.app( "Dispositivo"))
        beaconMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            
            let viewModel = VehiclesBeaconViewModel(vehicle: strongSelf.viewModel.vehicle)
            let viewController = VehiclesBeaconViewController.create(with: viewModel)
            strongSelf.navigationController?.pushViewController(viewController, animated: true)
            
        }
        
        incidencesMenuView.configure(text: "incidences".localized(), iconImage: UIImage.app( "Warning"))
        incidencesMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            let viewModel = IncidencesListViewModel(vehicle: strongSelf.viewModel.vehicle)
            let viewController = IncidencesListViewController.create(with: viewModel)
            strongSelf.navigationController?.pushViewController(viewController, animated: true)
        }
        
        driversMenuView.configure(text: "Conductores", iconImage: UIImage.app( "User"))
        driversMenuView.onTap {[weak self] in
            guard let strongSelf = self else { return }
            let viewModel = VehiclesDriversViewModel()
            viewModel.vehicle = strongSelf.viewModel.vehicle
            let viewController = VehiclesDriversViewController.create(with: viewModel)
            strongSelf.navigationController?.pushViewController(viewController, animated: true)
        }
        //driversMenuView.isHidden = true
        
        deleteMenuView.configure(text: "delete_vechicle".localized(), color: .red)
        deleteMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.configureBottomSheet()
            strongSelf.present(strongSelf.bottomSheetController!, animated: true, completion: nil)
        }
        
        setUpNavigation()
    }
    
    override func loadData() {
        
        let count = self.viewModel.vehicle.incidences != nil ? " (" + String(self.viewModel.vehicle.incidences!.count) + ")" : ""
        incidencesMenuView.setTitle(title: "incidences".localized() + count)
        
        let count2 = self.viewModel.vehicle.drivers != nil ? " (" + String(self.viewModel.vehicle.drivers!.count) + ")" : ""
        driversMenuView.setTitle(title: "drivers".localized() + count2)
    }
    
    private func setUpNavigation() {
        let plateButton = UIBarButtonItem(title: viewModel.vehicle.licensePlate, style: .plain, target: nil, action: nil)
        if let font = UIFont.app(.primarySemiBold, size: 16), let color = UIColor.app(.black400) {
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
            plateButton.setTitleTextAttributes(attributes, for: .normal)
            plateButton.setTitleTextAttributes(attributes, for: .highlighted)
            plateButton.setTitleTextAttributes(attributes, for: .focused)
            plateButton.setTitleTextAttributes(attributes, for: .selected)
            plateButton.setTitleTextAttributes(attributes, for: .disabled)
            plateButton.isEnabled = false
        }
        
        navigationItem.rightBarButtonItem = plateButton
    }
    
    
    private func configureBottomSheet() {
        let view = VehiclesDeleteBottomSheetView()
        
        
        var titPrimary = false
        if (Core.shared.isUserPrimaryForVehicle(self.viewModel.vehicle)) {
            if let drivers = self.viewModel.vehicle.drivers, drivers.count > 1 {
                titPrimary = true
            }
        }
        
        let titulo =  titPrimary ? "delete_vechicle_message_primary".localized() : "delete_vechicle_message".localized()
       
        view.configure(delegate: self, title: titulo, firstButtonText: "cancel".localized(), secondButtonText: "delete".localized(), identifier: nil)
      
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
    
    @objc func vehicleUpdated(_ notification: Notification) {
        
        if let vehicle = notification.object as? Vehicle {
            if (vehicle.id == viewModel.vehicle.id) {
                viewModel.vehicle = vehicle
                setUpNavigation()
            }
        }
    }
}

extension VehiclesMenuViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: nil)
    }
    
    func secondButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: {
            
            
            if (Core.shared.isUserPrimaryForVehicle(self.viewModel.vehicle))
            {
                self.showHUD()
                Api.shared.deleteVehicle(vehicle: self.viewModel.vehicle, completion: { result in
                    self.hideHUD()
                    if (result.isSuccess())
                    {
                        Core.shared.deleteVehicle(vehicle: self.viewModel.vehicle)
                        EventNotification.post(code: .VEHICLE_DELETED, object: self.viewModel.vehicle)
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        self.onBadResponse(result: result)
                    }
               })
            }
            else
            {
                if let user = Core.shared.getUser(), let userId = user.id {
                    self.showHUD()
                    Api.shared.deleteVehicleDriver(vehicleId: String(self.viewModel.vehicle.id ?? 0), userId: String(userId), completion: { result in
                        self.hideHUD()
                        if (result.isSuccess())
                        {
                            Core.shared.deleteVehicle(vehicle: self.viewModel.vehicle)
                            EventNotification.post(code: .VEHICLE_DELETED, object: self.viewModel.vehicle)
                            
                            self.navigationController?.popViewController(animated: true)
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

