//
//  ReportNotificationCarViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import UIKit
import AVFoundation

enum NumbersRecognizion: Int, CaseIterable {
    case one = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    func getLocalizedText() -> String {
        switch self {
        case .one:
            return "one".localizedVoice()
        case .two:
            return "two".localizedVoice()
        case .three:
            return "three".localizedVoice()
        case .four:
            return "four".localizedVoice()
        case .five:
            return "five".localizedVoice()
        case .six:
            return "six".localizedVoice()
        case .seven:
            return "seven".localizedVoice()
        case .eight:
            return "eight".localizedVoice()
        case .nine:
            return "nine".localizedVoice()
        }
    }
}

class ReportNotificationCarViewController: ReportBaseViewController, StoryboardInstantiable, SpeechReconizable {
    var voiceDialogs: [String] {
        get {
            var array = ["ask_report_choose_vehicle".localizedVoice()]
            array.append(contentsOf: speechRecognizion)
            return array
        }
    }
    var speechRecognizion: [String] = []
    
    var speechSynthesizer: AVSpeechSynthesizer!
    var speechRecognizer: SpeechRecognizer!
    
    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportNotificationCarViewModel! { get { return baseViewModel as? ReportNotificationCarViewModel }}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var cancelButton: TextButton!
    var speechButton: UIBarButtonItem?
    var setenceFinished = false
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportNotificationCarViewModel, vehicle: Vehicle?) -> ReportNotificationCarViewController {
        let view = ReportNotificationCarViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        view.vehicle = vehicle
        view.openFromNotification = viewModel.openFromNotification
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        speechReconizableDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppNavigation.setupNavigationApperance(navigationController!, with: .white)
        
        if viewModel.vehicles.count > 0 {
            updateSpeech()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSpeechRecognizion()
        AppNavigation.setupNavigationApperance(navigationController!, with: .regular)
    }
    
    func setUpCarsVoiceRecognizer() {
        var finalIndex = 0
        speechRecognizion.removeAll()
        for (index, vehicle) in viewModel.vehicles.enumerated() {
            let number = NumbersRecognizion(rawValue: index+1)
            if let number = number?.getLocalizedText() {
                speechRecognizion.append(number)
            }
            if let brand = vehicle.brand, let model = vehicle.model {
                speechRecognizion.append("\(brand) \(model)")
            }
            /*
            if let formattedPlate = vehicle.formattedLicencePlate() {
             speechRecognizion.append(formattedPlate)
            }
            */
            finalIndex += 1
        }
        
        if let number = NumbersRecognizion(rawValue: finalIndex+1)?.getLocalizedText() {
            speechRecognizion.append(number)
        }
        
        speechRecognizion.append("cancel".localizedVoice())
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        setUpCarsVoiceRecognizer()
        setUpNavigation()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = VehicleColorCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(VehicleColorCell.self, forCellReuseIdentifier: VehicleColorCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        descriptionLabel.text = viewModel.helperText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)
        
        view.addSubview(alertView)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any?) {
        navigationController?.popToRootViewController(animated: true)
        Core.shared.stopTimer()
        stopTimer()
    }
    
    override func loadData() {
        self.showHUD()
        Api.shared.getVehicles(completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let total = result.getList(key: "vehicles") ?? [Vehicle]()
                var temp = [Vehicle]()
                for v in total {
                    if v.insurance != nil {
                        temp.append(v)
                    }
                }
                
                self.viewModel.vehicles = temp
                self.setUpCarsVoiceRecognizer()
                self.updateSpeech()
                self.tableView.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    private func setUpNavigation() {
        speechButton = UIBarButtonItem(image: UIImage.app( "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(speechPressed))
        speechButton!.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = speechButton!
    }
    
    @objc private func speechPressed() {
        speechButtonPressed()
    }
    
    func updateSpeechButton() {
        let image = UIImage.app( SpeechRecognizer.isEnabled ? "ic_nav_micro_on" : "ic_nav_micro_off")?.withRenderingMode(.alwaysOriginal)
        speechButton?.image = image
    }
    
    func recognizedSpeech(text: String) {
        stopTimer()
        print("-----")
        print(text)
        setenceFinished = false
        if text == "cancel".localizedVoice() {
            cancelButtonPressed(nil)
            setenceFinished = true
        }
        
        if let number = NumbersRecognizion.allCases.first(where: {$0.getLocalizedText() == text}) {
            let index = number.rawValue - 1
            if viewModel.vehicles.count > index {
                carSelected(at: index)
                setenceFinished = true
            } else if viewModel.vehicles.count == index {
                cancelButtonPressed(nil)
                setenceFinished = true
            }
        }
        
        for (index, vehicle) in viewModel.vehicles.enumerated() {
            if let brand = vehicle.brand, let model = vehicle.model {
                if text.lowercased().replacingOccurrences(of: " ", with: "") == "\(brand) \(model)".lowercased().replacingOccurrences(of: " ", with: "") {
                    carSelected(at: index)
                    setenceFinished = true
                }
            }
            /*
            if let formattedPlate = vehicle.formattedLicencePlate() {
                if text == formattedPlate {
                    carSelected(at: index)
                }
            }
            */
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


extension ReportNotificationCarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleColorCell.reuseIdentifier, for: indexPath) as? VehicleColorCell else {
            assertionFailure("Cannot dequeue reusable cell \(VehicleColorCell.self) with reuseIdentifier: \(VehicleColorCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
     
        cell.configure(with: viewModel.vehicles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let vm = ReportTypeViewModel(vehicle: viewModel.vehicles[indexPath.row])
        let vc = ReportTypeViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
        */
        
        carSelected(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VehicleColorCell.height
    }
    
    func carSelected(at index: Int) {
        stopTimer()
        if (viewModel.isAccident)
        {
            let vm = ReportAccidentViewModel()
            vm.vehicle = viewModel.vehicles[index]
            vm.openFromNotification = self.viewModel.openFromNotification
            let vc = ReportAccidentViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            guard let incidencesTypes = Core.shared.getIncidencesTypes(parent: 2) else { return }
            let vm = ReportBreakdownTypeViewModel(incidenceTypeList: incidencesTypes, openFromNotification: self.viewModel.openFromNotification)
            vm.vehicle = viewModel.vehicles[index]
            let vc = ReportBreakdownTypeViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

