//
//  SpeechRecognizer.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 14/6/22.
//

import Foundation
import Speech

enum SpeechStatus: Error {
    case authorized
    case denied
}

public class SpeechRecognizer {
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    static var isEnabled: Bool = false
    
    func requestPermission(completion: @escaping(SpeechStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .notDetermined,
                    .restricted,
                    .denied:
                completion(.denied)
         
               case .authorized:
                    AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                        if granted {
                            completion(.authorized)

                        } else {
                            completion(.denied)
                        }
                    })
            @unknown default:
                completion(.denied)
            }
        }
    }

    func startRecording(completion: @escaping((String)->())) throws {
      
        SpeechRecognizer.isEnabled = true
        recognitionTask?.cancel()
        recognitionTask = nil
      
        // Audio session, to get information from the microphone.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputNode = audioEngine.inputNode
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
      
        if #available(iOS 13, *) {
            recognitionRequest!.requiresOnDeviceRecognition = true
        }
        if !speechRecognizer.isAvailable {
            SpeechRecognizer.isEnabled = false
        }
      
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                completion(result.bestTranscription.formattedString)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
              
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
      
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
      
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stop() {
        audioEngine.stop()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    func supportedLocales() -> Set<Locale> {
      return SFSpeechRecognizer.supportedLocales()
    }
}
