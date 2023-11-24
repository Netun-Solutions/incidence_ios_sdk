//
//  TextFieldView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

enum InputViewStatus {
    case disabled
    case enabled
    case active
    case error(text: String)
    case editable
}

protocol TextFieldViewDelegate: AnyObject {
    func textFieldView(view: TextFieldView, textfield: UITextField, status: InputViewStatus)
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldShouldBeginEditing(view: TextFieldView) -> Bool
    func textFieldShouldEndEditing(view: TextFieldView) -> Bool
    func textFieldShouldClear(view: TextFieldView)
}

extension TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, status: InputViewStatus) { }
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }
    func textFieldShouldBeginEditing(view: TextFieldView) -> Bool { return true }
    func textFieldShouldEndEditing(view: TextFieldView) -> Bool { return true }
    func textFieldShouldClear(view: TextFieldView) {}
}

class TextFieldView: UIView {
    
    var maxLength = -1
    
    @IBInspectable lazy var placeholder: String? = nil {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [
                .foregroundColor: UIColor.app(.black500)!,
                .font: UIFont.app(.primaryRegular, size: 16)!
            ])
        }
    }
    
    @IBInspectable lazy var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var showSuccess: Bool = false {
        didSet {
            if self.showSuccess {
                containerView.addSubview(successIcon)
                successIcon.anchorCenterYToSuperview()
                successIcon.anchor(right: containerView.rightAnchor, rightConstant: 16, widthConstant: 24, heightConstant: 24)
            }
        }
    }
    
    @IBInspectable var showEditable: Bool = false {
        didSet {
            if self.showEditable {
                containerView.addSubview(editIcon)
                editIcon.anchorCenterYToSuperview()
                editIcon.anchor(right: containerView.rightAnchor, rightConstant: 16, widthConstant: 28, heightConstant: 28)
            }
        }
    }
    
    @IBInspectable var showDelete: Bool = false {
        didSet {
            if self.showDelete {
                containerView.addSubview(deleteIcon)
                deleteIcon.anchorCenterYToSuperview()
                deleteIcon.anchor(right: containerView.rightAnchor, rightConstant: 16, widthConstant: 24, heightConstant: 24)
            }
        }
    }
    
    weak var delegate: TextFieldViewDelegate?
    
    private let containerView = UIView()
    private let textField = PaddingTextView()
    private let titleLabel = UILabel()
    private let errorLabel = UILabel()
    private lazy var successIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.app( "Check")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.app(.success)
        imageView.isHidden = true
        
        return imageView
    }()
    
    private lazy var editIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.app( "Edit")
        imageView.isHidden = true
        
        return imageView
    }()
    
    private lazy var deleteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.app( "Delete")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.app(.errorPrimary)
        
        return imageView
    }()
    
    public var status: InputViewStatus = .enabled {
        didSet {
            setUpStatus()
        }
    }
    
    public var value: String? {
        get {
            if (textField.keyboardType == .numberPad || textField.keyboardType == .phonePad) {
                return textField.text?.replacingOccurrences(of: " ", with: "")
            }
            return textField.text
        }
        set {
            textField.text = newValue
            
            var hidden = false
            if (newValue == nil) {
                hidden = true
            }
            else if (newValue?.isEmpty ?? false) {
                hidden = true
            }
            titleLabel.isHidden = hidden
            if showSuccess {
                successIcon.isHidden = false
            } else if showEditable {
                editIcon.isHidden = false
            }
        }
    }
    
    public var isEnabled: Bool{
        get {
            return self.isUserInteractionEnabled
        }
        set {
            self.isUserInteractionEnabled = newValue
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpUI()
    }
    
    public func startAsFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    public func setKeyboard(_ type: UIKeyboardType) {
        textField.keyboardType = type
        if (type == .phonePad)
        {
            textField.addTarget(self, action: #selector(textFieldEdidtingDidChange(_ :)), for: .editingChanged)
        }
        else {
            textField.removeTarget(self, action: #selector(textFieldEdidtingDidChange(_ :)), for: .editingChanged)
        }
        
        if (type == .emailAddress)
        {
            textField.autocorrectionType = .no
        }
    }
    
    public func setMaxLength(_ length: Int) {
        maxLength = length
    }
    
    public func setUpDatePicker() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel".localized(), style: .done, target: self, action: #selector(onClickCancelButton))
        let doneButton = UIBarButtonItem(title: "accept".localized(), style: .done, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
        let cLocale = Locale(identifier: Core.shared.getLanguage())
        
        let datePickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        datePickerView.datePickerMode = .date
        datePickerView.locale = cLocale
        textField.inputView = datePickerView
    }

    @objc func onClickDoneButton() {
        self.endEditing(true)
        
        if let datePicker:UIDatePicker = textField.inputView as? UIDatePicker
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            textField.text = dateFormatter.string(from: datePicker.date)
            
            //no se llaman los delegates
            titleLabel.isHidden = false
            delegate?.textFieldView(view: self, textfield: textField, shouldChangeCharactersIn: NSRange.init(), replacementString: "")
        }
    }
    
    @objc func onClickCancelButton() {
        self.endEditing(true)
    }
    
    
    private func setUpUI() {
        self.backgroundColor = .clear
        
        self.addSubview(containerView)
        self.addSubview(textField)
        self.addSubview(titleLabel)
        self.addSubview(errorLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = AppAppearance.INPUT_RADIUS
        containerView.backgroundColor = UIColor.app(.white)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.app(.black)
        textField.delegate = self
        textField.font = UIFont.app(.primaryRegular, size: 16)
        let clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 24)))
        clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 14)
        clearButton.setImage(UIImage.app( "Delete-1")!, for: .normal)
        textField.rightView = clearButton
        clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        textField.clearButtonMode = .never
        textField.rightViewMode = .whileEditing
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.app(.black500)
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.app(.primaryRegular, size: 12)
        titleLabel.isHidden = true
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = UIColor.app(.errorPrimary)
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont.app(.primaryRegular, size: 12)
        errorLabel.anchor(top: containerView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, topConstant: 5, leftConstant: 14, rightConstant: 14)
        
        if showSuccess {
            containerView.addSubview(successIcon)
            successIcon.anchorCenterYToSuperview()
            successIcon.anchor(right: containerView.rightAnchor, rightConstant: 16, widthConstant: 24, heightConstant: 24)
        }
        
        if showEditable {
            containerView.addSubview(editIcon)
            editIcon.anchorCenterYToSuperview()
            editIcon.anchor(right: containerView.rightAnchor, rightConstant: 16, widthConstant: 24, heightConstant: 24)
        }
        
        setUpStatus()
        setUpConstraints()
    }
    
    @objc func textFieldEdidtingDidChange(_ textField :UITextField) {
        textField.text!.removeAll { !("0"..."9" ~= $0) }
            let text = textField.text!
        for index in text.indices.reversed() {
                if text.distance(from: text.startIndex, to: index).isMultiple(of: 3) &&
                    index != text.startIndex &&
                    index != text.endIndex {
                    textField.text!.insert(" ", at: index)
                }
            }
    }
    
    private func setUpConstraints() {
        containerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        textField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        textField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        
    }
    
    private func setUpStatus() {
        switch status {
        case .disabled, .enabled, .editable:
            containerView.layer.borderColor = UIColor.app(.white)?.cgColor
            errorLabel.isHidden = true
        case .active:
            containerView.layer.borderColor = UIColor.app(.incidence400)?.cgColor
            errorLabel.isHidden = true
        case .error(let text):
            containerView.layer.borderColor = UIColor.app(.errorPrimary)?.cgColor
            errorLabel.text = text
            errorLabel.isHidden = false
        }
        
        delegate?.textFieldView(view: self, textfield: textField, status: status)
    }
    
    @objc func clearClicked() {
        textField.text = ""
        textField.becomeFirstResponder()
        titleLabel.isHidden = true
        delegate?.textFieldShouldClear(view: self)
    }
    
    func setContainerBackgroundColor(color: UIColor)
    {
        containerView.backgroundColor = color
        containerView.layer.borderColor = color.cgColor
    }
    
    func setTextFieldColor(color: UIColor)
    {
        textField.textColor = color
    }
    
    func setDeleteImage(image: UIImage?, tintColor: UIColor? = nil)
    {
        deleteIcon.image = image
        
        if let color = tintColor {
            deleteIcon.tintColor = color
        }
    }
    
    func disablePadding()
    {
        if title == nil || title?.count == 0 {
            textField.disablePadding()
        }
    }
}

extension TextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.status = .active
        if (showSuccess) {
            successIcon.isHidden = true
        } else if showEditable {
            editIcon.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.status = .enabled
        if (showSuccess && textField.text != "") {
            successIcon.isHidden = false
        } else if (showEditable && textField.text != "") {
            editIcon.isHidden = false
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var canContinue = false
        if (maxLength == -1)
        {
            canContinue = true
        }
        else
        {
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            canContinue = newString.length <= maxLength
        }
        
        if (canContinue)
        {
            if let text = textField.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                titleLabel.isHidden = updatedText.count == 0
            }
            
            return delegate?.textFieldView(view: self, textfield: textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        }
        else
        {
            return false
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        titleLabel.isHidden = true
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing(view: self) ?? true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldEndEditing(view: self) ?? true
    }
}
