//
//  ReportAccidentViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import UIKit
import CoreLocation
import AVFoundation

enum ReportAccidentSpeechRecognizion: CaseIterable {
    case noInjuredNumber
    case noInjured
    case injuredNumber
    case injured
    case cancelNumber
    case cancel

    func getLocalizedText() -> String {
        switch self {
        case .noInjuredNumber:
            return "incidence_key_one".localizedVoice()
        case .noInjured:
            return "incidence_key_no_only_material_wounded".localizedVoice()
        case .injuredNumber:
            return "incidence_key_two".localizedVoice()
        case .injured:
            return "incidence_key_accident_with_wounded".localizedVoice()
        case .cancelNumber:
            return "incidence_key_three".localizedVoice()
        case .cancel:
            return "incidence_key_cancel".localizedVoice()
        }
    }
}

class ReportAccidentViewController: ReportBaseViewController, StoryboardInstantiable, SpeechReconizable {
    
    var voiceDialogs: [String] {
        get {
            var array = ["incidence_key_ask_wounded".localizedVoice()]
            array.append(contentsOf: speechRecognizion)
            return array
        }
    }
    var speechRecognizion: [String] = ReportAccidentSpeechRecognizion.allCases.map({ $0.getLocalizedText() })
    
    var speechSynthesizer: AVSpeechSynthesizer!
    var speechRecognizer: SpeechRecognizer!
    
    static let ACCIDENT_TYPE_ONLY_MATERIAL = "12"
    static let ACCIDENT_TYPE_WOUNDED = "13"
    
    static let storyboardFileName = "ReportScene"
    private var viewModel: ReportAccidentViewModel! { get { return baseViewModel as? ReportAccidentViewModel }}

    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var noInjuredButton: MenuView!
    @IBOutlet weak var injuredButton: MenuView!
    @IBOutlet weak var cancelButton: TextButton!
    var speechButton: UIBarButtonItem?
    var setenceFinished = true
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportAccidentViewModel) -> ReportAccidentViewController {
        let bundle = Bundle(for: Self.self)
        let view = ReportAccidentViewController.instantiateViewController(bundle)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSpeechRecognizion()
    }
    
  
    override func setUpUI() {
        super.setUpUI()
        
        descriptionLabel.text = viewModel.descriptionText
        
        noInjuredButton.configure(text: viewModel.noInjuredButtonText)
        injuredButton.configure(text: viewModel.injuredText, color: .red)
        
        var disable = true
        if IncidenceLibraryManager.shared.getInsurance() != nil {
            disable = false
        }
        
        if (disable)
        {
            noInjuredButton.alpha = 0.5
            injuredButton.alpha = 0.5
        }
        else
        {
            noInjuredButton.onTap { [weak self] in
                self?.noInjuredButtonPressed()
            }
            injuredButton.onTap { [weak self] in
                self?.injuredButtonPressed()
            }
        }

        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)
        setUpNavigation()
    }
    
    private func noInjuredButtonPressed() {
        if let insurance = IncidenceLibraryManager.shared.getInsurance() {
            LocationManager.shared.isLocationOutSpain { outSpain in
                if (outSpain)
                {
                    if let phone = insurance.internationaPhone {
                        self.reportIncidence(idIncidence: ReportAccidentViewController.ACCIDENT_TYPE_ONLY_MATERIAL, phone: phone)
                    }
                }
                else
                {
                    LocationManager.shared.isLocationOutSpain { outSpain in
                                        if (outSpain)
                                        {
                                            if let phone = insurance.internationaPhone {
                                                self.reportIncidence(idIncidence: ReportAccidentViewController.ACCIDENT_TYPE_ONLY_MATERIAL, phone: phone)
                                            }
                                        }
                                        else
                                        {
                                            if let phone = insurance.phone {
                                                self.reportIncidence(idIncidence: ReportAccidentViewController.ACCIDENT_TYPE_ONLY_MATERIAL, phone: phone)
                                            }
                                        }
                                    }
                    
                }
            }
            
            
        } else {
            self.showAlert(message: "incidence_key_alert_must_add_insurance".localized())
        }
    }
    
    private func injuredButtonPressed() {
        self.reportIncidence(idIncidence: ReportAccidentViewController.ACCIDENT_TYPE_WOUNDED, phone: Constants.PHONE_EMERGENCY)
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
    
    @IBAction func cancelButtonPressed(_ sender: Any?) {
        super.backPressed()
        Core.shared.stopTimer()
        stopTimer()
    }
    
    private func reportIncidence(idIncidence: String, phone: String) {
        
        Core.shared.stopTimer()
        stopTimer()

        showHUD()
        
        if (LocationManager.shared.isLocationEnabled())
        {
            if let manual = Core.shared.manualAddressCoordinate
            {
                let location = CLLocation(latitude: manual.latitude, longitude: manual.longitude)
                reportLocation(idIncidence: idIncidence, phone: phone, location: location)
            }
            else if let location = LocationManager.shared.getCurrentLocation() {
                reportLocation(idIncidence: idIncidence, phone: phone, location: location)
            } else {
                reportLocation(idIncidence: idIncidence, phone: phone, location: nil)
            }
        }
        else
        {
            //showAlert(message: "incidence_key_activate_location_message".localized())
            reportLocation(idIncidence: idIncidence, phone: phone, location: nil)
        }
    }
    
    private func reportLocation(idIncidence: String, phone: String, location: CLLocation?)
    {        
        let incidenceType: IncidenceType = IncidenceType()
        incidenceType.externalId = idIncidence
        
        
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
                        //incidence.id = Int(dataDic["id"] as! Int)
                        incidence.externalIncidenceId = dataDic["externalIncidenceTypeId"] as? String
                    }
                }
                
                //self.onSuccessReport(incidence: incidence)
                
                super.backPressed()
                
                var response: IActionResponse = IActionResponse(status: true)
                response.data = incidence
                self.viewModel.delegate.onResult(response: response)
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
        if let action = ReportAccidentSpeechRecognizion.allCases.first(where: {$0.getLocalizedText() == text}) {
            stopSpeechRecognizion()
            switch action {
            case .noInjuredNumber,
                    .noInjured:
                noInjuredButtonPressed()
            case .injuredNumber,
                    .injured:
                injuredButtonPressed()
            case .cancelNumber,
                    .cancel:
                cancelButtonPressed(nil)
            }
            setenceFinished = true
        } else {
            setenceFinished = false
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

