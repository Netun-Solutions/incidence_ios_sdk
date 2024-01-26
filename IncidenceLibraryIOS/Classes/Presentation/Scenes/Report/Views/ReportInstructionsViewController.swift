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
            return "incidence_key_one".localizedVoice()
        case .accept:
            return "incidence_key_accept".localizedVoice()
        case .cancelNumber:
            return "incidence_key_two".localizedVoice()
        case .cancel:
            return "incidence_key_cancel".localizedVoice()
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
        let bundle = Bundle(for: Self.self)
        let view = ReportInstructionsViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        view.vehicle = viewModel.vehicle
        view.user = viewModel.user
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
        if let insurance = IncidenceLibraryManager.shared.getInsurance(), let url = insurance.image {
            let imgURL = URL(string: url)
            insuraceImageView.kf.setImage(with: imgURL)
        }
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        if let insurance = IncidenceLibraryManager.shared.getInsurance(), let message = insurance.textIncidence {
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
        if IncidenceLibraryManager.shared.getInsurance() != nil {
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
        if let insurance = IncidenceLibraryManager.shared.getInsurance(), let message = insurance.textIncidence {
            array.append(message)
        } else {
            array.append("incidence_key_calling_grua_tip".localizedVoice())
        }
        
        array.append(contentsOf: ["incidence_key_incidence_tip_beacon".localizedVoice(),
                     "incidence_key_incidence_tip_lights".localizedVoice(),
                     "incidence_key_incidence_tip_vest".localizedVoice(),
                     "incidence_key_incidence_tip_exit_car".localizedVoice()])

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
    
    @objc override func backPressed(){
        navigationController?.popViewController(animated: true)
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
        super.backPressed()
        Core.shared.stopTimer()
        stopTimer()
    }
    
    
    
    private func onSuccessReport(incidence:Incidence)
    {
        //self.navigationController?.popToRootViewController(animated: false)
        super.backPressed()
        
        let response: IActionResponse = IActionResponse(status: true)
        self.viewModel.delegate.onResult(response: response)
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
        
        showHUD()
        
        if (LocationManager.shared.isLocationEnabled())
        {
            if let manual = Core.shared.manualAddressCoordinate
            {
                let location = CLLocation(latitude: manual.latitude, longitude: manual.longitude)
                reportLocation(location: location)
            }
            else if let location = LocationManager.shared.getCurrentLocation() {
                reportLocation(location: location)
            } else {
                reportLocation(location: nil)
            }
        }
        else
        {
            //showAlert(message: "activate_location_message".localized())
            reportLocation(location: nil)
        }
    }
    
    private func reportLocation(location: CLLocation?)
    {
        let incidenceType: IncidenceType = IncidenceType()
        incidenceType.externalId = String(self.viewModel.incidenceTypeId!)
        
        
        let incidence: Incidence = Incidence()
        incidence.incidenceType = incidenceType
        incidence.street = "";
        incidence.city = "";
        incidence.country = "";
        incidence.latitude = location != nil ? location!.coordinate.latitude : nil;
        incidence.longitude = location != nil ? location!.coordinate.longitude : nil;
        
        Api.shared.postIncidenceSdk(vehicle: vehicle!, user: user!, incidence: incidence, completion: { result in
            
            self.hideHUD()
            if (result.isSuccess())
            {
                if let data = result.getJSONString(key: "incidence") {
                    
                    print(data)
                    if let dataDic = StringUtils.convertToDictionary(text: data) {
                        incidence.id = Int(dataDic["id"] as! Int)
                        incidence.externalIncidenceId = dataDic["externalIncidenceTypeId"] as? String
                    }
                }
                
                self.onSuccessReport(incidence: incidence)
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
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


