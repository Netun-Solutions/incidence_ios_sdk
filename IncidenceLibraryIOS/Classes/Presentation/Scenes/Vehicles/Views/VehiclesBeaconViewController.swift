//
//  VehiclesBeaconViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 19/5/21.
//

import UIKit

class VehiclesBeaconViewController: IABaseViewController, StoryboardInstantiable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextFieldView: FieldView!
    @IBOutlet weak var modelTextFieldView: FieldView!
    
    @IBOutlet weak var deleteButton: TextButton!
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    var bottomSheetController: BottomSheetViewController?
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesBeaconViewModel! { get { return baseViewModel as? VehiclesBeaconViewModel }}
    
    let addView = MenuView()
    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesBeaconViewModel) -> VehiclesBeaconViewController {
        let view = VehiclesBeaconViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
        })?.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .BEACON_UPDATED, selector: #selector(beaconUpdated))
        EventNotification.addObserver(self, code: .VEHICLE_UPDATED, selector: #selector(vehicleUpdated))
    }
    
    override func setUpUI() {
        super.setUpUI()
        deleteButton.setTitle(viewModel.deleteButtonText, for: .normal)
        deleteButton.backgroundColor = .clear
        deleteButton.setTitleColor(UIColor.app(.errorPrimary), for: .normal)
        
        
        if (Core.shared.isUserPrimaryForVehicle(viewModel.vehicle))
        {
            self.view.addSubview(addView)
            let height = CGFloat(59)
            addView.anchor(top: self.view.safeTopAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 24, rightConstant: 24, heightConstant: height)
            addView.configure(text: "add_new_device".localized(), color: .blue, rightIcon: .add)
            let tap = UITapGestureRecognizer(target: self, action: #selector(addBeacon))
            addView.addGestureRecognizer(tap)
        }
    }
    
    override func loadData() {
        if let beacon = viewModel.vehicle?.beacon {
            
            addView.isHidden = true
            deleteButton.isHidden = Core.shared.isUserPrimaryForVehicle(viewModel.vehicle) ? false : true
            nameTextFieldView.isHidden = false
            modelTextFieldView.isHidden = false
            nameTextFieldView.configure(titleText: viewModel.fieldNameTitle, valueText: beacon.name ?? "-")
            modelTextFieldView.configure(titleText: viewModel.fieldModelTitle, valueText: beacon.beaconType?.name ?? "")
        }
        else {
            addView.isHidden = false
            deleteButton.isHidden = true
            nameTextFieldView.isHidden = true
            modelTextFieldView.isHidden = true
        }
        
        setUpNavigation()
    }
    
    @objc private func addBeacon()
    {
        let vm = RegistrationBeaconViewModel(origin: .addBeacon)
        vm.fromBeacon = true
        vm.autoSelectedVehicle = viewModel.vehicle
        let viewController = RegistrationBeaconSelectTypeViewController.create(with: vm)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func configureBottomSheet() {
        let view = ButtonsBottomSheetView()
  
        let title = String(format: "unlink_beacon_message".localized(), viewModel.vehicle?.getName() ?? "")
        view.configure(delegate: self, title:nil, desc: title, firstButtonText: "cancel".localized(), secondButtonText: "unlink".localized(), identifier: nil)
        
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
    
    private func setUpNavigation() {
        
        
        if (Core.shared.isUserPrimaryForVehicle(viewModel.vehicle))
        {
            let editButton = UIBarButtonItem(image: UIImage.app( "icon_edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editPressed))
            editButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
            
            if (viewModel.vehicle?.beacon) != nil {
                navigationItem.rightBarButtonItem = editButton
            }
            else {
                navigationItem.rightBarButtonItem = nil
            }
        }
        else
        {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func editPressed() {
        if (viewModel.vehicle?.beacon?.vehicle == nil) {
            viewModel.vehicle?.beacon?.vehicle = Vehicle()
            viewModel.vehicle?.beacon?.vehicle?.id = viewModel.vehicle?.id
        }
        
        let vm = DeviceEditNameViewModel(device: viewModel.vehicle?.beacon)
        let vc = DeviceEditViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        configureBottomSheet()
        present(bottomSheetController!, animated: true, completion: nil)
    }
    
    @objc func beaconUpdated(_ notification: Notification) {
        if let beacon = notification.object as? Beacon {
            viewModel.vehicle?.beacon = beacon
            loadData()
        }
    }
    
    @objc func vehicleUpdated(_ notification: Notification) {
        loadData()
    }
}

extension VehiclesBeaconViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: nil)
    }
    
    func secondButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: {
            
            self.showHUD()
            Api.shared.deleteVehicleBeacon(vehicle: self.viewModel.vehicle!, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    self.viewModel.vehicle?.beacon = nil
                    Core.shared.saveVehicle(vehicle: self.viewModel.vehicle)
                    EventNotification.post(code: .VEHICLE_UPDATED, object: self.viewModel.vehicle)
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.onBadResponse(result: result)
                }
           })
        })
    }
}
