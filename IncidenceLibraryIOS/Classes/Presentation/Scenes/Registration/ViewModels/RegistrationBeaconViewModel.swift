//
//  RegistrationBeaconViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit

enum RegistrationOrigin {
    case registration
    case add
    case editVehicle
    case addBeacon
    case editInsurance
}

enum RegistrationBeaconStatus {
    case alertBluetooth
    case bluetoothFail
    case missingBeacon
    case lookingBeacon
    case selectionBeacon
}


class RegistrationBeaconViewModel: IABaseViewModel {
    
    public var origin: RegistrationOrigin
    public var status: RegistrationBeaconStatus = .alertBluetooth
    
    public var autoSelectedVehicle:Vehicle?
    public var fromBeacon = false

    var user: User!
    var vehicle: Vehicle!
    var delegate: ReportTypeViewControllerDelegate
    
    internal init(origin: RegistrationOrigin = .registration, delegate: ReportTypeViewControllerDelegate!) {
        self.origin = origin
        self.delegate = delegate
    }
    
    public override var navigationTitle: String? {
        get { return "incidence_key_create_account_step3".localized() }
        set { }
    }
    
    var helperLabelText: String? {
        get {
            switch status {
            case .alertBluetooth,
                 .lookingBeacon:
                return "incidence_key_turn_on_beacon_flash".localized()
            case .selectionBeacon:
                return "incidence_key_turn_on_beacon_flash_detected".localized()
            default:
                return nil
            }
        }
    }
    
    var errorLabelText: String? {
        get {
            switch status {
            case .bluetoothFail:
                return "<span style='color:#737373'>" + "incidence_key_beacon_error_need_bluettoh".localized() + "</span>"
            case .missingBeacon:
                return "<span style='color:#737373'>" + "incidence_key_beacons_not_detected".localized() + "</span>"
            default:
                return nil
            }
        }
    }
    
    var continueButtonText: String? {
        get {
            switch status {
            case .bluetoothFail,
                 .missingBeacon:
                return "incidence_key_retry".localized()
            case .selectionBeacon:
                return "incidence_key_search_again".localized()
            default:
                return nil
            }
        }
    }
    
    var discardButtonText: String? {
        get {
            switch status {
            case .bluetoothFail:
                return "incidence_key_no_activate_now".localized()
            case .missingBeacon,
                 .selectionBeacon,
                 .lookingBeacon,
                 .alertBluetooth:
                return "incidence_key_omitir".localized()
            default:
                return nil
            }
        }
    }
    
    var errorImage: UIImage? {
        get {
            switch status {
            case .bluetoothFail:
                return UIImage.app( "bluetooth")
            case .missingBeacon:
                return UIImage.app( "info")
            default:
                return nil
            }
        }
    }
}
