
@objc public final class IncidenceLibraryManager: NSObject {
    
    //public static let shared = IncidenceLibraryManager()
    public static var shared: IncidenceLibraryManager!
    
    // MARK: -

    private var config: IncidenceLibraryConfig?
    
    let apiKey: String
    private let env: IncidenceEnvironment
    
    private var validApiKey: Bool? = nil
    private var screens: [String] = [String]()
    private var insurance: Insurance?
    private var appearance: AppConfig?
    
    public var incidencesTypes: [IncidenceType]? = [IncidenceType]()

    public class func setup(_ config: IncidenceLibraryConfig, completion: @escaping (IActionResponse) -> Void) {
        IncidenceLibraryManager.shared = IncidenceLibraryManager(config: config)
        Api.shared.setup(env: config.env);
        shared.initFonts()
        shared.validateApiKey(completionCall: completion);
    }
    
    func initFonts() {
        /*
        for family: String in UIFont.familyNames {
            print("%@", family)
            for name: String in UIFont.fontNames(forFamilyName: family) {
                print("  %@", name)
            }
        }
        */
        
        
        do {
            try IncidenceLibraryManager.shared.fontsURLs().forEach({ try IncidenceLibraryManager.shared.register(from: $0) })
        } catch {
            print(error)
        }
    }
    
    func register(from url: URL) throws {
            guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
                //throw SVError.internal("Could not create font data provider for \(url).")
                fatalError("Could not create font data provider for \(url).")
            }
            let font = CGFont(fontDataProvider)!
            var error: Unmanaged<CFError>?
            guard CTFontManagerRegisterGraphicsFont(font, &error) else {
                throw error!.takeUnretainedValue()
            }
        }
    
    func fontsURLs() -> [URL] {
        let bundle = Bundle(for: IncidenceLibraryManager.self)
        let fileNames = ["Silka-Regular", "Silka-Thin", "Silka-Bold", "Silka-Medium", "Silka-SemiBold"]
        return fileNames.map({ bundle.url(forResource: $0, withExtension: "otf")! })
    }
    
    // Initialization

    private init(config: IncidenceLibraryConfig) {
        //guard config != nil else {
        //    fatalError("Error - you must call setup before accessing MySingleton.shared")
        //}
        
        self.config = config
        self.apiKey = config.apiKey.apiKeyString
        self.env = config.env
    }
    
    public func printStatusConfig() {
        log.error("Config ok " + String(describing: env))
    }
    
    private func validateApiKey(completionCall: @escaping (IActionResponse) -> Void) {
        Api.shared.validateApiKey(apiKey: apiKey, completion: { result in
            var response: IActionResponse
            if (result.isSuccess())
            {
                self.validApiKey = true
                
                self.screens = result.getList(key: "functionalities") ?? [String]()
                //self.screens.append(Constants.SCREEN_REPOR_INC_SIMPLE)
                
                self.insurance = result.get(key: "insurance")
                
                self.appearance = result.get(key: "appearance")
                /*
                self.appearance?.background_color="#FFFFFF";
                self.appearance?.letter_color="#2D373D";
                self.appearance?.error_letter_color="#2D373D";
                self.appearance?.button_color="#D81E05";
                self.appearance?.button_letter_color="#FFFFFF";
                self.appearance?.support_background_color="#D81E05";
                self.appearance?.support_letter_color="#D81E05";
                */
                self.incidencesTypes = result.getList(key: "incidenceTypes") ?? [IncidenceType]()
                
                var valores = result.getJSONString(key: "literals")
                
                //self    String    "select_beacon_type_iot"
                //valores = "{\"select_beacon_type_iot\":\"Help Flash IoT\"}"
                if (valores != nil)
                {
                    valores = valores?.replacingOccurrences(of: "\\/", with: "/")
                    //valores = valores?.replacingOccurrences(of: "\\n", with: "\n") ya no lo hacemos aquí. se hace al hacer e localized() porque sino se cargaba la estructura de json
                    Prefs.saveString(key: Constants.KEY_LITERALS_VALUES, value: valores!)
                    Core.shared.updateLiterals(forceUpdate: false)
                }
                
                Core.shared.registerDevice()
                response = IActionResponse(status: true)
            }
            else
            {
                self.validApiKey = false
                response = IActionResponse(status: false, message: result.message)
            }
            
            completionCall(response)
       })
    }
    
    func validateScreen(screen: String) -> String {
        if (validApiKey == nil) {
            return "CALLIG_VALIDATE_API_KEY"
        } else if (validApiKey == false) {
            return "NO_VALID_API_KEY"
        } else if (self.screens.contains(screen)) {
            return "SCREEN_OK"
        } else {
            return "SCREEN_KO"
        }
    }
    
    public func getDeviceReviewViewController(user: User!, vehicle: Vehicle!, delegate: ReportTypeViewControllerDelegate!) -> IABaseViewController {
        let res = validateScreen(screen: Constants.SCREEN_DEVICE_REVIEW)
        if (res == "SCREEN_OK") {
            let viewModel = DeviceDetailSdkViewModel(vehicle: vehicle, user: user, delegate: delegate)
            let viewController = DeviceDetailInfoViewController.create(with: viewModel)
            return viewController
        } else {
            return processScreenError(error: res)
        }
    }
    
    
    public func getDeviceCreateViewController(user: User!, vehicle: Vehicle!, delegate: ReportTypeViewControllerDelegate!) -> IABaseViewController {
        let res = validateScreen(screen: Constants.SCREEN_DEVICE_CREATE)
        if (res == "SCREEN_OK") {
            let vm = RegistrationBeaconViewModel(origin: .addBeacon, delegate: delegate)
            vm.fromBeacon = true
            vm.user = user
            vm.vehicle = vehicle
            let viewController = RegistrationBeaconSelectTypeViewController.create(with: vm)
            return viewController
            
        } else {
            return processScreenError(error: res)
        }
    }
    
    public func getIncidenceCreateViewController(user: User!, vehicle: Vehicle!, incidence: Incidence!) -> IABaseViewController {
        let res = validateScreen(screen: Constants.FUNC_REPOR_INC)
        if (res == "SCREEN_OK") {
            let vm = ReportIncidenceSimpleViewModel(user: user, vehicle: vehicle, incidence: incidence, createIncidence: true)
            let viewController = ReportIncidenceSimpleViewController.create(with: vm)
            return viewController
            
        } else {
            return processScreenError(error: res)
        }
    }
    
    public func getIncidenceCloseViewController(user: User!, vehicle: Vehicle!, incidence: Incidence!) -> IABaseViewController {
        let res = validateScreen(screen: Constants.FUNC_CLOSE_INC)
        if (res == "SCREEN_OK") {
            let vm = ReportIncidenceSimpleViewModel(user: user, vehicle: vehicle, incidence: incidence, createIncidence: false)
            let viewController = ReportIncidenceSimpleViewController.create(with: vm)
            return viewController
        } else {
            return processScreenError(error: res)
        }
    }
    
    public func getEcommerceViewController(user: User!, vehicle: Vehicle!) -> IABaseViewController {
        let res = validateScreen(screen: Constants.SCREEN_ECOMMERCE)
        if (res == "SCREEN_OK") {
            let vm = EcommerceViewModel(vehicle: vehicle, user: user)
            let viewController = EcommerceVC.create(with: vm)
            return viewController
            
        } else {
            return processScreenError(error: res)
        }
    }
    
    public func getReportIncViewController(user: User!, vehicle: Vehicle!, delegate: ReportTypeViewControllerDelegate!) -> IABaseViewController {
        let res = validateScreen(screen: Constants.SCREEN_REPOR_INC)
        if (res == "SCREEN_OK") {
            let vm = ReportTypeViewModel(vehicle: vehicle, user: user, delegate: delegate, openFromNotification: false, flowComplete: true)
            let viewController = ReportTypeViewController.create(with: vm)
            return viewController
            
        } else {
            return processScreenError(error: res)
        }
    }
    
    public func getReportIncSimpViewController(user: User!, vehicle: Vehicle!, delegate: ReportTypeViewControllerDelegate!) -> IABaseViewController {
        let res = validateScreen(screen: Constants.SCREEN_REPOR_INC_SIMPLE)
        if (res == "SCREEN_OK") {
            let vm = ReportTypeViewModel(vehicle: vehicle, user: user, delegate: delegate, openFromNotification: false, flowComplete: false)
            let viewController = ReportTypeViewController.create(with: vm)
            return viewController
            
        } else {
            return processScreenError(error: res)
        }
    }
    
    func processScreenError(error: String) -> IABaseViewController {
        let viewModel = ErrorViewModel(error: error)
        let viewController = ErrorViewController.create(with: viewModel)
        return viewController
    }
    
    public func hasBeaconFunc(user: User!, vehicle: Vehicle!, completion: @escaping (IActionResponse) -> Void) {
        let res = validateScreen(screen: Constants.FUNC_DEVICE_GET)
        if (res == "SCREEN_OK") {
            Api.shared.getBeaconSdk(vehicle: vehicle, user: user, completion: { result in
                
                var response: IActionResponse
                
                if (result.isSuccess())
                {
                    let beacons = result.getList(key: "beacon") ?? [Beacon]()
                    if (beacons.count > 0) {
                        response = IActionResponse(status: true)
                    } else {
                        response = IActionResponse(status: false, message: result.message)
                    }
                }
                else
                {
                    response = IActionResponse(status: false, message: result.message)
                }
                
                completion(response)
           })
        } else {
            let response: IActionResponse = IActionResponse(status: false, message: res)
            completion(response)
        }
    }
    
    public func deleteBeaconFunc(user: User!, vehicle: Vehicle!, completion: @escaping (IActionResponse) -> Void) {
        let res = validateScreen(screen: Constants.FUNC_DEVICE_DELETE)
        if (res == "SCREEN_OK") {
            Api.shared.deleteBeaconSdk(vehicle: vehicle, user: user, completion: { result in
                
                var response: IActionResponse
                
                if (result.isSuccess())
                {
                    response = IActionResponse(status: true)
                }
                else
                {
                    response = IActionResponse(status: false, message: result.message)
                }
                
                completion(response)
           })
        } else {
            let response: IActionResponse = IActionResponse(status: false, message: res)
            completion(response)
        }
    }

    public func createIncidenceFunc(user: User!, vehicle: Vehicle!, incidence: Incidence!, completion: @escaping (IActionResponse) -> Void) {
        let res = validateScreen(screen: Constants.FUNC_REPOR_INC)
        if (res == "SCREEN_OK") {
            Api.shared.postIncidenceSdk(vehicle: vehicle, user: user, incidence: incidence, completion: { result in
                
                var response: IActionResponse
                
                if (result.isSuccess())
                {
                    response = IActionResponse(status: true)
                }
                else
                {
                    response = IActionResponse(status: false, message: result.message)
                }
                
                completion(response)
           })
        } else {
            let response: IActionResponse = IActionResponse(status: false, message: res)
            completion(response)
        }
    }

    public func closeIncidenceFunc(user: User!, vehicle: Vehicle!, incidence: Incidence!, completion: @escaping (IActionResponse) -> Void) {
        let res = validateScreen(screen: Constants.FUNC_CLOSE_INC)
        if (res == "SCREEN_OK") {
            Api.shared.putIncidenceSdk(vehicle: vehicle, user: user, incidence: incidence, completion: { result in
                
                var response: IActionResponse
                
                if (result.isSuccess())
                {
                    response = IActionResponse(status: true)
                }
                else
                {
                    response = IActionResponse(status: false, message: result.message)
                }
                
                completion(response)
           })
        } else {
            let response: IActionResponse = IActionResponse(status: false, message: res)
            completion(response)
        }
    }
    
    func setViewBackground(view: UIView) {
        if let backgroundColor = self.appearance?.background_color {
            if let color = UIColor.appWithHex(hex: backgroundColor) {
                view.backgroundColor = color
            }
        }
    }
    func setTextColor(view: UILabel) {
        if let letterColor = self.appearance?.letter_color {
            if let color = UIColor.appWithHex(hex: letterColor) {
                view.textColor = color
            }
        }
    }
    func getTextColor() -> UIColor? {
        var colorRes: UIColor? = nil;
        if let letterColor = self.appearance?.letter_color {
            if let color = UIColor.appWithHex(hex: letterColor) {
                colorRes = color
            }
        }
        
        return colorRes
    }
    func setButtonBackground(view: UIView) {
        if let backgroundColor = self.appearance?.button_color {
            if let color = UIColor.appWithHex(hex: backgroundColor) {
                view.backgroundColor = color
            }
        }
    }
    func setButtonTextColor(view: PrimaryButton) {
        if let letterColor = self.appearance?.button_letter_color {
            if let color = UIColor.appWithHex(hex: letterColor) {
                view.setTitleColor(color, for: .normal)
            }
        }
    }
    func setSupportBackground(view: UIView) {
        if let backgroundColor = self.appearance?.support_background_color {
            if let color = UIColor.appWithHex(hex: backgroundColor) {
                view.backgroundColor = color
            }
        }
    }
    func getSupportBackgroundColor() -> UIColor? {
        var colorRes: UIColor? = nil;
        if let letterColor = self.appearance?.support_background_color {
            if let color = UIColor.appWithHex(hex: letterColor) {
                colorRes = color
            }
        }
        
        return colorRes
    }
    func setSupportTintColor(imageView: UIView) {
        if let backgroundColor = self.appearance?.support_letter_color {
            if let color = UIColor.appWithHex(hex: backgroundColor) {
                imageView.tintColor = color
            }
        }
    }
    func setSupportTextColor(view: UILabel) {
        if let letterColor = self.appearance?.support_letter_color {
            if let color = UIColor.appWithHex(hex: letterColor) {
                view.textColor = color
            }
        }
    }
    
    func getInsurance() -> Insurance? {
        return self.insurance
    }
}
