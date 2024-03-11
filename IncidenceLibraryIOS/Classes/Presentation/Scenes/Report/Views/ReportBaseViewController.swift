//
//  ReportBaseViewController.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 23/9/22.
//

import UIKit
import AVFoundation
import CoreLocation

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
            return "incidence_key_one".localizedVoice()
        case .two:
            return "incidence_key_two".localizedVoice()
        case .three:
            return "incidence_key_three".localizedVoice()
        case .four:
            return "incidence_key_four".localizedVoice()
        case .five:
            return "incidence_key_five".localizedVoice()
        case .six:
            return "incidence_key_six".localizedVoice()
        case .seven:
            return "incidence_key_seven".localizedVoice()
        case .eight:
            return "incidence_key_eight".localizedVoice()
        case .nine:
            return "incidence_key_nine".localizedVoice()
        }
    }
}

public protocol ReportTypeViewControllerDelegate: AnyObject {
    func onResult(response: IActionResponse)
}

public class ReportBaseViewController: IABaseViewController {
    
    weak var speechReconizableDelegate: SpeechReconizable?
    
    //weak var timer:Timer?
    //var secondsRemainingAudioConfig = 15
    //var secondsRemainingAudio = -1
    
    var vehicle: Vehicle?
    var user: User?
    var openFromNotification:Bool = false
    var timeFinished:Bool = false
    
    public lazy var alertView: UIView = {
        let customTitleText = "incidence_key_turn_up_volume".localized()
        let customSubtitleText = "incidence_key_please_turn_up_volume".localized()
        
        let x = 30.0;
        let y = view.frame.y + 90;
        let width = UIScreen.main.bounds.width - x - x
        let widthMargin = 16.0
        let widthCross = 24.0
        let paddingLabel = 16.0
        let widthTitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel - widthCross - paddingLabel
        let widthSubtitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel
        //let text = customTitleText
        let fontTitle = UIFont.app(.primarySemiBold, size: 14)!
        let fontSubTitle = UIFont.app(.primaryRegular, size: 14)!
        
        let titleHeight = widthCross;
        let subtitleHeight = customSubtitleText.height(withConstrainedWidth: widthSubtitleLabel, font: fontSubTitle);
        let yImage = titleHeight + paddingLabel
        let height = yImage + subtitleHeight + paddingLabel
        
        let alertView = UIView(frame: CGRect(x:30,y:y,width:width,height:height))
        alertView.translatesAutoresizingMaskIntoConstraints = false
        //alertView.isHidden = true
        //alertView.backgroundColor = .red
        //alertView.layer.opacity = 0.2
        alertView.backgroundColor = UIColor.app(.white)
        alertView.layer.cornerRadius = 8
        alertView.layer.masksToBounds = true
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.app(.incidence200)?.cgColor
        alertView.layer.zPosition = 2
        alertView.isHidden = true
        
        let infoImageView = UIImageView(frame: CGRect(x: widthMargin, y: widthMargin, width: widthCross, height: widthCross))
        //infoImageView.backgroundColor = UIColor.app(.black)
        infoImageView.image = UIImage.app( "volume_up")
        infoImageView.isUserInteractionEnabled = true
        //let tap = UITapGestureRecognizer(target: self, action: #selector(closeTooltip))
        //crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(infoImageView)
        
        let tooltipLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: paddingLabel, width:widthTitleLabel, height:titleHeight))
        //tooltipLabel.backgroundColor = UIColor.app(.black300)
        //tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipLabel.font = fontTitle
        tooltipLabel.numberOfLines = 1
        tooltipLabel.textColor = UIColor.app(.black)
        tooltipLabel.text = customTitleText
        alertView.addSubview(tooltipLabel)
        
        let crossImageView = UIImageView(frame: CGRect(x: width - widthMargin - widthCross, y: widthMargin, width: widthCross, height: widthCross))
        //crossImageView.backgroundColor = UIColor.app(.black)
        crossImageView.image = UIImage.app( "Close")
        crossImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAlertView))
        crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(crossImageView)
        
        let tooltipDescLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: yImage, width:widthSubtitleLabel, height:subtitleHeight))
        //tooltipDescLabel.backgroundColor = UIColor.app(.black300)
        tooltipDescLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipDescLabel.font = fontSubTitle
        tooltipDescLabel.numberOfLines = 0
        tooltipDescLabel.textColor = UIColor.app(.black)
        tooltipDescLabel.text = customSubtitleText
        alertView.addSubview(tooltipDescLabel)
        
        return alertView
    }()
    
    lazy var alertTimeLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var alertTimeView: UIView = {
        let customTitleText = "incidence_key_alert_llamada_emergencias_title".localized()
        let customSubtitleText = "incidence_key_alert_llamada_emergencias_subtitle".localized()
        let customAlertText = "incidence_key_alert_llamada_emergencias".localized()
        
        let x = 30.0;
        let y = view.frame.y + 90;
        let width = UIScreen.main.bounds.width - x - x
        let widthMargin = 16.0
        let widthCross = 24.0
        let paddingLabel = 16.0
        let widthTitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel - widthCross - paddingLabel
        let widthSubtitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel
        //let text = customTitleText
        let fontTitle = UIFont.app(.primarySemiBold, size: 14)!
        let fontSubTitle = UIFont.app(.primaryRegular, size: 14)!
        
        let titleHeight = widthCross;
        let subtitleHeight = customSubtitleText.height(withConstrainedWidth: widthSubtitleLabel, font: fontSubTitle);
        let alertHeight = customAlertText.height(withConstrainedWidth: widthSubtitleLabel, font: fontTitle);
        let yText1 = titleHeight + paddingLabel
        let yText2 = yText1 + paddingLabel
        let height = yText2 + alertHeight + paddingLabel
        
        let alertView = UIView(frame: CGRect(x:30,y:y,width:width,height:height))
        alertView.translatesAutoresizingMaskIntoConstraints = false
        //alertView.isHidden = true
        //alertView.backgroundColor = .red
        //alertView.layer.opacity = 0.2
        alertView.backgroundColor = UIColor.app(.white)
        alertView.layer.cornerRadius = 8
        alertView.layer.masksToBounds = true
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.app(.incidence200)?.cgColor
        alertView.layer.zPosition = 2
        alertView.isHidden = true
        
        let infoImageView = UIImageView(frame: CGRect(x: widthMargin, y: widthMargin, width: widthCross, height: widthCross))
        //infoImageView.backgroundColor = UIColor.app(.black)
        infoImageView.image = UIImage.app( "historial")
        infoImageView.isUserInteractionEnabled = true
        //let tap = UITapGestureRecognizer(target: self, action: #selector(closeTooltip))
        //crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(infoImageView)
        
        let tooltipLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: paddingLabel, width:widthTitleLabel, height:titleHeight))
        //tooltipLabel.backgroundColor = UIColor.app(.black300)
        //tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipLabel.font = fontTitle
        tooltipLabel.numberOfLines = 1
        tooltipLabel.textColor = UIColor.app(.black)
        tooltipLabel.text = customTitleText
        alertView.addSubview(tooltipLabel)
        
        let crossImageView = UIImageView(frame: CGRect(x: width - widthMargin - widthCross, y: widthMargin, width: widthCross, height: widthCross))
        //crossImageView.backgroundColor = UIColor.app(.black)
        crossImageView.image = UIImage.app( "Close")
        crossImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAlertTimeView))
        crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(crossImageView)
        
        let tooltipDescLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: yText1, width:widthSubtitleLabel, height:subtitleHeight))
        //tooltipDescLabel.backgroundColor = UIColor.app(.black300)
        tooltipDescLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipDescLabel.font = fontSubTitle
        tooltipDescLabel.numberOfLines = 0
        tooltipDescLabel.textColor = UIColor.app(.black)
        tooltipDescLabel.text = customSubtitleText
        alertView.addSubview(tooltipDescLabel)
        
        alertTimeLabel.frame = CGRect(x: widthMargin + widthCross + paddingLabel, y: yText2, width:widthSubtitleLabel, height:alertHeight)
        //tooltipDescLabel.backgroundColor = UIColor.app(.black300)
        alertTimeLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        alertTimeLabel.font = fontTitle
        alertTimeLabel.numberOfLines = 0
        alertTimeLabel.textColor = UIColor.app(.error200)
        alertTimeLabel.text = customAlertText
        alertView.addSubview(alertTimeLabel)
        
        return alertView
    }()
    
    @objc func closeAlertView() {
        if let delegate = speechReconizableDelegate {
            delegate.speechButtonPressed()
        }
    }
    
    @objc func closeAlertTimeView() {
        Core.shared.alertTimeErrorContainerHided = true;
        alertTimeView.isHidden = true;
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disableSleep();
    }
    
    @objc func timerAlertUpdated(_ notification: Notification) {
        print("Core.shared.secondsRemaining", Core.shared.secondsRemaining);
        if (Core.shared.secondsRemaining != 0 && Core.shared.secondsRemaining <= 30) {
            let seconds: Int = Core.shared.secondsRemaining  % 60
            
            if (!Core.shared.alertTimeErrorContainerHided) {
                alertTimeView.isHidden = false;
                var message = "incidence_key_alert_llamada_emergencias".localized()
                message = String.localizedStringWithFormat(message, seconds)
                alertTimeLabel.text = message
                
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                if (!Core.shared.alertTimeErrorContainerCall && SpeechRecognizer.isEnabled) {
                    Core.shared.alertTimeErrorContainerCall = true;

                    if let delegate = speechReconizableDelegate {
                        delegate.stopSpeechRecognizion()
                        delegate.startSpeechDialog(notUnderstand: false, emergency: true, emergencyMessage: message);
                    }
                }
            }
        } else {
            alertTimeView.isHidden = true;
        }
    }
    
    @objc func timerFinished(_ notification: Notification) {
        stopTimer();
        timeFinished = true;
        
        if (SpeechRecognizer.isEnabled) {
            if let delegate = speechReconizableDelegate {
                let message = "incidence_key_calling_emergency".localized()
                
                delegate.stopSpeechRecognizion()
                delegate.startSpeechDialog(notUnderstand: false, emergency: true, emergencyMessage: message);
            }
        }
        
        //reportIncidence(Constants.ACCIDENT_TYPE_WOUNDED+"", Constants.PHONE_EMERGENCY);
        self.reportIncidence(idIncidence: ReportAccidentViewController.ACCIDENT_TYPE_WOUNDED, phone: Constants.PHONE_EMERGENCY)
    }
    
    @objc func timerRepeatFinished(_ notification: Notification) {
        if let delegate = speechReconizableDelegate {
            delegate.stopSpeechRecognizion()
            delegate.startSpeechDialog(notUnderstand: false);
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //try audioSession.setActive(true, options: [])
            
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setActive(true)
            
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
            Core.shared.setAudioLevel(level: audioSession.outputVolume)
        } catch {
            print("Error")
        }
        
        EventNotification.addObserver(self, code: .INCIDENCE_TIMER_CHANGE, selector: #selector(timerAlertUpdated))
        EventNotification.addObserver(self, code: .INCICENDE_TIME_STOP, selector: #selector(timerFinished))
        EventNotification.addObserver(self, code: .INCICENDE_TIME_STOP_REPEAT, selector: #selector(timerRepeatFinished))
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        enableSleep();
        
        NotificationCenter.default.removeObserver(self)
        
        stopTimer();
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //try audioSession.setActive(true, options: [])
            
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setActive(true)
            
            if audioSession.observationInfo != nil {
                audioSession.removeObserver(self, forKeyPath: "outputVolume")
            }
            Core.shared.setAudioLevel(level: audioSession.outputVolume)
        } catch {
            print("Error")
        }
    }
    
    @objc override func backPressed(){
        stopTimer()
        super.backPressed()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        //let superview = UIApplication.shared.windows.first!
        //superview.addSubview(alertView)
        
        
        //let superview = self.navigationController?.view ?? view!
        //superview.addSubview(alertView)
        
        view.addSubview(alertView)
        view.addSubview(alertTimeView)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            
            let audioSession = AVAudioSession.sharedInstance()
            print("observeValue: ", audioSession.outputVolume)
            if (audioSession.outputVolume != 0.5) {
                /*
                if audioSession.outputVolume > Core.shared.getAudioLevel() {
                    print("Hello")
                }
                if audioSession.outputVolume < Core.shared.getAudioLevel() {
                    print("GoodBye")
                }
                 */
                Core.shared.setAudioLevel(level: audioSession.outputVolume)
                updateAlertView()
            }
          }
     }
    
    public func updateAlertView() {
        if (SpeechRecognizer.isEnabled) {
            print("self.audioLevel: " + String(Core.shared.getAudioLevel()))
            if (Core.shared.getAudioLevel() < 0.25 ) {
                self.alertView.isHidden = false;
                updateAlertTimeViewFrame();
            } else {
                self.alertView.isHidden = true;
                updateAlertTimeViewFrame();
            }
        } else {
            self.alertView.isHidden = true;
            updateAlertTimeViewFrame();
        }
    }
    
    func updateAlertTimeViewFrame() {
        if (self.alertView.isHidden) {
            self.alertTimeView.frame.y = self.alertView.frame.y;
        } else {
            self.alertTimeView.frame.y = self.alertView.frame.height + 16;
        }
    }
    
    func startTimer() {
        /*
        stopTimer()
        
        secondsRemainingAudio = secondsRemainingAudioConfig;
        
        let secondsRemainingAudioNumber:Int? = Prefs.loadInt(key: Constants.KEY_CONFIG_REPEAT_VOICE)
        if let time = secondsRemainingAudioNumber {
            secondsRemainingAudio = time;
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
            //self.timer = Timer
            print("self.secondsRemainingAudio", secondsRemainingAudio)
            if secondsRemainingAudio == 0 {
                
                
                if let delegate = speechReconizableDelegate {
                    delegate.stopSpeechRecognizion()
                    delegate.startSpeechDialog(notUnderstand: false);
                }
                
                //Timer.invalidate()
                //self.timer = nil
                stopTimer()
            }
            secondsRemainingAudio -= 1
            
        }
         */
        Core.shared.startTimerRepeat()
    }
    
    func stopTimer() {
        /*
        if let tm = timer {
            tm.invalidate()
        }
        */
        if let delegate = speechReconizableDelegate {
            delegate.stopSpeechRecognizion()
        }
        Core.shared.stopTimerRepeat()
    }
    
    private func reportIncidence(idIncidence: String, phone: String) {
        
        Core.shared.stopTimer()

        if (LocationManager.shared.isLocationEnabled())
        {
            showHUD()
            
            if let manual = Core.shared.manualAddressCoordinate
            {
                let location = CLLocation(latitude: manual.latitude, longitude: manual.longitude)
                reportLocation(idIncidence: idIncidence, phone: phone, location: location)
            }
            else if let location = LocationManager.shared.getCurrentLocation() {
                reportLocation(idIncidence: idIncidence, phone: phone, location: location)
            }
        }
        else
        {
            showAlert(message: "incidence_key_activate_location_message".localized())
        }
    }
    
    private func reportLocation(idIncidence: String, phone: String, location: CLLocation)
    {
        /*
        MapBoxManager.searchAddress(location: location.coordinate) { address in
            
            var street = ""
            var city = ""
            var country = ""
            let licensePlate = self.vehicle?.licensePlate
            
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
            
            Api.shared.reportIncidence(licensePlate: licensePlate!, incidenceTypeId: idIncidence, street: street, city: city, country: country, location: location, openFromNotification: self.openFromNotification, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    EventNotification.post(code: .INCIDENCE_REPORTED)
                    
                    var call = true
                    
                    if (idIncidence == ReportAccidentViewController.ACCIDENT_TYPE_ONLY_MATERIAL)
                    {
                        let incidence:Incidence? = result.get(key: "incidence")
                        if let inci = incidence, let openApp = inci.openApp
                        {
                            call = false
                            Core.shared.startNewApp(appScheme: openApp.iosUniversalLink ?? "")
                        }
                    }
                    
                    if (call)
                    {
                        let tit = "call_to".localized() + phone
                        
                        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        let firstAction: UIAlertAction = UIAlertAction(title: tit, style: .default) { action -> Void in
                            Core.shared.callNumber(phoneNumber: phone)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        let image = UIImage.app( "PhoneBlack")?.withRenderingMode(.alwaysOriginal)
                        firstAction.setValue(image, forKey: "image")

                        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel".localized(), style: .destructive) { action -> Void in
                            self.navigationController?.popToRootViewController(animated: true)
                        }

                        actionSheetController.addAction(firstAction)
                        actionSheetController.addAction(cancelAction)
                        
                        self.present(actionSheetController, animated: true, completion: nil)
                    }
                    else
                    {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                else
                {
                    self.onBadResponse(result: result)
                }
           })
        }
        */
    }
    
    func enableSleep(){
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func disableSleep(){
        UIApplication.shared.isIdleTimerDisabled = true
    }
}
