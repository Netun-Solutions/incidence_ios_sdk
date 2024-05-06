//
//  Core.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 04/06/2021.
//

import UIKit
//import MapboxSearch
import CoreLocation
//import Firebase

final class Core {
    
    static let shared = Core()
    var window: UIWindow?
    var appStateBlocked = false
    
    var literales:[String: Any]?
    var voiceLiterales:[String: Any]?
    
    var openAppFromNotificationBeacon:String? = nil
    
    var userCreating:User
    var vehicleCreating:Vehicle
    var vehicleCreatingBecomeFromAddBeacon = false
    var manualAddressCoordinate:CLLocationCoordinate2D?
    
    private var audioLevel : Float = 0.0
    var secondsRemainingConfig = 180
    var secondsRemaining = -1
    var timer:Timer?
    var alertTimeErrorContainerHided: Bool = false
    var alertTimeErrorContainerCall: Bool = false
    
    weak var timerRepeat:Timer?
    var secondsRemainingAudioConfig = 15
    var secondsRemainingAudio = -1
    
    var alertDgtNeedContainerShow: Bool = false
    var alertDgtNeedContainerClosed: Bool = false
    
    private init() {
        userCreating = User()
        vehicleCreating = Vehicle()
        vehicleCreatingBecomeFromAddBeacon = false
    }
}

extension Core {
    
    // Load objets
    
    func getUser() -> User?
    {
        var user:User? = nil
        
        let userJSON:String? = Prefs.loadString(key: Constants.KEY_USER)
        if (userJSON != nil) {
            let jsonData = Data(userJSON!.utf8)
            let decoder = JSONDecoder()
            do {
                user = try decoder.decode(User.self, from: jsonData)
                //print(user)
            } catch {
                print(error)
            }
        }
        
        return user
    }
    
    func getLanguage() -> String
    {
        var res:String = Locale.current.languageCode ?? "es"
        
        if let str = Prefs.loadString(key: Constants.KEY_USER_LANG) {
            res = str
        }
        res = "es";
        
        return res
    }
    
    func isUserPrimaryForVehicle(_ vehicle: Vehicle?) -> Bool
    {
        var isUserPrimary = false
        
        if let ve = vehicle, let drivers = ve.drivers, let user = getUser(), let userId = user.id  {
            for driver in drivers {
                if (driver.isTypePrimary() && userId == driver.id)
                {
                    isUserPrimary = true
                    break
                }
            }
        }
        
        return isUserPrimary
    }
    
    private func getGeneralDataList<T: Codable>(key: String, returnType: [T].Type) -> [T]?
    {
        var res:[T]? = nil
        
        if let jsonStr = Prefs.loadString(key: Constants.KEY_GENERAL_DATA) {
            let json = StringUtils.convertToDictionary(text: jsonStr)
            
            let dictionary = json?[key]
            
            do {
                res = try JSONDecoder().decode(returnType, from: JSONSerialization.data(withJSONObject: dictionary!))
            } catch {
                NSLog("--- FAIL: Error getGeneralDataList decode: " + error.localizedDescription)
                print(error)
            }
        }
        
        return res
    }
    
    func getVehicleType(_ id:Int) -> VehicleType?
    {
        var res:VehicleType? = nil

        let list:[VehicleType]? = getVehiclesTypes()
        if (list != nil)
        {
            for item in (list ?? []) {
                if (item.id == id) {
                    res = item
                    break
                }
            }
        }
        return res
    }
    
    func getColorType(vehicleType:VehicleType?, id:Int) -> ColorType?
    {
        var res:ColorType? = nil
        
        if (vehicleType != nil && vehicleType?.colors != nil)
        {
            for item in (vehicleType?.colors ?? []) {
                if (item.id == id) {
                    res = item
                    break
                }
            }
        }
        
        return res
    }
    
    func getVehiclesTypes() -> [VehicleType]?
    {
        return getGeneralDataList(key: "vehiclesTypes", returnType: [VehicleType].self)
    }
    
    func getBeaconTypes() -> [BeaconType]?
    {
        return getGeneralDataList(key: "beaconsTypes", returnType: [BeaconType].self)
    }
    
    func getColors() -> [ColorType]?
    {
        return getGeneralDataList(key: "colors", returnType: [ColorType].self)
    }
    
    func getIncidencesTypes() -> [IncidenceType]?
    {
        return getGeneralDataList(key: "incidencesTypes", returnType: [IncidenceType].self)
    }
    
    func getIncidencesTypes(parent:Int) -> [IncidenceType]?
    {
        var res:[IncidenceType] = [IncidenceType]()
        
        if let list = getGeneralDataList(key: "incidencesTypes", returnType: [IncidenceType].self) {
            for it in list {
                if let pr = it.parent, pr == parent {
                    res.append(it)
                }
            }
        }
        
        return res
    }
    
    func getIncidencesTypes(parent:Int, incidences: [IncidenceType]?) -> [IncidenceType]?
    {
        var res:[IncidenceType] = [IncidenceType]()
        
        if let list = incidences {
            for it in list {
                if let pr = it.parent, pr == parent {
                    res.append(it)
                }
            }
        }
        
        return res
    }
    
    func getVehicles() -> [Vehicle]
    {
        if let jsonStr = Prefs.loadString(key: Constants.KEY_USER_VEHICLES) {
            do {
                if let  data = jsonStr.data(using: .utf8) {
                    let list:[Vehicle] = try JSONDecoder().decode([Vehicle].self, from: data)
                    return list
                }
            } catch {
                NSLog("--- FAIL: Error getVehicles decode: " + error.localizedDescription)
                print(error)
            }
        }
        
        return [Vehicle]()
    }
    
    func getVehicle(idVehicle:Int) -> Vehicle?
    {
        var vehicle:Vehicle?
        let vehicles = getVehicles()
        
        if (vehicles.count > 0)
        {
            for v in vehicles {
                if (v.id == idVehicle)
                {
                    vehicle = v
                    break
                }
            }
        }
        
        return vehicle
    }
    
    func deleteVehicle(vehicle: Vehicle?)
    {
        replaceVehicle(vehicle: vehicle, delete: true)
    }
    func saveVehicle(vehicle: Vehicle?)
    {
        replaceVehicle(vehicle: vehicle, delete: false)
    }
    private func replaceVehicle(vehicle: Vehicle?, delete: Bool)
    {
        if let vehi = vehicle {
            
            let items = getVehicles()
            var newItems = [Vehicle]()
            var exist = false
            
            for v in items {
                if (v.id == vehi.id)
                {
                    if (!delete)
                    {
                        exist = true;
                        newItems.append(vehi)
                    }
                }
                else
                {
                    newItems.append(v)
                }
            }
            
            if (!exist && !delete)
            {
                newItems.append(vehi)
            }
            
            if let data = try? JSONEncoder().encode(newItems) {
                
                if let jsonStr = String(data: data, encoding: String.Encoding.utf8) {
                    Prefs.saveString(key: Constants.KEY_USER_VEHICLES, value: jsonStr)
                }
            }
            
            
        }
    }
    
    func hasAnyVehicleWithBeacon() -> Bool //se revisan los beacons que van por beaconmanager. los IoT no.
    {
        var res = false
        let list = Core.shared.getVehicles()
        for vehicle in list {
            //if (vehicle.beacon != null && vehicle.beacon.uuid != null && vehicle.beacon.beaconType != null && vehicle.beacon.beaconType.id == 1) {
            //if let beacon = vehicle.beacon, let uuid = beacon.uuid {
            if vehicle.beacon != nil && vehicle.beacon?.uuid != nil && vehicle.beacon?.beaconType != nil && vehicle.beacon?.beaconType?.id == 1 {
                res = true
                break
            }
        }
        
        return res
    }
    
    func initUserCreating()
    {
        userCreating = User()
    }
    
    func getUserCreating() -> User
    {
        return userCreating
    }
    
    func initVehicleCreating(_ becomeFromAddBeacon: Bool = false)
    {
        vehicleCreatingBecomeFromAddBeacon = becomeFromAddBeacon
        vehicleCreating = Vehicle()
    }
    
    func getVehicleCreatingBecomeFromAddBeacon() -> Bool
    {
        return vehicleCreatingBecomeFromAddBeacon
    }
    
    func getVehicleCreating() -> Vehicle
    {
        return vehicleCreating
    }
    
    func getDeviceNotification(notificationId: Int) -> DeviceNotification?
    {
        var res:DeviceNotification? = nil
        
        if let jsonStr = Prefs.loadString(key: Constants.KEY_USER_DEVICE_NOTIFICATIONS) {
            var temp:[DeviceNotification]?
            if let data = jsonStr.data(using: .utf8) {
                
                do {
                    temp = try JSONDecoder().decode([DeviceNotification].self, from: data)
                } catch {
                    NSLog("--- FAIL: Error getDeviceNotification decode: " + error.localizedDescription)
                    print(error)
                }
            }
            
            if let list = temp {
                for d in list {
                    if (d.id == notificationId) {
                        res = d
                        break
                    }
                }
            }
        }
        
        return res
    }
    
    
    // End load objets
    
    func registerDevice()
    {
        /*
        Messaging.messaging().token { token, error in
          if let error = error {
              //print("Xavi Error fetching FCM registration token: \(error)")
              //let pasteBoard = UIPasteboard.general
              //pasteBoard.string = "Error fetching"
              
          } else if let token = token {
            //print("Xavi FCM registration token: \(token)")
              //let pasteBoard = UIPasteboard.general
              //pasteBoard.string = token
              Prefs.saveString(key: Constants.KEY_PUSH_ID, value: token)
          }
            
            Api.shared.updateDevice(completion: { result in })
        }
        */
        Api.shared.updateDevice(completion: { result in })
    }
    
    func getGeneralData()
    {
        if Prefs.loadString(key: Constants.KEY_USER_TOKEN) != nil {
            Api.shared.getGeneralData(completion: { result in })
            
            if let user = getUser()
            {
                if user.id == nil { //para solucionar que antes no se enviaba el id
                    Api.shared.updateUser(name: user.name, phone: user.phone, identityType: nil, dni: nil, email: nil, birthday: nil, completion: { result in })
                }
            }
        }
        
        Api.shared.getGlobals(completion: { result in })
    }
    
    func trackGeoposition()
    {
        if (LocationManager.shared.isLocationEnabled())
        {
            if let location = LocationManager.shared.getCurrentLocation() {
                Api.shared.trackGeoposition(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), completion: { result in })
            }
        }
    }
    
    func updateLiterals(forceUpdate: Bool)
    {
        if let valores = Prefs.loadString(key: Constants.KEY_LITERALS_VALUES) {
            literales = StringUtils.convertToDictionary(text: valores)
        }
        
        if (forceUpdate)
        {
            showContent()
        }
    }
    
    func updateVoiceLiterals(forceUpdate: Bool)
    {
        if let valores = Prefs.loadString(key: Constants.KEY_LITERALS_VOICE_VALUES) {
            voiceLiterales = StringUtils.convertToDictionary(text: valores)
        }
        
        if (forceUpdate)
        {
            showContent()
        }
    }
    
    func signOut()
    {
        Prefs.removeData(key: Constants.KEY_USER)
        Prefs.removeData(key: Constants.KEY_USER_TOKEN)
        Prefs.removeData(key: Constants.KEY_USER_DEFAULT_VEHICLE_ID)
        Prefs.removeData(key: Constants.KEY_USER_VEHICLES)
        Prefs.removeData(key: Constants.KEY_USER_DEVICE_NOTIFICATIONS)
        Prefs.saveString(key: Constants.KEY_USER_SIGNOUT, value: "1")
        
        showContent()
    }
    
    func startNewApp(appScheme:String)
    {
        if let appUrl = URL(string: appScheme) {
            if UIApplication.shared.canOpenURL(appUrl)
            {
                UIApplication.shared.open(appUrl)
            }
            else
            {
                //se abre en Safari
                UIApplication.shared.open(appUrl)
            }
        }
    }
    
    func callNumber(phoneNumber: String) {
        callNumber(phoneNumber: phoneNumber, autoCall: false)
    }
    func callNumber(phoneNumber: String, autoCall: Bool) {
        if (autoCall)
        {
            guard let url = URL(string: "tel://\(phoneNumber)"),
                UIApplication.shared.canOpenURL(url) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            guard let url = URL(string: "telprompt://\(phoneNumber)"),
                UIApplication.shared.canOpenURL(url) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showContent()
    {
        
    }
    
    func onAppBecomeActive()
    {
        if (!appStateBlocked)
        {
            registerDevice()
            getGeneralData()
            manualAddressCoordinate = nil
            
            EventNotification.post(code: .APP_DID_BECOME_ACTIVE)
            
            LocationManager.shared.stopMonitoring()
            LocationManager.shared.startUpdatingLocation()
        }
    }
    
    func onAppResignActive()
    {
        if (!appStateBlocked)
        {
            if (getUser() != nil) {
                
                var initDetection = hasAnyVehicleWithBeacon()
                
                if (initDetection)
                {
                    if let fechaMillis = Prefs.loadString(key: Constants.KEY_LAST_INCIDENCE_REPORTED_DATE) {
                        
                        let ahora = Date().timeIntervalSince1970
                        let fechaInci = Double(fechaMillis) ?? ahora
                        let diff = Int(ahora - fechaInci)
                        let hours = diff / 3600
                        if (hours < 1)
                        {
                            initDetection = false
                        }
                    }
                }
                
                if (initDetection) {
                    LocationManager.shared.startMonitoring()
                }
            }
        }
    }
    
    func startTimer() {
        stopTimer()
        secondsRemaining = secondsRemainingConfig;
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
            //self.timer = Timer
            print("self.secondsRemaining1", secondsRemaining)
            if secondsRemaining > 0 {
                //self.descriptionLabel.text = String(format:self.viewModel.descriptionText, minutes, seconds)
                EventNotification.post(code: .INCIDENCE_TIMER_CHANGE)
                secondsRemaining -= 1
            } else {
                //Timer.invalidate()
                //self.timer = nil
                stopTimer()
                
                //self.descriptionLabel.text = String(format:self.viewModel.descriptionText, 3, 0)
                EventNotification.post(code: .INCICENDE_TIME_STOP)
                //Core.shared.callNumber(phoneNumber: Constants.PHONE_EMERGENCY)               
            }
        }
    }
    
    func stopTimer() {
        if let tm = timer {
            tm.invalidate()
        }
        
        alertTimeErrorContainerCall = false
    }
    
    func startTimerRepeat() {
        stopTimerRepeat()
        secondsRemainingAudio = secondsRemainingAudioConfig;
        self.timerRepeat = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
            print("self.secondsRemainingAudio", secondsRemainingAudio)
            if secondsRemainingAudio > 0 {
                secondsRemainingAudio -= 1
            } else {
                stopTimerRepeat()
                EventNotification.post(code: .INCICENDE_TIME_STOP_REPEAT)
            }
        }
    }
    
    func stopTimerRepeat() {
        if let tm = timerRepeat {
            tm.invalidate()
        }
    }
    
    func setAudioLevel(level: Float) {
        audioLevel = level
    }
    
    func getAudioLevel() -> Float {
        return audioLevel
    }
}
