//
//  RegistrationStepsViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//

import Foundation

enum RegistrationSteps {
    case personalData
    case carAndInsurance
    case sync
}

class RegistrationStepsViewModel: IABaseViewModel {
    
    let completedSteps: [RegistrationSteps]
    public var origin: RegistrationOrigin
    let presentOnboarding:Bool
    

    internal init(completedSteps: [RegistrationSteps], origin: RegistrationOrigin, presentOnboarding: Bool = true) {
        self.completedSteps = completedSteps
        self.origin = origin
        self.presentOnboarding = presentOnboarding
    }
    
    public override var navigationTitle: String? {
        get {
            if completedSteps.isEmpty {
                return "create_account".localized()
            } else if completedSteps.count == 1 {
                return "create_account_step2".localized()
            }
            return "create_account_step3".localized()
        }
        set { }
    }
    
    lazy var personalDataLabelText: String = {
        return "create_account_step1".localized()
    }()
    
    lazy var carAndInsuranceLabelText: String = {
        return "create_account_step2".localized()
    }()
    
    lazy var syncLabelText: String = {
        return "create_account_step3".localized()
    }()
    
    
    lazy var createAccounButtonText: String = {
        if completedSteps.isEmpty {
            return "create_one_account".localized()
        } else if completedSteps.count == 1 {
            return "vehicle_data".localized()
        }
        return "search_baliza".localized()
    }()
    
    lazy var signInLabelText: String? = {
        return completedSteps.isEmpty ? "already_have_account".localized() : nil
    }()
    
    lazy var signInButtonText: String? = {
        if completedSteps.isEmpty {
            return "sign_in".localized()
        } else if completedSteps.count == 1 {
            return nil
        }
        return "omitir".localized()
    }()
}
