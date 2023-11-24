//
//  ReportInstructionsViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import UIKit
import Kingfisher
import CoreLocation
import AVFoundation


enum ReportInstructionsViewSpeechRecognizion: CaseIterable {
    case acceptNumber
    case accept
    case cancelNumber
    case cancel

    func getLocalizedText() -> String {
        switch self {
        case .acceptNumber:
            return "one".localizedVoice()
        case .accept:
            return "accept".localizedVoice()
        case .cancelNumber:
            return "two".localizedVoice()
        case .cancel:
            return "cancel".localizedVoice()
        }
    }
}


class ReportInstructionsViewController: ReportBaseViewController, StoryboardInstantiable, SpeechReconizable {
    
    var voiceDialogs: [String] = []
    var speechRecognizion: [String] = ReportInstructionsViewSpeechRecognizion.allCases.map({ $0.getLocalizedText() })
    
    var speechSynthesizer: AVSpeechSynthesizer!
    var speechRecognizer: SpeechRecognizer!
    var setenceFinished = false

    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportInstructionsViewModel! { get { return baseViewModel as? ReportInstructionsViewModel }}

    @IBOutlet weak var insuraceImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var instructionsContainerView: UIView!
    @IBOutlet weak var beaconImageView: UIImageView!
    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var lightsImageView: UIImageView!
    @IBOutlet weak var lightsLabel: UILabel!
    @IBOutlet weak var chalecoImageView: UIImageView!
    @IBOutlet weak var chalecoLabel: UILabel!
    @IBOutlet weak var outImageView: UIImageView!
    @IBOutlet weak var outLabel: UILabel!
    
    @IBOutlet weak var cancelButton: TextButton!
    @IBOutlet weak var acceptButton: PrimaryButton!
    var speechButton: UIBarButtonItem?
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportInstructionsViewModel) -> ReportInstructionsViewController {
        let view = ReportInstructionsViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        view.vehicle = viewModel.vehicle
        view.openFromNotification = viewModel.openFromNotification
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechReconizableDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSpeech()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppNavigation.setupNavigationApperance(navigationController!, with: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSpeechRecognizion()
        AppNavigation.setupNavigationApperance(navigationController!, with: .regular)
    }
 
    override func setUpUI() {
        super.setUpUI()
        insuraceImageView.layer.cornerRadius = 36
        insuraceImageView.layer.masksToBounds = true
        if let vehicle = viewModel.vehicle, let insurance = vehicle.insurance, let url = insurance.image {
            let imgURL = URL(string: url)
            insuraceImageView.kf.setImage(with: imgURL)
        }
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        if let vehicle = viewModel.vehicle, let insurance = vehicle.insurance, let message = insurance.textIncidence {
            descriptionLabel.text = message
        }
        
        instructionsContainerView.backgroundColor = UIColor.app(.incidence300b)
        instructionsContainerView.layer.cornerRadius = 8
        instructionsContainerView.layer.masksToBounds = true
        
        beaconImageView.image = viewModel.balizaImage
        beaconImageView.tintColor = UIColor.app(.incidence600)
        beaconLabel.text = viewModel.balizaText
        beaconLabel.textColor = UIColor.app(.incidence600)
        beaconLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        lightsImageView.image = viewModel.lightImage
        lightsImageView.tintColor = UIColor.app(.incidence600)
        lightsLabel.text = viewModel.lightText
        lightsLabel.textColor = UIColor.app(.incidence600)
        lightsLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        chalecoImageView.image = viewModel.chalecoImage
        chalecoImageView.tintColor = UIColor.app(.incidence600)
        chalecoLabel.text = viewModel.chalecoText
        chalecoLabel.textColor = UIColor.app(.incidence600)
        chalecoLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        outImageView.image = viewModel.outImage
        outImageView.tintColor = UIColor.app(.incidence600)
        outLabel.text = viewModel.outText
        outLabel.textColor = UIColor.app(.incidence600)
        outLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        acceptButton.setTitle(viewModel.acceptButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)
        
        var disable = true
        if let vehicle = viewModel.vehicle, let insurance = vehicle.insurance {
            disable = false
        }
        if (disable) {
            acceptButton.isEnabled = false
        }
        
        setUpNavigation()
        setUpCarsVoiceRecognizer()
    }
    
    func setUpCarsVoiceRecognizer() {
        var array = [String]()
        if let vehicle = viewModel.vehicle, let insurance = vehicle.insurance, let message = insurance.textIncidence {
            array.append(message)
        } else {
            array.append("calling_grua_tip".localizedVoice())
        }
        
        array.append(contentsOf: ["incidence_tip_beacon".localizedVoice(),
                     "incidence_tip_lights".localizedVoice(),
                     "incidence_tip_vest".localizedVoice(),
                     "incidence_tip_exit_car".localizedVoice()])

        array.append(contentsOf: speechRecognizion)
        
        voiceDialogs = array
    }
    
    private func setUpNavigation() {
        speechButton = UIBarButtonItem(image: UIImage.app( "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(speechPressed))
        speechButton!.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = speechButton!
    }
    
    @objc private func speechPressed() {
        speechButtonPressed()
    }
 
    @IBAction func acceptButtonPressed(_ sender: Any?) {
        /*
        let vm = ReportMapViewModel()
        let vc = ReportMapViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
        */
        
        stopSpeechRecognizion()
        if (acceptButton.isEnabled) {
            reportIncidence()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any?) {
        navigationController?.popToRootViewController(animated: true)
        Core.shared.stopTimer()
        stopTimer()
    }
    
    
    
    private func onSuccessReport(incidence:Incidence)
    {
        if let openApp = incidence.openApp
        {
            EventNotification.post(code: .INCIDENCE_REPORTED)
            
            Core.shared.startNewApp(appScheme: openApp.iosUniversalLink ?? "")
            self.navigationController?.popToRootViewController(animated: true)
        }
        else if let asitur = incidence.asitur {
         
            EventNotification.post(code: .INCIDENCE_REPORTED)
            self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            //llamamos a la aseguradora
            LocationManager.shared.isLocationOutSpain { outSpain in
                
                var phoneNumber = self.viewModel.vehicle?.insurance?.phone ?? ""
                if (outSpain)
                {
                    phoneNumber = self.viewModel.vehicle?.insurance?.internationaPhone ?? ""
                }
                
                
                if let url = URL(string: "tel://\(phoneNumber)")
                {
                    let application = UIApplication.shared
                    if application.canOpenURL(url) {
                        
                        Core.shared.appStateBlocked = true
                        let selector = #selector(self.appDidBecomeActive)
                        let notifName = UIApplication.didBecomeActiveNotification
                        NotificationCenter.default.addObserver(self, selector: selector, name: notifName, object: nil)

                        
                        application.open(url, options: [:], completionHandler: { isSuccess in
                            // print here does your handler open/close : check 'isSuccess'
                        })
                        
                        EventNotification.post(code: .INCIDENCE_REPORTED)
                    }
                    else
                    {
                        EventNotification.post(code: .INCIDENCE_REPORTED)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
                /*
                let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let firstAction: UIAlertAction = UIAlertAction(title: "call_to".localized() + phoneNumber , style: .default) { action -> Void in
                    Core.shared.callNumber(phoneNumber: phoneNumber, autoCall: true)
                    self.navigationController?.popToRootViewController(animated: true)
                }
                let image = UIImage.app( "PhoneBlack")?.withRenderingMode(.alwaysOriginal)
                firstAction.setValue(image, forKey: "image")

                let cancelAction: UIAlertAction = UIAlertAction(title: "cancel".localized(), style: .destructive) { action -> Void in
                    
                    self.showHUD()
                    Api.shared.closeIncidence(incidenceId: incidence.id!, completion: { result in
                        self.hideHUD()
                        if (result.isSuccess())
                        {
                            incidence.close()
                            
                            EventNotification.post(code: .INCIDENCE_REPORTED)
                        }
                        else
                        {
                            self.onBadResponse(result: result)
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                   })
                }
                actionSheetController.addAction(firstAction)
                actionSheetController.addAction(cancelAction)

                self.present(actionSheetController, animated: true, completion: nil)
                */
            }
        }
    }
    
    @objc func appDidBecomeActive()
    {
        NotificationCenter.default.removeObserver(self)
        
        if (Core.shared.appStateBlocked)
        {
            Core.shared.appStateBlocked = false
            
            self.navigationController?.popToRootViewController(animated: true)
            Core.shared.onAppBecomeActive()
        }
    }
    
    private func reportIncidence()
    {
        Core.shared.stopTimer()
        stopTimer()
        
        if (LocationManager.shared.isLocationEnabled())
        {
            showHUD()
            
            if let manual = Core.shared.manualAddressCoordinate
            {
                let location = CLLocation(latitude: manual.latitude, longitude: manual.longitude)
                reportLocation(location: location)
            }
            else if let location = LocationManager.shared.getCurrentLocation() {
                reportLocation(location: location)
            }
        }
        else
        {
            showAlert(message: "activate_location_message".localized())
        }
    }
    
    private func reportLocation(location: CLLocation)
    {
        /*
        MapBoxManager.searchAddress(location: location.coordinate) { address in
            
            var street = ""
            var city = ""
            var country = ""
            let licensePlate = self.viewModel.vehicle?.licensePlate
            
            if (address.city != nil) {
                city = address.city!
            }
            if (address.country != nil) {
                country = address.country!
            }
            
            var str2 = ""
            if (address.street != nil) {
                str2 = address.street!
            }
            if (address.streetNumber != nil) {
                if (str2.count == 0) {
                    str2 = address.streetNumber!
                } else {
                    str2 = str2 + ", " + address.streetNumber!
                }
            }
            street = str2
            
            Api.shared.reportIncidence(licensePlate: licensePlate!, incidenceTypeId: String(self.viewModel.incidenceTypeId!), street: street, city: city, country: country, location: location, openFromNotification: self.viewModel.openFromNotification, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    let incidence:Incidence? = result.get(key: "incidence")
                    self.onSuccessReport(incidence: incidence!)
                }
                else
                {
                    self.onBadResponse(result: result)
                }
           })
        }
        */
    }
    

    func updateSpeechButton() {
        let image = UIImage.app( SpeechRecognizer.isEnabled ? "ic_nav_micro_on" : "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal)
        speechButton?.image = image
    }
    
    func recognizedSpeech(text: String) {
        stopTimer()
        setenceFinished = false
        if let action = ReportInstructionsViewSpeechRecognizion.allCases.first(where: {$0.getLocalizedText() == text}) {
            stopSpeechRecognizion()
            switch action {
            case .acceptNumber, .accept:
                acceptButtonPressed(nil)
            case .cancelNumber, .cancel:
                cancelButtonPressed(nil)
            }
            setenceFinished = true
        }
        
        if !(setenceFinished) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [weak self] in
                if !(self?.setenceFinished ?? true) {
                    self?.notUnderstandVoice()
                }
            })
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (!timeFinished) {
            startSpeechRecognizion()
            updateSpeechButton()
            updateAlertView()
            startTimer()
        }
    }
}


