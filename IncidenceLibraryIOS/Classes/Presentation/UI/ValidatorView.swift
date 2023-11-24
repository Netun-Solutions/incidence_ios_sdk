//
//  ValidatorView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//

import UIKit

protocol ValidatorViewDelegate: AnyObject {
    func validatorViewCompletedCode(view: ValidatorView )
}

class ValidatorView: UIView {
    
    weak var delegate: ValidatorViewDelegate?
    
    private let errorLabel = UILabel()
    
    private let firstView = UIView()
    private let secondView = UIView()
    private let thirdView = UIView()
    private let fourthView = UIView()
    
    private let firstTextField = UITextField()
    private let secondTextField = UITextField()
    private let thirdTextField = UITextField()
    private let fourthTextField = UITextField()
    
    private lazy var elements: [UITextField: UIView] = [firstTextField:firstView, secondTextField:secondView, thirdTextField:thirdView, fourthTextField:fourthView]
    
    private let stackView = UIStackView()
    
    public var status: InputViewStatus = .enabled {
        didSet {
            elements.forEach { (textField, view) in
                setUpState(for: view, state: status)
            }
        }
    }
    
    func value() -> String
    {
        return firstTextField.text! + secondTextField.text! + thirdTextField.text! + fourthTextField.text!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpUI()
    }
    

    private func setUpUI() {
        self.backgroundColor = .clear
       
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        self.addSubview(stackView)

        setUpView(view: firstView, textField: firstTextField)
        setUpView(view: secondView, textField: secondTextField)
        setUpView(view: thirdView, textField: thirdTextField)
        setUpView(view: fourthView, textField: fourthTextField)
        
        stackView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
 
        
        self.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = UIColor.app(.errorPrimary)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.app(.primaryRegular, size: 12)
        errorLabel.anchor(top: stackView.bottomAnchor, bottom: self.bottomAnchor, topConstant: 5, bottomConstant: 0)
        errorLabel.anchorCenterXToSuperview()
        
    }
    
    private func setUpView(view: UIView, textField: UITextField) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        textField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "-", attributes: [
            .foregroundColor: UIColor.app(.black500)!,
            .font: UIFont.app(.primaryRegular, size: 16)!
        ])
        textField.textColor = UIColor.app(.black)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        view.layer.borderWidth = 1
        view.layer.cornerRadius = AppAppearance.INPUT_RADIUS
        view.layer.borderColor = UIColor.app(.white)?.cgColor
        view.backgroundColor = UIColor.app(.white)
        textField.delegate = self
        
        stackView.addArrangedSubview(view)
    }
    
    private func setUpState(for view: UIView, state: InputViewStatus) {
        switch state {
        case .disabled, .enabled, .editable:
            view.layer.borderColor = UIColor.app(.white)?.cgColor
            errorLabel.isHidden = true
        case .active:
            view.layer.borderColor = UIColor.app(.incidence400)?.cgColor
            errorLabel.isHidden = true
        case .error(let text):
            view.layer.borderColor = UIColor.app(.errorPrimary)?.cgColor
            errorLabel.text = text
            errorLabel.isHidden = false
        }
    }
    
    public func startAsFirstResponder() {
        firstTextField.becomeFirstResponder()
    }
    
    public func clear()
    {
        firstTextField.text = ""
        secondTextField.text = ""
        thirdTextField.text = ""
        fourthTextField.text = ""
        status = .enabled
    }
}

extension ValidatorView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        status = .enabled
        if let view = elements[textField] {
            setUpState(for: view, state: .active)
        }
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let view = elements[textField] {
            setUpState(for: view, state: .enabled)
        }
        textField.attributedPlaceholder = NSAttributedString(string: "-", attributes: [
            .foregroundColor: UIColor.app(.black500)!,
            .font: UIFont.app(.primaryRegular, size: 16)!
        ])
        
        let text = value()
        if text.count == 4 {
            delegate?.validatorViewCompletedCode(view: self)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if updatedText.count > 0 {
                textField.text = string
                textField.resignFirstResponder()
                if textField == firstTextField {
                    secondTextField.becomeFirstResponder()
                } else if textField == secondTextField {
                    thirdTextField.becomeFirstResponder()
                } else if (textField == thirdTextField) {
                    fourthTextField.becomeFirstResponder()
                }
            }
            
        }
        
        return false
    }
    
}
