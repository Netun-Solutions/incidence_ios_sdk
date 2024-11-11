//
//  Api.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 10/05/2021.
//

import Foundation
//import E510_Networking
import CoreLocation
import Alamofire

final class Api {
    
    static let shared = Api()
    /*
    lazy var sessionManager = AuthNetworkSessionManager()
    lazy var dataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: APIEndpoints.API_BASE_URL)!)
        let apiDataNetwork = DefaultNetworkService(config: config,
                                                   sessionManager: sessionManager)
        let service = DefaultDataTransferService(with: apiDataNetwork, miniAppEncrypt: false)
        return service
    }()
    */
    private init() {
    }
    
    static let HEADER_TOKEN = "token"
    static let HEADER_DEVICE_ID = "deviceId"
    static let HEADER_APP = "app"
    static let HEADER_LANG = "lang"
    static let HEADER_PLATFORM = "platform"
    static let HEADER_AUTHORIZATION = "Authorization"
}

extension Api {
    
    func setup(env: IncidenceEnvironment) {
        if (env == IncidenceEnvironment.TEST) {
            APIEndpoints.API_BASE_URL = APIEndpoints.API_BASE_URL_TEST
        } else if (env == IncidenceEnvironment.PRE) {
            APIEndpoints.API_BASE_URL = APIEndpoints.API_BASE_URL_PRE
        } else {
            APIEndpoints.API_BASE_URL = APIEndpoints.API_BASE_URL_PRO
        }
    }
    
    func hasConnection() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func basicHeaders() -> HTTPHeaders {
        var headers:HTTPHeaders = [:]
        /*
        let token:String? = Prefs.loadString(key: Constants.KEY_USER_TOKEN)
        if (token != nil) {
            headers[Api.HEADER_TOKEN] = token!
        }
         */
        
        let deviceId:Int? = Prefs.loadInt(key: Constants.KEY_DEVICE_ID)
        if (deviceId != nil) {
            headers[Api.HEADER_DEVICE_ID] = String(deviceId!)
        }
        
        headers[Api.HEADER_APP] = Bundle.main.bundleIdentifier
        headers[Api.HEADER_LANG] = Core.shared.getLanguage()
        headers[Api.HEADER_PLATFORM] = "ios"
        
        headers[Api.HEADER_AUTHORIZATION] = IncidenceLibraryManager.shared.apiKey
        
        return headers
    }
    
    func apiUrl(path:String) -> String
    {
        return APIEndpoints.API_BASE_URL + "/" + path
    }
    
    func simpleRequest(method:HTTPMethod = .get, path:String, params:Parameters? = nil, completion: @escaping (IResponse) -> Void)
    {
        let url = apiUrl(path: path)
        #if DEBUG
        print("Request: " + url)
        if let params {
            print("Params: " + params.description)
        }
        #endif
        
        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: basicHeaders()).responseJSON { response in
            var iresponse = IResponse.init()
            switch response.result {
                case .success(let value):
                if let json = value as? [String: Any] {
                    iresponse = IResponse.init(json: json)
                }
                case .failure(let error):
                    iresponse = IResponse.init(error: error)
            }
            
            #if DEBUG
            print(iresponse)
            #endif
            completion(iresponse)
        }
    }
    
    func validateApiKey(apiKey: String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["apiKey"] = apiKey
        
        //let path = "user/validateApiKey"
        //simpleRequest(method: .post, path: path, params: params, completion: completion)
        let path = "sdk/config"
        simpleRequest(method: .get, path: path, completion: completion)
    }
    
    //func signIn(email: String?, phone: String?, completion: @escaping (Result<IResponse, Error>) -> Void) {
    func signIn(email: String?, phone: String?, completion: @escaping (IResponse) -> Void)
    {
        /*
         var params:[String:Any?] = [:]
         if (email != nil) {
             params["email"] = email
         } else if (phone != nil) {
             params["phone"] = email
         }
         
        let endpoint = APIEndpoints.signIn(parameters: params)
        let networkTask = self.dataTransferService.request(with: endpoint, completion: { [weak self] result in
            /*switch result {
            case .success(let data):
                self?.dataTransferService.setDefaultAccessToken(data.token)
            default: break
            }*/
            completion(result)
        })
        */
        
        
        var params:Parameters = [:]
        if (email != nil) {
            params["email"] = email
        } else if (phone != nil) {
            params["phone"] = phone
        }
        
        simpleRequest(method: .post, path: "user/login", params: params, completion: completion)
    }
    
    func signUp(name: String, phone: String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["name"] = name
        params["phone"] = phone
        params["checkTerms"] = "1"
        
        simpleRequest(method: .post, path: "user", params: params, completion: completion)
    }
    
    func deleteAccount(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .delete, path: "user", completion: completion)
    }
    
    func updateUser(name: String?, phone: String?, identityType: String?, dni: String?, email: String?, birthday: String?, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        if (name != nil) {
            params["name"] = name
        }
        if (phone != nil) {
            params["phone"] = phone
        }
        params["checkTerms"] = "1"
        params["checkAdvertising"] = "1"
        if (identityType != nil) {
            params["identityType"] = identityType
        }
        if (dni != nil) {
            params["dni"] = dni
        }
        if (email != nil) {
            params["email"] = email
        }
        if (birthday != nil) {
            params["birthday"] = birthday
        }
        
        simpleRequest(method: .put, path: "user", params: params, completion: { result in
            if (result.isSuccess())
            {
                let user:String? = result.getJSONString(key: "user")
                Prefs.saveString(key: Constants.KEY_USER, value: user!)
            }
            
            completion(result)
        })
    }
    
    func updateDevice(completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        #if DEBUG
        print("Device uuid: ", (uuid ?? "") as String)
        #endif
        params["uuid"] = uuid
        
        let token:String? = Prefs.loadString(key: Constants.KEY_PUSH_ID)
        if (token != nil) {
            params["token"] = token
        }
        params["platform"] = "iOS"
        params["version"] = UIDevice.current.systemVersion
        /*if (UIDevice.current.userInterfaceIdiom == .phone) {
            params["manufacturer"] = "iPhone"
        }
        else if (UIDevice.current.userInterfaceIdiom == .pad) {
            params["manufacturer"] = "iPad"
        }
        else {
            params["manufacturer"] = "Unknown"
        }*/
        params["manufacturer"] = "Apple"
        params["model"] = ModelDevice.modelName
        params["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        params["appVersionNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        params["response"] = "{}"
        
        
        
        
        
        
        
        var method:HTTPMethod = .post
        
        let deviceId:Int? = Prefs.loadInt(key: Constants.KEY_DEVICE_ID)
        if (deviceId != nil) {
            method = .put
        }
        
        simpleRequest(method: method, path: "sdk/device", params: params, completion: { result in
            if (result.isSuccess())
            {
                let device:IDevice? = result.get(key: "device")
                if (device != nil) {
                    Prefs.saveInt(key: Constants.KEY_DEVICE_ID, value: (device?.id)!)
                }
            }
            completion(result)
        })
    }
    
    func getDeviceNotifications(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "device/notifications", completion: { result in
            if (result.isSuccess())
            {
                let notificationsTypes:String? = result.getJSONString(key: "notificationsTypes")
                Prefs.saveString(key: Constants.KEY_USER_DEVICE_NOTIFICATIONS, value: notificationsTypes!)
            }
            completion(result)
        })
    }
    
    func setDeviceNotifications(notificationId: Int, status:Int, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["notificationId"] = notificationId
        params["status"] = status
        
        simpleRequest(method: .put, path: "device/notifications", params: params, completion: { result in
            if (result.isSuccess())
            {
                self.getDeviceNotifications(completion: completion)
            }
            else
            {
                completion(result)
            }
        })
    }

    func validateCode(code: String?, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["code"] = code
        
        simpleRequest(method: .post, path: "user/code/validate", params: params, completion: { result in
            if (result.isSuccess())
            {
                let user:String? = result.getJSONString(key: "user")
                Prefs.saveString(key: Constants.KEY_USER, value: user!)
                
                let token:String? = result.getString(key: "token")
                Prefs.saveString(key: Constants.KEY_USER_TOKEN, value: token!)
                
                self.getGeneralData(completion: { result in
                    completion(result)
               })
                
                self.getDeviceNotifications(completion: { result in
               })
            }
            else
            {
                completion(result)
            }
        })
    }
    
    func generateCode(toEmail: Bool, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        if (toEmail) {
            params["type"] = "email"
        }
        simpleRequest(method: .post, path: "user/code/generate", params: params, completion: completion)
    }
    
    func getGeneralData(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "types", completion: { result in
            if (result.isSuccess())
            {
                if let json = result.getJSONString() {
                    Prefs.saveString(key: Constants.KEY_GENERAL_DATA, value: json)
                }
            }
            completion(result)
        })
    }
    
    func getGlobals(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "globals", completion: { result in
            if (result.isSuccess())
            {
                var forceUpdate = false
                let currentLang:String = Core.shared.getLanguage()
                let literalsLang = Prefs.loadString(key: Constants.KEY_LITERALS_LANG)
                let literals = Prefs.loadInt(key: Constants.KEY_LITERALS_VERSION)
                let literalsVoice = Prefs.loadString(key: Constants.KEY_LITERALS_VOICE_VALUES)
                
                if (literalsLang != nil && literalsLang != currentLang) {
                    forceUpdate = true
                }
                else if (literalsLang == nil && currentLang == "en") {
                    forceUpdate = true
                } else if (literalsVoice == nil) {
                    forceUpdate = true
                }
                let versions:Versions? = result.get(key: "versions")
                if (forceUpdate || literalsLang == nil || literals == nil || (versions != nil && versions?.literals ?? 1 > literals!))
                {
                    self.getLiterals(completion: { result1 in
                        if (result1.isSuccess())
                        {
                            var valores = result1.getJSONString(key: "items")
                            if (valores != nil)
                            {
                                valores = valores?.replacingOccurrences(of: "\\/", with: "/")
                                //valores = valores?.replacingOccurrences(of: "\\n", with: "\n") ya no lo hacemos aquí. se hace al hacer e localized() porque sino se cargaba la estructura de json
                                Prefs.saveString(key: Constants.KEY_LITERALS_VALUES, value: valores!)
                                Prefs.saveString(key: Constants.KEY_LITERALS_LANG, value: currentLang)
                                Prefs.saveInt(key: Constants.KEY_LITERALS_VERSION, value: versions?.literals ?? 1)
                                
                                Core.shared.updateLiterals(forceUpdate: forceUpdate)
                            }
                            
                            var valoresVoice = result1.getJSONString(key: "items_voice")
                            if (valoresVoice != nil)
                            {
                                valoresVoice = valoresVoice?.replacingOccurrences(of: "\\/", with: "/")
                                Prefs.saveString(key: Constants.KEY_LITERALS_VOICE_VALUES, value: valoresVoice!)
                                Core.shared.updateVoiceLiterals(forceUpdate: forceUpdate)
                            }
                        }
                    })
                }
                if let ver = versions, versions != nil {
                    Prefs.saveInt(key: Constants.KEY_CONFIG_EXPIRE_POLICY_TIME, value: ver.expirePolicyTime)
                    Prefs.saveInt(key: Constants.KEY_CONFIG_RETRY_SECON_DRIVER_REQUEST, value: ver.retrySeconDriverRequest)
                    Prefs.saveInt(key: Constants.KEY_CONFIG_MAP_REFRESH_TIME, value: ver.mapRefreshTime)
                    Prefs.saveInt(key: Constants.KEY_CONFIG_EXPIRE_SMS_TIME, value: ver.expireSmsTime)
                    Prefs.saveInt(key: Constants.KEY_CONFIG_EXPIRE_CANCEL_TIME, value: ver.expireCancelTime)
                    Prefs.saveInt(key: Constants.KEY_CONFIG_HOME_VIDEO, value: ver.homeVideo)
                    Prefs.saveInt(key: Constants.KEY_CONFIG_SHOW_IOT, value: ver.showIoT)
                    Prefs.saveInt(key: Constants.KEY_CONFIG_REPEAT_VOICE, value: ver.repeatVoice)
                    Prefs.saveString(key: Constants.KEY_CONFIG_TEST_META_KEY, value: ver.testMetaKey)
                }
            }
            completion(result)
        })
    }
    
    func getLiterals(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "literals/app", completion: { result in
            if (result.isSuccess())
            {
            }
            completion(result)
        })
    }
    
    func validateLicensePlate(licensePlate:String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["licensePlate"] = licensePlate
        simpleRequest(method: .post, path: "vehicle/licensePlate/validate", params: params, completion: completion)
    }
    
    func addVehicle(vehicle:Vehicle, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["licensePlate"] = vehicle.licensePlate
        params["brand"] = vehicle.brand
        params["model"] = vehicle.model
        if let year = vehicle.registrationYear {
            params["registrationYear"] = String(year)
        }
        params["vehicleTypeId"] = vehicle.vehicleType?.id
        if let color = vehicle.color {
            params["colorId"] = color.id
        }
        
        simpleRequest(method: .post, path: "vehicle", params: params, completion: completion)
    }
    
    func updateVehicle(vehicle:Vehicle, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["licensePlate"] = vehicle.licensePlate
        params["brand"] = vehicle.brand
        params["model"] = vehicle.model
        if let year = vehicle.registrationYear {
            params["registrationYear"] = String(year)
        }
        params["vehicleTypeId"] = vehicle.vehicleType?.id
        params["colorId"] = vehicle.color?.id
        
        simpleRequest(method: .put, path: "vehicle", params: params, completion: completion)
    }
    
    func deleteVehicle(vehicle:Vehicle, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["licensePlate"] = vehicle.licensePlate
        
        simpleRequest(method: .delete, path: "vehicle", params: params, completion: completion)
    }
    
    func deleteVehicleBeacon(vehicle:Vehicle, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["beaconId"] = vehicle.beacon?.id
        params["vehicleId"] = vehicle.id
        
        simpleRequest(method: .delete, path: "vehicle/beacon", params: params, completion: completion)
    }
    
    func updateVehicleBeacon(beacon:Beacon, newName: String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["beaconId"] = beacon.id
        params["vehicleId"] = beacon.vehicle?.id
        params["name"] = newName
        
        simpleRequest(method: .put, path: "vehicle/beacon", params: params, completion: completion)
    }
    
    func getVehicles(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "vehicles", completion: { result in
            if (result.isSuccess())
            {
                let vehicles:String? = result.getJSONString(key: "vehicles")
                Prefs.saveString(key: Constants.KEY_USER_VEHICLES, value: vehicles!)
            }
            
            completion(result)
        })
    }
    
    func addVehiclePolicy(vehicle:Vehicle, policy:Policy, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["policyId"] = vehicle.policy?.id
        params["insuranceId"] = vehicle.insurance?.id
        params["identityType"] = policy.identityType?.id
        params["dni"] = policy.dni
        params["policyNumber"] = policy.policyNumber
        //params["policyStart"] = policy.policyStart
        if let caducity = policy.policyEnd {
            params["policyEnd"] = caducity
        }
        
        simpleRequest(method: .put, path: "policy", params: params, completion: completion)
    }
    
    func addVehicleInsurance(vehicle:Vehicle, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["policyId"] = vehicle.policy?.id
        params["insuranceId"] = vehicle.insurance?.id
        
        simpleRequest(method: .put, path: "policy", params: params, completion: completion)
    }

    func getInsurances(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "insurances", completion: completion)
    }
    
    func addInsurance(policyId:String, name:String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["policyId"] = policyId
        params["name"] = name
        
        simpleRequest(method: .post, path: "insurance/custom", params: params, completion: completion)
    }
    
    func validateBeacon(beacon:Beacon, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        if let iot = beacon.iot {
            params["iot"] = iot
        }
        else
        {
            params["uuid"] = beacon.uuid
            params["major"] = beacon.major
            params["minor"] = beacon.minor
        }
        
        simpleRequest(method: .post, path: "beacons/validate", params: params, completion: completion)
    }
    
    func addBeacon(beacon:Beacon, vehicle:Vehicle, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        //params["beaconTypeId"] = beacon.beaconTypeId
        
        if let iot = beacon.iot {
            params["beaconTypeId"] = "2"
            params["iot"] = iot
        }
        else {
            params["beaconTypeId"] = "1"
            params["uuid"] = beacon.uuid
            params["major"] = beacon.major
            params["minor"] = beacon.minor
        }
        
        
        params["vehicleId"] = vehicle.id
        
        simpleRequest(method: .post, path: "beacons", params: params, completion: completion)
    }
    
    func addBeaconSdk(beacon:Beacon, vehicle:Vehicle, user: User, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        //params["beaconTypeId"] = beacon.beaconTypeId
        /*
        if let iot = beacon.iot {
            params["beaconTypeId"] = "2"
            params["iot"] = iot
        }
        else {
            params["beaconTypeId"] = "1"
            params["uuid"] = beacon.uuid
            params["major"] = beacon.major
            params["minor"] = beacon.minor
        }
        
        params["vehicleId"] = vehicle.id
         */
        
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        params["imei"] = beacon.uuid // (imei)
        
        simpleRequest(method: .post, path: "sdk/beacon", params: params, completion: completion)
    }
    
    func deleteBeacon(beacon:Beacon, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["beaconId"] = beacon.id
        params["vehicleId"] = beacon.vehicle?.id
        
        simpleRequest(method: .delete, path: "vehicle/beacon", params: params, completion: completion)
    }
    
    func deleteBeaconSdk(vehicle:Vehicle, user: User, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        
        simpleRequest(method: .delete, path: "sdk/beacon", params: params, completion: completion)
    }
    
    func getBeacons(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "beacons", completion: completion)
    }
    
    func getSessions(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "sessions", completion: completion)
    }
    
    func deleteSession(session:Session, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["sessionId"] = session.id
        
        simpleRequest(method: .delete, path: "session", params: params, completion: completion)
    }
    
    func getNotifications(completion: @escaping (IResponse) -> Void)
    {
        simpleRequest(method: .get, path: "notifications", completion: completion)
    }
    
    func updateNotificationStatus(notification:INotification, newStatus:Int, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["notificationId"] = notification.id
        params["status"] = newStatus
        
        simpleRequest(method: .put, path: "notifications", params: params, completion: completion)
    }
    
    private func validate(value:String, completion: @escaping (IResponse) -> Void)
    {
        let trimmedString = value.replacingOccurrences(of: " ", with: "")
        let path = "validations" + "/" + trimmedString
        simpleRequest(method: .get, path: path, completion: completion)
    }
    
    func validateDNI(value:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "dni" + "/" + value
        validate(value: path, completion: completion)
    }
    
    func validateNIE(value:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "nie" + "/" + value
        validate(value: path, completion: completion)
    }
    
    func validateCIF(value:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "cif" + "/" + value
        validate(value: path, completion: completion)
    }
    
    func validatePhone(value:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "phone" + "/" + value
        validate(value: path, completion: completion)
    }
    
    func validateEmail(value:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "email" + "/" + value
        validate(value: path, completion: completion)
    }
    
    func validateYear(value:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "year" + "/" + value
        validate(value: path, completion: completion)
    }
    
    func trackGeoposition(latitude:String, longitude:String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["latitude"] = latitude
        params["longitude"] = longitude
        params["reverse"] = "{\"street\": \"\", \"country\": \"\", \"city\": \"\" }"
        params["push"] = "0"
        
        simpleRequest(method: .post, path: "tracking/geoposition", params: params, completion: completion)
    }
    
    func reportIncidence(licensePlate:String, incidenceTypeId:String, street:String, city:String, country:String, location:CLLocation, openFromNotification:Bool, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["licensePlate"] = licensePlate
        params["incidenceTypeId"] = incidenceTypeId
        params["street"] = street
        params["city"] = city
        params["country"] = country
        
        params["latitude"] = String(location.coordinate.latitude)
        params["longitude"] = String(location.coordinate.longitude)
        params["altitude"] = String(location.altitude)
        params["accuracy"] = String(location.speedAccuracy)
        params["speed"] = String(location.speed)
        
        if (openFromNotification) {
            params["fromNotification"] = "1"
        } else {
            params["fromNotification"] = "0"
        }
        
        print(params)
        simpleRequest(method: .post, path: "incidence", params: params, completion: { result in
            if (result.isSuccess())
            {
                let ahora:String = String(Date().timeIntervalSince1970)
                Prefs.saveString(key: Constants.KEY_LAST_INCIDENCE_REPORTED_DATE, value: ahora)
            }
            
            completion(result)
        })
    }
    
    func postIncidenceSdk(vehicle:Vehicle, user: User, incidence: Incidence, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        
        params["incidenceTypeId"] = String(incidence.incidenceType?.externalId ?? "0") // (identificador numérico del tipo de incidencia)
        params["street"] = incidence.street
        params["city"] = incidence.city
        params["country"] = incidence.country
        params["latitude"] = String(incidence.latitude ?? 0)
        params["longitude"] = String(incidence.longitude ?? 0)
        params["fromNotification"] = "0" //  (0: reportado manualmente. 1: reportado por baliza)
        params["externalIncidenceId"] = incidence.externalIncidenceId
        
        simpleRequest(method: .post, path: "sdk/incidence", params: params, completion: completion)
    }
    
    func closeIncidence(incidenceId: Int, completion: @escaping (IResponse) -> Void)
    {
        let path = "incidence/close/" + String(incidenceId)
        simpleRequest(method: .get, path: path, completion: { result in
            if (result.isSuccess())
            {
                Prefs.removeData(key: Constants.KEY_LAST_INCIDENCE_REPORTED_DATE)
            }
            
            completion(result)
        })
    }
    
    func putIncidenceSdk(vehicle:Vehicle, user: User, incidence: Incidence, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        
        params["externalIncidenceId"] = incidence.externalIncidenceId
        
        simpleRequest(method: .put, path: "sdk/incidence", params: params, completion: completion)
    }
    
    func cancelIncidence(incidenceId: Int, completion: @escaping (IResponse) -> Void)
    {
        let path = "incidence/cancel/" + String(incidenceId)
        simpleRequest(method: .get, path: path, completion: { result in
            if (result.isSuccess())
            {
                Prefs.removeData(key: Constants.KEY_LAST_INCIDENCE_REPORTED_DATE)
            }
            
            completion(result)
        })
    }
    
    func rateIncidence(incidenceId:String, rate:String?, rateComment:String?, customAnswer:String?, answers:[Int]?, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["incidenceId"] = incidenceId
        if (rate != nil) {
            params["rate"] = rate
        }
        if (rateComment != nil) {
            params["rateComment"] = rateComment
        }
        if (customAnswer != nil) {
            params["customAnswer"] = customAnswer
        }
        if (answers != nil) {
            params["answers"] = answers
        }
        
        simpleRequest(method: .put, path: "incidence/rate", params: params, completion: completion)
    }
    
    func asiturIncidence(incidenceId:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "incidence/asitur/" + incidenceId
        simpleRequest(method: .get, path: path, completion: completion)
    }
    
    func getEcommerces(completion: @escaping (IResponse) -> Void)
    {
        let path = "ecommerces"
        simpleRequest(method: .get, path: path, completion: completion)
    }
    
    func getEcommercesSdk(vehicle:Vehicle, user: User, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        
        simpleRequest(method: .put, path: "sdk/ecommerces", params: params, completion: completion)
    }
    
    func changeVehicleDriver(vehicleId:String, userId:String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["vehicleId"] = vehicleId
        params["userId"] = userId
        
        simpleRequest(method: .put, path: "vehicle/driver/change", params: params, completion: completion)
    }
    
    func deleteVehicleDriver(vehicleId:String, userId:String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["vehicleId"] = vehicleId
        params["userId"] = userId
        
        simpleRequest(method: .delete, path: "vehicle/driver", params: params, completion: completion)
    }
    
    func requestAddVehicleDriver(vehicleId:String, type:String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["vehicleId"] = vehicleId
        params["type"] = type
        
        simpleRequest(method: .post, path: "vehicle/driver", params: params, completion: completion)
    }
    
    func validateVehicleDriver(vehicleId:String, userId:String, status:String, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        params["vehicleId"] = vehicleId
        params["userId"] = userId
        params["status"] = status
        
        simpleRequest(method: .put, path: "vehicle/driver", params: params, completion: completion)
    }
    
    func getTutorialVideos(completion: @escaping (IResponse) -> Void)
    {
        let path = "help/videos"
        simpleRequest(method: .get, path: path, completion: completion)
    }
    
    func getHomeVideo(completion: @escaping (IResponse) -> Void)
    {
        let path = "config/home_video"
        simpleRequest(method: .get, path: path, completion: completion)
    }
    
    func getBeaconDetail(beaconImei:String, completion: @escaping (IResponse) -> Void)
    {
        let path = "partners/iot_check/" + beaconImei
        simpleRequest(method: .get, path: path, completion: completion)
    }
    
    func getBeaconSdk(vehicle:Vehicle, user: User, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        
        simpleRequest(method: .put, path: "sdk/beacon", params: params, completion: completion)
    }
    
    func getGeoSdk(vehicle:Vehicle, user: User, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        
        simpleRequest(method: .put, path: "sdk/iot_coordinates", params: params, completion: completion)
    }
    
    func getBeaconDetailSdk(vehicle:Vehicle, user: User, completion: @escaping (IResponse) -> Void)
    {
        var params:Parameters = [:]
        
        params["external_user_id"] = user.externalUserId // (identificador externo del usuario)
        params["name"] = user.name // (nombre del usuario)
        params["phone"] = user.phone // (teléfono)
        params["email"] = user.email // (e-mail)
        params["identity_type"] = String(user.identityType?.name ?? "") // (tipo de documento de identidad: dni, nie, cif)
        params["dni"] = user.dni // (número del documento de identidad)
        params["birthday"] = user.birthday // (fecha de Nacimiento)
        params["check_terms"] = user.checkTerms // (aceptación de la privacidad)
        params["external_vehicle_id"] = vehicle.externalVehicleId // (identificador externo del vehículo)
        params["license_plate"] = vehicle.licensePlate // (matrícula del vehículo)
        params["registration_year"] = vehicle.registrationYear // (fecha de matriculación)
        params["vehicle_type"] = String(vehicle.vehicleType?.name ?? "") // (tipo del vehículo)
        params["brand"] = vehicle.brand // (marca del vehículo)
        params["model"] = vehicle.model // (modelo del vehículo)
        params["color"] = String(vehicle.color?.name ?? "") // (color del vehículo)
        params["policy_number"] = vehicle.policy?.policyNumber // (número de la póliza)
        params["policy_end"] = vehicle.policy?.policyEnd // (fecha caducidad de la póliza)
        params["policy_identity_type"] = String(vehicle.policy?.identityType?.name ?? "") // (tipo de documento identidad del asegurador)
        params["policy_dni"] = vehicle.policy?.dni // (documento de identidad del asegurador)
        
        simpleRequest(method: .put, path: "sdk/iot_check", params: params, completion: completion)
    }
}

/*
extension AuthNetworkRequest: NetworkCancellable {}
extension AuthNetworkSessionManager: NetworkSessionManager {
    public func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        return authRequest(request, completion: completion)
    }
}
*/
