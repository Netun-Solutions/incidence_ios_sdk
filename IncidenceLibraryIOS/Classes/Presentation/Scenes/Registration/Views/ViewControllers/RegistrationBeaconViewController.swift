//
//  RegistrationBeaconViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit

class RegistrationBeaconViewController: IABaseViewController, StoryboardInstantiable {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var laterButton: TextButton!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorText: TextLabel!
    @IBOutlet weak var backgrounImageView: UIImageView!
    
    private var bottomSheetController: BottomSheetViewController?
    
    let stepperView = StepperView()
    
    
    var selectedBeacon:Beacon!
    var isScanning = false
    var isGoingToSettingsLocation = false
    var beaconView:BeaconView!
    
    
    private var viewModel: RegistrationBeaconViewModel! { get { return baseViewModel as? RegistrationBeaconViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationBeaconViewModel) -> RegistrationBeaconViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationBeaconViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .APP_DID_BECOME_ACTIVE, selector: #selector(appDidBecomeActive))
        
        startScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (isScanning) {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            stopScan()
        }
    }
    
    @objc func appDidBecomeActive(_ notification: Notification) {
        if (self.isGoingToSettingsLocation)
        {
            if (!LocationManager.shared.isLocationEnabledAlways())
            {
                self.showAlert(message: "alert_no_location_to_beacon".localized())
            }
            else
            {
                isScanning = true
                showHUD()
                self.perform(#selector(stopScan), with: nil, afterDelay: 20)
                LocationManager.shared.startScanningBeacons(delegate: self)
            }
        }
    }
    
    func startScan()
    {
        if (LocationManager.shared.isLocationEnabled())
        {
            /*
            if (!LocationManager.shared.isLocationEnabledAlways())
            {
                let alertController: UIAlertController = UIAlertController(title: "nombre_app".localized(), message: "activate_location_message_beacon_always".localized(), preferredStyle: .alert)
                let firstAction: UIAlertAction = UIAlertAction(title: "activate_location_message_beacon_always_go".localized(), style: .default) { action -> Void in
                    //go settings
                    if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)")
                        , UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else
                    {
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                    }
                    
                    self.isGoingToSettingsLocation = true
                }

                let cancelAction: UIAlertAction = UIAlertAction(title: "cancel".localized(), style: .default) { action -> Void in
                    
                    self.showAlert(message: "alert_no_location_to_beacon".localized())
                    
                }
                alertController.addAction(firstAction)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                
            }
            */
            isScanning = true
            showHUD2()
            self.perform(#selector(stopScan), with: nil, afterDelay: 20)
            LocationManager.shared.startScanningBeacons(delegate: self)
            
        }
        else
        {
            //showBluetoothAlert()
            showLocationAlert()
        }
    }
    
    @objc func stopScan()
    {
        hideHUD2()
        showNoDevices()
        isScanning = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }

    override func setUpUI() {
        super.setUpUI()
        
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        helperLabel.isHidden = viewModel.helperLabelText == nil
        
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isHidden = viewModel.continueButtonText == nil
        
        laterButton.setTitle(viewModel.discardButtonText, for: .normal)
        laterButton.isHidden = viewModel.discardButtonText == nil
        
        backgrounImageView.isHidden = viewModel.status == .bluetoothFail || viewModel.status == .missingBeacon
        
        errorImageView.image = viewModel.errorImage
        errorImageView.isHidden = viewModel.errorImage == nil
        
        errorText.textAlignment = .center
        errorText.attributedText = viewModel.errorLabelText?.htmlAttributed(using: UIFont.app(.primaryRegular, size: 16)!)
        errorText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        errorText.isHidden = viewModel.errorLabelText == nil
        
        if (beaconView != nil)
        {
            beaconView.removeFromSuperview()
            beaconView = nil
        }
        if viewModel.status == .selectionBeacon {
            beaconView = BeaconView()
            beaconView.configure(text: "")
            self.view.addSubview(beaconView)
            beaconView.translatesAutoresizingMaskIntoConstraints = false
            beaconView.anchorCenterYToSuperview(constant: -66)
            beaconView.anchorCenterXToSuperview(constant: 34)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapBeacon(_:)))
            beaconView.addGestureRecognizer(tap)
        }
    }
    
    
    private func showNoDevices()
    {
        viewModel.status = .missingBeacon
        setUpUI()
    }
    
    private func showBeaconDetected()
    {
        viewModel.status = .selectionBeacon
        setUpUI()
    }
    
    private func configureLocationBottomSheet() {
        let view = HomeBottomSheetView()
       
        view.configure(delegate: self, title: "activate_location_title".localized(), description: "activate_location_message_beacon".localized(), firstButtonText: "activate_location".localized(), secondButtonText: "cancel".localized(), identifier: "location")
      
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.canHide = false
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
    
    private func showLocationAlert() {
        configureLocationBottomSheet()
        self.present(bottomSheetController!, animated: true, completion: {
            self.bottomSheetController!.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            self.bottomSheetController!.isModalInPresentation = true
        })
    }
    
    private func showBluetoothAlert() {
        let alert = UIAlertController(title: "alert_need_bluetooth_title".localized(), message: "alert_need_bluetooth_description".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { [weak self] _ in
            self?.viewModel.status = .bluetoothFail
            self?.setUpUI()
        }))
        alert.addAction(UIAlertAction(title: "settings".localized(), style: .default, handler: { [weak self] _ in
            let url = NSURL(string: "App-Prefs:root=Bluetooth")!
            UIApplication.shared.open(url as URL)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleTapBeacon(_ sender: UITapGestureRecognizer? = nil) {
        
        showHUD()
        Api.shared.validateBeacon(beacon: self.selectedBeacon, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                if self.viewModel.origin == .registration {
                    
                    let list = Core.shared.getVehicles()
                    if (list.count == 1) {
                        self.viewModel.autoSelectedVehicle = list[0]
                        self.addVehicleBeacon()
                    }
                    else
                    {
                        self.showHUD()
                        Api.shared.getVehicles(completion: { result in
                            if (result.isSuccess())
                            {
                                let vehicles = result.getList(key: "vehicles") ?? [Vehicle]()
                                if (vehicles.count == 1)
                                {
                                    let vehicle = vehicles[0]
                                    Api.shared.addBeacon(beacon: self.selectedBeacon, vehicle: vehicle, completion: { result in
                                        self.hideHUD()
                                        if (result.isSuccess())
                                        {
                                            vehicle.beacon = result.get(key: "beacon")
                                            Core.shared.saveVehicle(vehicle: vehicle)
                                            EventNotification.post(code: .VEHICLE_UPDATED, object: vehicle)
                                            EventNotification.post(code: .BEACON_ADDED, object: vehicle.beacon)
                                            
                                            //Show beacon added view
                                            let vm = RegistrationSuccessBeaconViewModel()
                                            vm.isIoT = (vehicle.beacon?.iot != nil)
                                            let viewController = RegistrationSuccessBeaconViewController.create(with: vm)
                                            self.navigationController?.pushViewController(viewController, animated: true)
                                        }
                                        else
                                        {
                                            self.onBadResponse(result: result)
                                        }
                                   })
                                }
                                else
                                {
                                    self.hideHUD()
                                    let vm = AddBeaconToCarViewModel()
                                    vm.beacon = self.selectedBeacon
                                    let viewController = AddBeaconToCarViewController.create(with: vm)
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                            }
                            else
                            {
                                self.hideHUD()
                                self.onBadResponse(result: result)
                            }
                       })
                    }
                    
                } else {
                    
                    if let model = self.viewModel.autoSelectedVehicle {
                        self.addVehicleBeacon()
                    }
                    else
                    {
                        let list = Core.shared.getVehicles()
                        if (list.count == 1) {
                            self.viewModel.autoSelectedVehicle = list[0]
                            self.addVehicleBeacon()
                        }
                        else{
                            let vm = AddBeaconToCarViewModel()
                            vm.beacon = self.selectedBeacon
                            let viewController = AddBeaconToCarViewController.create(with: vm)
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }
            }
            else
            {
                self.onBadResponse(result: result)
            }
        })
    }

    private func setUpStepperView() {
        switch viewModel.origin {
        case .editVehicle, .add:
            stepperView.totalStep = 2
        case .addBeacon:
            stepperView.totalStep = 1
        default:
            stepperView.totalStep = 3
        }
        
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
            })?.removeFromSuperview()

        navigationController?.view.addSubview(stepperView)
            
        if let view = navigationController?.navigationBar {
            stepperView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            stepperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
            stepperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
            stepperView.anchorCenterXToSuperview()
            stepperView.currentStep = 3
            stepperView.percentatge = 33
        }

    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        if (viewModel.status == .bluetoothFail) {
            viewModel.status = .missingBeacon
            setUpUI()
        }
        else {
            viewModel.status = .lookingBeacon
            setUpUI()
            startScan()
        }
    }
    
    @IBAction func laterButtonPressed(_ sender: Any) {
        print(viewModel.origin)
        if viewModel.origin == .registration {
            let vm = RegistrationSuccessViewModel()
            let viewController = RegistrationSuccessViewController.create(with: vm)
            navigationController?.setViewControllers([viewController], animated: true)
        } else if viewModel.origin == .addBeacon && isScanning {
            stopScan()
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
       
    }
    
    private func configureBottomSheetVehicle(model:Vehicle) {
        
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
        Api.shared.addBeacon(beacon: selectedBeacon, vehicle: vehicle, completion: { [self] result in
            self.hideHUD()
            if (result.isSuccess())
            {
                //vehicle.beacon = result.get(key: "beacon")
                if (self.selectedBeacon == nil) {
                    vehicle.beacon = result.get(key: "vehicleBeacon")
                } else {
                    let beaconResp = result.get(key: "vehicleBeacon") ?? Beacon()
                    self.selectedBeacon.id = beaconResp.id;
                    let beaconType = BeaconType()
                    if (self.selectedBeacon.iot != nil) {
                        beaconType.id = 2;
                    } else{
                        beaconType.id = 1;
                    }
                    self.selectedBeacon.beaconType = beaconType;
                    vehicle.beacon = self.selectedBeacon;
                }
                
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
    
    private func addVehicleBeacon()
    {
        if let model = self.viewModel.autoSelectedVehicle {
            if model.beacon != nil {
                configureBottomSheetVehicle(model: model)
                present(bottomSheetController!, animated: true, completion: nil)
            } else {
                vinculateBeaconToVehicle(model)
            }
        }
    }
}

extension RegistrationBeaconViewController: BeaconsDelegate {
    func onDetectBeacons(beacons: [Beacon])
    {
        if (beacons.count > 0)
        {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            isScanning = false
            hideHUD()
            selectedBeacon = beacons[0]
            showBeaconDetected()
        }
    }
}

extension RegistrationBeaconViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?)
    {
        if let identifier = identifier as? Vehicle {
            bottomSheetController?.dismiss(animated: true, completion: nil)
        }
        else if let identifier = identifier as? String, identifier == "location" {
            bottomSheetController?.dismiss(animated: true, completion: {
                
                if (LocationManager.shared.isLocationDenied())
                {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                else
                {
                    LocationManager.shared.requestAlwaysLocation()
                }
            })
        }
    }
    
    func secondButtonPressed(identifier: Any?) {
        if let identifier = identifier as? Vehicle {
            self.vinculateBeaconToVehicle(identifier as! Vehicle)
        }
        else if let identifier = identifier as? String, identifier == "location" {
            bottomSheetController?.dismiss(animated: true, completion: {
                
                self.navigationController?.popViewController(animated: true)
                
            })
        }
    }
}
