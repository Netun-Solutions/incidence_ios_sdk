//
//  SignInViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import Foundation

enum SignInViewType {
    case email
    case telephone
}

class SignInViewModel: IABaseViewModel {
    
    let viewType: SignInViewType
    
    internal init(viewType: SignInViewType) {
        self.viewType = viewType
    }
    
    public override var navigationTitle: String? {
        get { return viewType == .email ? "sign_in_email".localized() : "sign_in_phone".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return viewType == .email ? "email_title".localized() : "phone_title".localized()
    }()
    
    lazy var inputTitleText: String = {
        return viewType == .email ? "email".localized() : "mobile_phone".localized()
    }()
    
    lazy var inputPlaceholderText: String = {
        return viewType == .email ? "lucia@gmail.com" : "666 666 666"
    }()
    
    lazy var continueButtonText: String = {
        return "sign_in".localized()
    }()
    
    lazy var switchButtonText: String = {
        return viewType == .email ? "sign_in_phone_change".localized() : "sign_in_email_change".localized()
    }()
    
    lazy var createAccountLabelText: String = {
        return "already_not_have_account".localized()
    }()
    
    lazy var createAccountButtonText: String = {
        return "create_new_account".localized()
    }()
}
