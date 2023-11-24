//
//  TextFieldWithSelectView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 27/4/21.
//

import UIKit

protocol TextFieldWithSelectViewDelegate: AnyObject {
    func textFieldView(view: TextFieldWithSelectView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func dropTextFieldShouldClear(_ textField: UITextField)
}

class TextFieldWithSelectView: UIView {
    
    weak var delegate: TextFieldWithSelectViewDelegate?
    
    var maxLength = -1
    var constraintTitle = NSLayoutConstraint()
    var constraintTitle2 = NSLayoutConstraint()
    
    @IBInspectable lazy var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable lazy var placeholder: String? = nil {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [
                .foregroundColor: UIColor.app(.black500)!,
                .font: UIFont.app(.primaryRegular, size: 16)!
            ])
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
                editIcon.anchor(right: containerView.rightAnchor, rightConstant: 16, widthConstant: 24, heightConstant: 24)
            }
        }
    }
    
   
    private let containerView = UIView()
    private let textField = UITextField()
    private let selectTextField = UITextField()
    private let dividerView = UIView()
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
    
    public var status: InputViewStatus = .enabled {
        didSet {
            setUpStatus()
        }
    }
    
    public var valueOption: String? {
        get {
            return selectTextField.text
        }
    }
    
    public var value: String? {
        get {
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
            constraintTitle.isActive = !titleLabel.isHidden
            constraintTitle2.isActive = !constraintTitle.isActive
            
            if showSuccess {
                successIcon.isHidden = false
            } else if showEditable {
                editIcon.isHidden = false
            }
        }
    }
    
    public lazy var pickerValue: String? = {
        return selectTextField.text
    }()
    
    public var selectedOption: String?
    private var options: [String]?
    private var pickerView = ToolbarPickerView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpUI()
    }
    
    public func configure(options: [String]) {
        self.options = options
        selectTextField.text = options.first
    }
    

    private func setUpUI() {
        self.backgroundColor = .clear
        
        self.addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(titleLabel)
        containerView.addSubview(selectTextField)
        containerView.addSubview(dividerView)
        self.addSubview(errorLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = AppAppearance.INPUT_RADIUS
        containerView.backgroundColor = UIColor.app(.white)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.app(.black)
        textField.font = UIFont.app(.primaryRegular, size: 16)
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.font = UIFont.app(.primaryRegular, size: 16)
        let rightView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 30)))
        let clearButton = UIButton(frame: CGRect(origin: CGPoint(x: 4, y: 0), size: CGSize(width: 40, height: 24)))
        //clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 14)
        clearButton.setImage(UIImage.app( "Delete-1")!, for: .normal)
        rightView.addSubview(clearButton)
        textField.rightView = rightView
        clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        textField.clearButtonMode = .never
        textField.rightViewMode = .whileEditing

        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.app(.black500)
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.app(.primaryRegular, size: 12)
        titleLabel.isHidden = true
        
        selectTextField.translatesAutoresizingMaskIntoConstraints = false
        selectTextField.tintColor = UIColor.app(.black600)
        selectTextField.font = UIFont.app(.primaryRegular, size: 16)
        let imageView = UIImageView(image: UIImage.app( "Direction=Up"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        selectTextField.rightView = imageView
        selectTextField.textAlignment = .center
        selectTextField.rightViewMode = .always
        selectTextField.textColor = UIColor.app(.black)
        selectTextField.inputView = pickerView
        selectTextField.inputAccessoryView = pickerView.toolbar
        selectTextField.delegate = self
        selectTextField.tintColor = .clear
        
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor.app(.black200)
        
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
        setUpPickerView()
    }
    
    private func setUpConstraints() {
        containerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        selectTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        selectTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        selectTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        selectTextField.widthAnchor.constraint(equalToConstant: 54).isActive = true
 
        dividerView.leftAnchor.constraint(equalTo: selectTextField.rightAnchor, constant: 8).isActive = true
        dividerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        dividerView.widthAnchor.constraint(equalToConstant: 1).isActive = true
    
        
        titleLabel.leftAnchor.constraint(equalTo: dividerView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        
        textField.leftAnchor.constraint(equalTo: dividerView.rightAnchor, constant: 16).isActive = true
        textField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        constraintTitle2 = textField.topAnchor.constraint(equalTo: containerView.topAnchor)
        constraintTitle2.isActive = true
        constraintTitle = textField.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        constraintTitle.isActive = true
        textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    private func setUpPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.toolbarDelegate = self
        pickerView.reloadAllComponents()
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
        
        
    }
    
    public func setMaxLength(_ length: Int) {
        maxLength = length
    }
    
    public func startAsFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    @objc func togglePicker() {
        
    }
    
    @objc func clearClicked() {
        textField.text = ""
        textField.becomeFirstResponder()
        titleLabel.isHidden = true
        constraintTitle.isActive = !titleLabel.isHidden
        constraintTitle2.isActive = !constraintTitle.isActive
        
        delegate?.dropTextFieldShouldClear(textField)
    }
}

extension TextFieldWithSelectView: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        selectTextField.text = options?[row]
        textField.becomeFirstResponder()
    }
    
    func didTapCancel() {
        selectTextField.resignFirstResponder()
    }
}

extension TextFieldWithSelectView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options?[row]
    }
}

extension TextFieldWithSelectView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.status = .active
        if (showSuccess) {
            successIcon.isHidden = true
        } else if showEditable {
            editIcon.isHidden = true
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        titleLabel.isHidden = true
        constraintTitle.isActive = !titleLabel.isHidden
        constraintTitle2.isActive = !constraintTitle.isActive
        return true
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
        
        if textField == selectTextField {
            return false
        }
        
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
                constraintTitle.isActive = !titleLabel.isHidden
                constraintTitle2.isActive = !constraintTitle.isActive
            }
            
            return delegate?.textFieldView(view: self, textfield: textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        }
        else
        {
            return false
        }
    }
}
