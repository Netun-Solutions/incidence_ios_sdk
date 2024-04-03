//
//  SpeechReconizable.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 15/6/22.
//

import UIKit
import AVFoundation


public protocol SpeechReconizable: AVSpeechSynthesizerDelegate {
    var speechRecognizion: [String] { get }
    var voiceDialogs: [String] { get }
    var speechSynthesizer: AVSpeechSynthesizer! { get set }
    var speechRecognizer: SpeechRecognizer! { get set }
    
    func updateSpeech()
    func updateSpeechButton()
    func updateAlertView()
    func stopSpeechRecognizion()
    func startSpeech(completion: @escaping((Bool)->Void))
    func recognizedSpeech(text: String)
    func speechButtonPressed()
    func startSpeechDialog(notUnderstand: Bool)
    func startSpeechDialog(notUnderstand: Bool, emergency: Bool, emergencyMessage: String)
}

public extension SpeechReconizable where Self: UIViewController {


    func speechButtonPressed() {
        SpeechRecognizer.isEnabled = !SpeechRecognizer.isEnabled
        updateSpeech()
    }
    
    func updateSpeech() {
        if SpeechRecognizer.isEnabled {
            setUpSpeechRecognizer()
            startSpeech { [weak self] permission in
                if permission {
                    self?.updateSpeechButton()
                    self?.updateAlertView()
                }
            }
        } else {
            SpeechRecognizer.isEnabled = false
            stopSpeechRecognizion()
            
            Core.shared.stopTimerRepeat()
        }
    }
    
    func startSpeech(completion: @escaping((Bool)->Void)) {

        speechRecognizer.requestPermission { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    SpeechRecognizer.isEnabled = true
                    completion(true)
                    if AVAudioSession.sharedInstance().outputVolume == 0 {
                        self.startSpeechRecognizion()
                    } else {
                        self.startSpeechDialog()
                    }
                  
                case .denied:
                    self.showPermissionAlert()
                    SpeechRecognizer.isEnabled = false
                    completion(false)
                    break
                }
            }
        }
    }
    
    func stopSpeechRecognizion() {
        if speechRecognizer != nil {
            speechRecognizer.stop()
            speechRecognizer = nil
        }
        if speechSynthesizer != nil {
            speechSynthesizer.stopSpeaking(at: .immediate)
            speechSynthesizer = nil
        }
        updateSpeechButton()
        updateAlertView()
    }
    
    func setUpSpeechRecognizer() {
        speechRecognizer = SpeechRecognizer()
    }
    
    func setUpSpeechSynthesizer() {
        speechSynthesizer = AVSpeechSynthesizer()
    }
    
    func startSpeechDialog(notUnderstand: Bool = false) {
        startSpeechDialog(notUnderstand: notUnderstand, emergency: false, emergencyMessage: "")
    }
    func startSpeechDialog(notUnderstand: Bool = false, emergency: Bool = false, emergencyMessage: String = "") {
        if speechSynthesizer != nil {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        setUpSpeechSynthesizer()
        speechSynthesizer.delegate = self
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setActive(true)
        } catch {
            return
        }
        
        let sentence = !notUnderstand ? (!emergency ? voiceDialogs.joined(separator: ". ") : emergencyMessage) : "incidence_key_not_understand_voice".localizedVoice()
        
        //let cLocaleOld = Locale.current.identifier
        let cLocale = Core.shared.getLanguage()
        
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = AVSpeechSynthesisVoice(language: cLocale)
        guard speechSynthesizer.isSpeaking else {
            speechSynthesizer.speak(utterance)
            return
        }
    }
    
    func startSpeechRecognizion() {
        setUpSpeechRecognizer()
        if speechSynthesizer != nil {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        do {
            SpeechRecognizer.isEnabled = true
            try self.speechRecognizer.startRecording(completion: { [weak self] result in
                print("TEXTO RECONOCIDO: ", result)
                self?.recognizedSpeech(text: result)
            })
        } catch _ {
            print("error")
        }
    }
    
    func showPermissionAlert() {
        let alertController = UIAlertController (title: "incidence_key_alert_need_audio_permission_title".localized(), message: "incidence_key_alert_need_audio_permission_description".localized(), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "incidence_key_settings".localized(), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "incidence_key_cancel".localized(), style: .default, handler: nil)
            alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func notUnderstandVoice() {
        if !(speechSynthesizer?.isSpeaking ?? false) {
            stopSpeechRecognizion()
            startSpeechDialog(notUnderstand: true)
        }
    }
}
