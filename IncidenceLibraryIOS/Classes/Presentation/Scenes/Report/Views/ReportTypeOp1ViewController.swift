//
//  ReportTypeOp1ViewController.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 4/3/24.
//

import UIKit
import AVFoundation

enum ReportTypeOp1SpeechRecognizion: CaseIterable {
    case accidentNumber
    case accident
    case faultNumber
    case fault
    case cancelNumber
    case cancel

    func getLocalizedText() -> String {
        switch self {
        case .accidentNumber:
            return "incidence_key_one".localizedVoice()
        case .accident:
            return "incidence_key_accident".localizedVoice()
        case .faultNumber:
            return "incidence_key_two".localizedVoice()
        case .fault:
            return "incidence_key_fault".localizedVoice()
        case .cancelNumber:
            return "incidence_key_three".localizedVoice()
        case .cancel:
            return "incidence_key_cancel".localizedVoice()
        }
    }
}

public class ReportTypeOp1ViewController: ReportBaseViewController, StoryboardInstantiable, SpeechReconizable {
    public var voiceDialogs: [String] {
        get {
            let desc = String(format:"incidence_key_report_ask_what_descrip".localizedVoice(), 3, 0);
            var array = ["incidence_key_report_ask_what2".localizedVoice(),
                         desc]
            array.append(contentsOf: speechRecognizion)
            return array
        }
    }
    public var speechRecognizion: [String] = ReportTypeOp1SpeechRecognizion.allCases.map({ $0.getLocalizedText() })
    
    public var speechSynthesizer: AVSpeechSynthesizer!
    public var speechRecognizer: SpeechRecognizer!
    
    public static var storyboardFileName = "ReportScene"
    private var viewModel: ReportTypeViewModel! { get { return baseViewModel as? ReportTypeViewModel }}

    @IBOutlet weak var incidenceImageView: UIImageView!
    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var breakdownButton: PrimaryButton!
    @IBOutlet weak var accidentButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    var speechButton: UIBarButtonItem?
    var setenceFinished = true
    
    // MARK: - Lifecycle
    public static func create(with viewModel: ReportTypeViewModel) -> ReportTypeOp1ViewController {
        let bundle = Bundle(for: Self.self)
                            
        let view = ReportTypeOp1ViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        view.vehicle = viewModel.vehicle
        view.user = viewModel.user
        view.openFromNotification = viewModel.openFromNotification
        
        return view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        speechReconizableDelegate = self
    }
    
    @objc func timerUpdated(_ notification: Notification) {
        if Core.shared.secondsRemaining > 0 {
            let seconds: Int = Core.shared.secondsRemaining  % 60
            let minutes: Int = (Core.shared.secondsRemaining  / 60) % 60
            
            self.descriptionLabel.text = String(format:self.viewModel.descriptionText, minutes, seconds)
        } else {
            self.descriptionLabel.text = String(format:self.viewModel.descriptionText, 3, 0)
        }
    }
        
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EventNotification.addObserver(self, code: .INCIDENCE_TIMER_CHANGE, selector: #selector(timerUpdated))
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSpeech()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopSpeechRecognizion()
        
        //Core.shared.stopTimer()
    }
    
    
    @objc override func backPressed(){
        Core.shared.stopTimer()
        stopTimer()
        super.backPressed()
    }
    
    
    override func setUpUI() {
        super.setUpUI()
        //incidenceImageView.layer.shadowColor = UIColor.app(.incidencePrimary)?.cgColor
        //incidenceImageView.layer.shadowOffset = CGSize(width: 0.0, height: 16)
        //incidenceImageView.layer.shadowOpacity = 0.16
        //incidenceImageView.layer.shadowRadius = 32
        //incidenceImageView.layer.masksToBounds = false
        
        titleLabel.text = viewModel.titleText2
        titleLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        self.descriptionLabel.text = String(format:self.viewModel.descriptionText, 3, 0)
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        accidentButton.setTitle(viewModel.breakdownButtonText, for: .normal)
        breakdownButton.setTitle(viewModel.accidentButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)
        
        //self.tintColor = invertedColors ? UIColor.app(.incidencePrimary) : UIColor.app(.white)
        //self.setTitleColor(invertedColors ? UIColor.app(.incidencePrimary) : UIColor.app(.white), for: .normal)
        
        var color : UIColor? = IncidenceLibraryManager.shared.getTextColor();
        if (color == nil) {
            color = UIColor.app(.black600) ?? .black
        }
        
        breakdownButton.setTitleColor(color, for: .normal)
        accidentButton.setTitleColor(color, for: .normal)
        
        accidentButton.backgroundColor = .clear
        accidentButton.layer.cornerRadius = 5
        accidentButton.layer.borderWidth = 1
        accidentButton.layer.borderColor = color?.cgColor
        
        breakdownButton.backgroundColor = .clear
        breakdownButton.layer.cornerRadius = 5
        breakdownButton.layer.borderWidth = 1
        breakdownButton.layer.borderColor = color?.cgColor
        
        
        Core.shared.startTimer()
        setUpNavigation()
        
        view.addSubview(alertView)
        //view.superview?.addSubview(alertView)
        //self.navigationController?.view.addSubview(alertView)
    }
    
    private func setUpNavigation() {
        speechButton = UIBarButtonItem(image: UIImage.app( "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(speechPressed))
        speechButton!.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = speechButton!
    }
    
    @objc private func speechPressed() {
        speechButtonPressed()
    }
    
    @IBAction func breakdownButtonPressed(_ sender: Any?) {
        
        //        let vm = ReportExpiredInsuranceViewModel()
        //        let vc = ReportExpiredInsuranceViewController.create(with: vm)
        //        navigationController?.pushViewController(vc, animated: true)
        
        /*if let tm = timer {
         tm.invalidate()
         }*/
        
        stopTimer()
        
        guard let incidencesTypesAll = IncidenceLibraryManager.shared.incidencesTypes else { return }
        guard let incidencesTypes: [IncidenceType] = Core.shared.getIncidencesTypes(parent: 2, incidences: incidencesTypesAll) else { return }
        
        if (!self.viewModel.flowComplete || incidencesTypes.count == 0) {
            reportIncidence(idIncidence: "2")
        } else {
            let vm = ReportBreakdownTypeViewModel(incidenceTypeList: incidencesTypes, vehicle: viewModel.vehicle, user: viewModel.user, delegate: viewModel.delegate, openFromNotification: self.viewModel.openFromNotification)
            vm.vehicle = viewModel.vehicle
            let vc = ReportBreakdownTypeViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func accidentButtonPressed(_ sender: Any?) {
        //Core.shared.stopTimer()
        stopTimer()
        /*
        if (!self.viewModel.flowComplete) {
            reportIncidence(idIncidence: "12")
        } else {
            let vm = ReportAccidentViewModel(vehicle: viewModel.vehicle, user: viewModel.user, delegate: viewModel.delegate, openFromNotification: self.viewModel.openFromNotification)
            let vc = ReportAccidentViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
        */
        guard let incidencesTypesAll = IncidenceLibraryManager.shared.incidencesTypes else { return }
        guard let incidencesTypes: [IncidenceType] = Core.shared.getIncidencesTypes(parent: 1, incidences: incidencesTypesAll) else { return }
        
        if (incidencesTypes.count == 0) {
            reportIncidence(idIncidence: "1")
        } else {
            let vm = ReportAccidentViewModel(vehicle: viewModel.vehicle, user: viewModel.user, delegate: viewModel.delegate, openFromNotification: self.viewModel.openFromNotification)
            let vc = ReportAccidentViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func reportIncidence(idIncidence: String) {
        
        Core.shared.stopTimer()
        stopTimer()

        showHUD()
        
        let incidenceType: IncidenceType = IncidenceType()
        incidenceType.externalId = idIncidence
        
        
        let incidence: Incidence = Incidence()
        incidence.incidenceType = incidenceType
        incidence.street = "";
        incidence.city = "";
        incidence.country = "";
        incidence.latitude = nil;
        incidence.longitude = nil;
        
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
                
                //self.navigationController?.popToRootViewController(animated: false)
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
    
    @IBAction func cancelButtonPressed(_ sender: Any?) {
        Core.shared.stopTimer()
        stopTimer()
        backPressed()
    }
    
    public func updateSpeechButton() {
        let image = UIImage.app( SpeechRecognizer.isEnabled ? "ic_nav_micro_on" : "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal)
        speechButton?.image = image
    }
    
    public func recognizedSpeech(text: String) {
        stopTimer()
        if let action = ReportTypeOp1SpeechRecognizion.allCases.first(where: {$0.getLocalizedText() == text}) {
            stopSpeechRecognizion()
            switch action {
            case .faultNumber,
                 .fault:
                breakdownButtonPressed(nil)
            case .accidentNumber,
                 .accident:
                accidentButtonPressed(nil)
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
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (!timeFinished) {
            startSpeechRecognizion()
            updateSpeechButton()
            updateAlertView()
            startTimer()
        }
    }
}

