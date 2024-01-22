//
//  RegistrationBeaconSelectTypeViewController.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 4/5/22.
//

import Foundation
import AVFoundation
import UIKit

protocol RegistrationBeaconSelectTypeDelegate: AnyObject {
    func continueButtonPressed(identifier: Any?)
}

class RegistrationBeaconSelectTypeViewController: IABaseViewController, StoryboardInstantiable, AVCaptureMetadataOutputObjectsDelegate, ImeiPopUpModalDelegate {
    
    static var storyboardFileName = "RegistrationScene"
    
    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var skipButton: UIButton!
    
    var bottomSheetController: BottomSheetViewController?
    
    //qr
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var selectedBeacon:Beacon!
    
    var showingSmart = false
    var showingIoT = true
    var hideIOT = false

    private var viewModel: RegistrationBeaconViewModel! { get { return baseViewModel as? RegistrationBeaconViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationBeaconViewModel) -> RegistrationBeaconSelectTypeViewController {
        let bundle = Bundle(for: Self.self)
                            
        let view = RegistrationBeaconSelectTypeViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        helperLabel.text = "select_beacon_type".localized()
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
     
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.estimatedRowHeight = BeaconTypeCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BeaconTypeCell.self, forCellReuseIdentifier: BeaconTypeCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        skipButton.setTitle(viewModel.discardButtonText, for: .normal)
    
        if(viewModel.fromBeacon==true){
            self.skipButton.isHidden = true
        }else{
            self.skipButton.isHidden = false
        }
      

        
        let showIOTNumber:Int = Prefs.loadInt(key: Constants.KEY_CONFIG_SHOW_IOT) ?? 1
        if (showIOTNumber == 0) {
            hideIOT = true;
        }
        
        IncidenceLibraryManager.shared.setViewBackground(view: self.view)
        IncidenceLibraryManager.shared.setTextColor(view: helperLabel)
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)

    }
    override func loadData() {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession != nil && captureSession?.isRunning == true) {
            dismissCamera()
        }
    }
    
    func openScan()
    {
        tableView.isUserInteractionEnabled = false
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        var navigationHeigth = CGFloat(44)
        var topPadding = 0.0
        
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { failCaptureQR(); return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failCaptureQR()
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failCaptureQR()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.dataMatrix, .qr]
        } else {
            failCaptureQR()
            return
        }
        
        
        
        view.addSubview(viewBlack)
        viewBlack.bottomAnchor.constraint(equalTo: view!.bottomAnchor).isActive = true
        viewBlack.leftAnchor.constraint(equalTo: view!.leftAnchor).isActive = true
        viewBlack.rightAnchor.constraint(equalTo: view!.rightAnchor).isActive = true
        viewBlack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(closeButton)
        if #available(iOS 11.0, *) {
            closeButton.bottomAnchor.constraint(equalTo: view!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            closeButton.bottomAnchor.constraint(equalTo: view!.bottomAnchor).isActive = true
        }
        closeButton.leftAnchor.constraint(equalTo: view!.leftAnchor).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view!.rightAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let window = view.window!
        //let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        //if let window:UIWindow = mySceneDelegate.window {
            window.addSubview(scanView)
            
            var bottomPadding = 0.0
            if #available(iOS 11.0, *) {
                topPadding = window.safeAreaInsets.top
                bottomPadding = window.safeAreaInsets.bottom
            }
            
            scanView.frame = CGRect.init(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height - topPadding - bottomPadding)
        //}
        
        /*
        let mySceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        if let window:UIWindow = mySceneDelegate.window {
            window.addSubview(scanView)
            
            var bottomPadding = 0.0
            if #available(iOS 11.0, *) {
                topPadding = window.safeAreaInsets.top
                bottomPadding = window.safeAreaInsets.bottom
            }
            
            scanView.frame = CGRect.init(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height - topPadding - bottomPadding)
        }
        */

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scanView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scanView.layer.addSublayer(previewLayer)
        
        scanView.addSubview(qrCodeFrameView)
        let overlayWidth = scanView.frame.width * 80 * 0.01
        let posX = scanView.frame.width/2 - overlayWidth/2
        //let posY = (scanView.frame.height - 50 - navigationHeigth - topPadding)/2 - overlayWidth/2
        let posY = (scanView.frame.height - 50)/2 - overlayWidth/2
        qrCodeFrameView.frame = CGRect.init(x: posX, y: posY, width: overlayWidth, height: overlayWidth)
  
        scanView.addSubview(cameraTextInfo)
        
        cameraTextInfo.topAnchor.constraint(equalTo: view!.topAnchor, constant: (topPadding+navigationHeigth)).isActive = true
        cameraTextInfo.leftAnchor.constraint(equalTo: view!.leftAnchor).isActive = true
        cameraTextInfo.rightAnchor.constraint(equalTo: view!.rightAnchor).isActive = true
        cameraTextInfo.heightAnchor.constraint(equalToConstant: posY/2).isActive = true
   
        view.addSubview(cameraTitleButton)
        scanView.addSubview(cameraTitleLabel)
        
        cameraTitleLabel.topAnchor.constraint(equalTo: view!.topAnchor, constant: topPadding).isActive = true
        cameraTitleLabel.leftAnchor.constraint(equalTo: view!.leftAnchor, constant: 35).isActive = true
        cameraTitleLabel.heightAnchor.constraint(equalToConstant: navigationHeigth).isActive = true
        
        cameraTitleButton.topAnchor.constraint(equalTo: view!.topAnchor, constant: topPadding).isActive = true
        cameraTitleButton.leftAnchor.constraint(equalTo: view!.leftAnchor).isActive = true
        cameraTitleButton.rightAnchor.constraint(equalTo: view!.rightAnchor).isActive = true
        cameraTitleButton.heightAnchor.constraint(equalToConstant: navigationHeigth).isActive = true
        
        captureSession.startRunning()
    }
    
    func failCaptureQR() {
        //let alertController = UIAlertController(title: "app_selector_error_fail_capture_title".coreLocalizabled, message:  "app_selector_error_fail_capture_description".coreLocalizabled, preferredStyle: .alert)
        //alertController.addAction(UIAlertAction(title: "ws_response_default_ok_button".coreLocalizabled, style: .default))
        //present(alertController, animated: true, completion: nil)
        captureSession = nil
    }
    
    func validateBeacon() {
        showHUD()
        Api.shared.addBeaconSdk(beacon: self.selectedBeacon, vehicle: viewModel.vehicle, user: viewModel.user, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let token:String? = result.getString(key: "token")
                Prefs.saveString(key: Constants.KEY_USER_TOKEN, value: token!)
                
                let userResponse = result.get(key: "user") ?? User()
                userResponse.externalUserId = self.viewModel.user.externalUserId;
                
                if let data = try? JSONEncoder().encode(userResponse) {
                    
                    if let jsonStr = String(data: data, encoding: String.Encoding.utf8) {
                        Prefs.saveString(key: Constants.KEY_USER, value: jsonStr)
                    }
                }
                
                self.selectedBeacon.name = self.viewModel.vehicle.getName();
                self.viewModel.vehicle.beacon = self.selectedBeacon;
                //self.viewModel.vehicle.id=self.viewModel.vehicle.externalVehicleId;

                Core.shared.saveVehicle(vehicle: self.viewModel.vehicle)
                
                var beaconTypeId: Int = 2;
                let beaconData = result.get(key: "data") ?? BeaconData()
                if let beacons = beaconData.beacon {
                    if (beacons.count > 0) {
                        let beacon = beacons[0];
                        beaconTypeId = beacon.beaconType?.id ?? 2;
                    }
                }
                
                //Show beacon added view
                let vm = RegistrationSuccessBeaconViewModel(origin: .addBeacon, isIoT: false, beaconTypeId: beaconTypeId, delegate: self.viewModel.delegate)
                let viewController = RegistrationSuccessBeaconViewController.create(with: vm)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            //print("Value QR: ", stringValue)
            //showAlert(message: stringValue)
            dismissCamera()
            
            
            selectedBeacon = Beacon()
            selectedBeacon.iot = stringValue
            selectedBeacon.uuid = stringValue
            
            validateBeacon();
            
            //textField.text = stringValue
            //sendButtonPressed()
            
        }

        previewLayer.removeFromSuperlayer()
    }
    
    @objc func dismissCamera() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        viewBlack.removeFromSuperview()
        closeButton.removeFromSuperview()
        captureSession.stopRunning()
        previewLayer.removeFromSuperlayer()
        qrCodeFrameView.removeFromSuperview()
        scanView.removeFromSuperview()
        cameraTitleButton.removeFromSuperview()
        
        tableView.isUserInteractionEnabled = true
    }
    
    
    lazy var scanView: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var qrCodeFrameView: UIView = {
        let button = UIView()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var viewBlack: UIView = {
        let button = UIView()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()

        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byClipping
        button.titleLabel?.minimumScaleFactor = 0.1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("button_close".localized(), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(dismissCamera), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cameraTextInfo : UILabel = {
        let label = UILabel()
        label.text = "qr_desc".localized()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = .red
        label.textAlignment = NSTextAlignment.center;
        
        return label
    }()
    
    lazy var cameraTitleLabel : UILabel = {
        let attachment = NSTextAttachment()
        let image = UIImage.app( "Direction=Left")?.withRenderingMode(.alwaysTemplate)
        attachment.image = image;
        attachment.bounds = CGRect(x: 0, y: -7, width: attachment.image!.size.width, height: attachment.image!.size.height)

        let attachmentString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attachmentString.append(NSAttributedString(string: "create_account_step3".localized()))
        
        let label = UILabel()
        label.attributedText = attachmentString
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = .red
        label.textAlignment = NSTextAlignment.left;
        label.sizeToFit();
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    @objc func goBackView() {
        dismissCamera();
    }
    
    lazy var cameraTitleButton: UIButton = {
        let button = UIButton()

        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byClipping
        button.titleLabel?.minimumScaleFactor = 0.1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("create_account_step3".localized(), for: .normal)
        //button.backgroundColor = .red
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(goBackView), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        Api.shared.addBeacon(beacon: selectedBeacon, vehicle: vehicle, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                //vehicle.beacon = result.get(key: "vehicleBeacon")
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
                
                let beacon: Beacon? = result.get(key: "beacon")
                
                //Show beacon added view
                let beaconTypeId: Int = beacon?.beaconType?.id ?? 2;
                let vm = RegistrationSuccessBeaconViewModel(origin: .addBeacon, isIoT: (vehicle.beacon?.iot != nil), beaconTypeId: beaconTypeId, delegate: self.viewModel.delegate)
                
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

extension RegistrationBeaconSelectTypeViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?)
    {
        if let identifier = identifier as? Vehicle {
            bottomSheetController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func secondButtonPressed(identifier: Any?) {
        if let identifier = identifier as? Vehicle {
            self.vinculateBeaconToVehicle(identifier as! Vehicle)
        }
    }
}

extension RegistrationBeaconSelectTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalRows = 1;
        
        if (showingSmart) { totalRows+=1 }
        if (showingIoT) { totalRows+=2 }
        
        return totalRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeaconTypeCell.reuseIdentifier, for: indexPath) as? BeaconTypeCell else {
            assertionFailure("Cannot dequeue reusable cell \(BeaconTypeCell.self) with reuseIdentifier: \(BeaconTypeCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        var indexRowIoT = 0;
        var indexRowIoTAmp = showingIoT ? 1 : -1;
        var indexRowIoTAmp2 = showingIoT ? 2 : -1;
        if (indexPath.row == indexRowIoT && !hideIOT)
        {
            cell.configure(with: "dispositivo_red", title: "select_beacon_type_iot".localized(), identifier: 1, delegate: self, rightIcon: showingIoT ? .arrowUp : .arrowDown, tooltipText:nil)
        }
        else if (indexPath.row == indexRowIoTAmp && !hideIOT)
        {
            cell.configure(with: "icon_qr", title: "select_beacon_type_qr".localized(), identifier: indexPath.row, delegate: nil, rightIcon: .info, tooltipText: "select_beacon_type_qr_info".localized())
        }
        else if (indexPath.row == indexRowIoTAmp2 && !hideIOT)
        {
            cell.configure(with: "icon_imei", title: "select_beacon_imei".localized(), identifier: indexPath.row, delegate: nil, rightIcon: .info, tooltipText: "select_beacon_imei_info".localized())
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var indexRowIoT = 0;
        var indexRowIoTAmp = showingIoT ? 1 : -1;
        var indexRowIoTAmp2 = showingIoT ? 2 : -1;
        
        if (indexPath.row == indexRowIoT)
        {
            showingIoT = !showingIoT
            tableView.reloadData()
        }
        else if (indexPath.row == indexRowIoTAmp)
        {
            AVCaptureDevice.requestAccess(for: .video) { success in
                  if success { // if request is granted (success is true)
                    DispatchQueue.main.async {
                        self.openScan()
                    }
                  } else { // if request is denied (success is false)
                      
                      DispatchQueue.main.async {
                          // Create Alert
                            let alert = UIAlertController(title: "app_name".localized(), message: "alert_need_camera_permission_qr".localized(), preferredStyle: .alert)

                          // Add "OK" Button to alert, pressing it will bring you to the settings app
                          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                              UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                          }))
                          // Show the alert with animation
                          self.present(alert, animated: true)
                      }
                    
                  }
            }
        }
        else if (indexPath.row == indexRowIoTAmp2)
        {
            ImeiPopUpModalViewController.present(
                        initialView: self,
                        delegate: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BeaconTypeCell.height
    }
    
    func didTapCancel() {
        self.dismiss(animated: false)
    }
    
    func didTapAccept(imei: String){
        self.dismiss(animated: false)
        
        selectedBeacon = Beacon()
        selectedBeacon.iot = imei
        selectedBeacon.uuid = imei
        
        validateBeacon();
    }

}


extension RegistrationBeaconSelectTypeViewController: RegistrationBeaconSelectTypeDelegate {
    func continueButtonPressed(identifier: Any?) {
        if let identifier = identifier as? Int, identifier == 1
        {
            showingIoT = !showingIoT
        } else if let identifier = identifier as? Int, identifier == 2
        {
            showingSmart = !showingSmart
        }
        
        tableView.reloadData()
    }
    
}
