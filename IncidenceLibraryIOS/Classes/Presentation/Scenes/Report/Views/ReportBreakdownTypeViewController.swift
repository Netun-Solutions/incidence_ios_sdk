//
//  ReportBreakdownTypeViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import UIKit
import AVFoundation

class ReportBreakdownTypeViewController: ReportBaseViewController, StoryboardInstantiable, SpeechReconizable {
    var voiceDialogs: [String] = []
    var speechRecognizion: [String] = []
    
    var speechSynthesizer: AVSpeechSynthesizer!
    var speechRecognizer: SpeechRecognizer!
    
    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportBreakdownTypeViewModel! { get { return baseViewModel as? ReportBreakdownTypeViewModel }}

    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cancelButton: TextButton!
    var speechButton: UIBarButtonItem?
    var setenceFinished = false
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportBreakdownTypeViewModel) -> ReportBreakdownTypeViewController {
        let bundle = Bundle(for: Self.self)
        let view = ReportBreakdownTypeViewController.instantiateViewController(bundle)
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
        
        descriptionLabel.text = viewModel.descriptionText
        
        for incideceType in viewModel.incidenceTypeList {
            let menuView = MenuView()
            menuView.anchor(heightConstant: 59)
            menuView.configure(text: incideceType.name)
            menuView.onTap {
                self.breakDownSelected(type: incideceType)
            }
            stackView.addArrangedSubview(menuView)
        }
        
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)
        
        setUpNavigation()
        setUpCarsVoiceRecognizer()
        
        view.addSubview(alertView)
    }
    
    func setUpCarsVoiceRecognizer() {
        voiceDialogs = [viewModel.descriptionTextVoice]
        
        var array = [String]()
        for (index, incidenceType) in viewModel.incidenceTypeList.enumerated() {
            if let number = NumbersRecognizion(rawValue: index+1) {
                array.append(number.getLocalizedText())
            }
            array.append(incidenceType.name)
        }
        if let number = NumbersRecognizion(rawValue: viewModel.incidenceTypeList.count+1)?.getLocalizedText() {
            array.append(number)
        }
        array.append("cancel".localizedVoice())
        
        speechRecognizion = array
        voiceDialogs.append(contentsOf: array)
    }
    private func setUpNavigation() {
        //let phoneButton = UIBarButtonItem(image: UIImage.app( "Phone"), style: .plain, target: self, action: #selector(phonePressed))
        //phoneButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        speechButton = UIBarButtonItem(image: UIImage.app( "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(speechPressed))
        speechButton!.imageInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 4)
        
        //navigationItem.rightBarButtonItems = [speechButton!, phoneButton]
        navigationItem.rightBarButtonItems = [speechButton!]
    }
    
    @objc override func backPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func speechPressed() {
        speechButtonPressed()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any?) {
        super.backPressed()
        Core.shared.stopTimer()
        stopTimer()
    }
    
    @objc private func phonePressed() {
        let phone = self.viewModel.vehicle.insurance?.phone
        Core.shared.callNumber(phoneNumber: phone!)
        stopTimer()
    }
    
    private func breakDownSelected(type: IncidenceType) {
        stopTimer()
        /*
        let vm = ReportInstructionsViewModel()
        vm.vehicle = self.viewModel.vehicle
        let vc = ReportInstructionsViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
        */
        
        guard let incidenceTypeId = type.id else { return }
        
        if let otherIncidencesTypes = Core.shared.getIncidencesTypes(parent: incidenceTypeId), !otherIncidencesTypes.isEmpty {
            let vm = ReportBreakdownTypeViewModel(incidenceTypeList: otherIncidencesTypes,
                                                  isChild: true,
                                                  vehicle: viewModel.vehicle, user: viewModel.user, delegate: viewModel.delegate, openFromNotification: self.viewModel.openFromNotification)
            let viewController = ReportBreakdownTypeViewController.create(with: vm)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {

            let vm = ReportInstructionsViewModel(vehicle: self.viewModel.vehicle, user: self.viewModel.user, delegate: viewModel.delegate, incidenceTypeId: incidenceTypeId, openFromNotification: self.viewModel.openFromNotification)
            let vc = ReportInstructionsViewController.create(with: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSpeechButton() {
        let image = UIImage.app( SpeechRecognizer.isEnabled ? "ic_nav_micro_on" : "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal)
        speechButton?.image = image
    }
    
    func recognizedSpeech(text: String) {
        stopTimer()
        setenceFinished = false
        if text == "cancel".localizedVoice() {
            cancelButtonPressed(nil)
            setenceFinished = true
        }
        
        if let number = NumbersRecognizion.allCases.first(where: {$0.getLocalizedText() == text}) {
            let index = number.rawValue - 1
            if viewModel.incidenceTypeList.count > index {
                breakDownSelected(type: viewModel.incidenceTypeList[index])
                setenceFinished = true
            } else if viewModel.incidenceTypeList.count == index {
                cancelButtonPressed(nil)
                setenceFinished = true
            }
        }
        
        if let incidenceType = viewModel.incidenceTypeList.first(where: { $0.name == text }) {
            breakDownSelected(type: incidenceType)
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

