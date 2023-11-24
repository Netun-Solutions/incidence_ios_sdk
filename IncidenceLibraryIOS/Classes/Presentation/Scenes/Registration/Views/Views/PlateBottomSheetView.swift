//
//  PlateBottomSheetView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//

import UIKit

protocol PlateBottomSheetDelegate: AnyObject {
    func cancelButtonPressed(id: Int)
    func continueButtonPressed(id: Int)
}

final class PlateBottomSheetView: UIView {
  
    private var id: Int = 0
    private weak var delegate: PlateBottomSheetDelegate?
    private var title:String?
    private var message:String?
    private var acceptTitle:String?
    private var cancelTitle:String?
    
    // MARK: - UI Elements
    let titleText = TextLabel()
    let messageText = TextLabel()
    let buttonContinue = PrimaryButton()
    let buttonCancel = TextButton()
  
    var contentStack = UIStackView()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        //setUpUI()
        let tapContinue = UITapGestureRecognizer(target: self, action: #selector(self.continueButtonPressed(_:)))
        buttonContinue.addGestureRecognizer(tapContinue)
        
        let tapCancel = UITapGestureRecognizer(target: self, action: #selector(self.cancelButtonPressed(_:)))
        buttonCancel.addGestureRecognizer(tapCancel)
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        //setUpUI()
        let tapContinue = UITapGestureRecognizer(target: self, action: #selector(self.continueButtonPressed(_:)))
        buttonContinue.addGestureRecognizer(tapContinue)
        
        let tapCancel = UITapGestureRecognizer(target: self, action: #selector(self.cancelButtonPressed(_:)))
        buttonCancel.addGestureRecognizer(tapCancel)
    }
    
    public func configure(id: Int, delegate: PlateBottomSheetDelegate) {
        self.id = id
        self.delegate = delegate
        self.title = "error_matricula_other_user".localized()
        self.message = nil
        self.acceptTitle = "continuar".localized()
        self.cancelTitle = "cancel".localized()
        
        setUpUI()
    }
    
    public func configure(id: Int, delegate: PlateBottomSheetDelegate, title:String?, message:String?, acceptTitle:String?, cancelTitle:String?) {
        self.id = id
        self.delegate = delegate
        self.title = title
        self.message = message
        self.acceptTitle = acceptTitle
        self.cancelTitle = cancelTitle
        
        setUpUI()
    }

  
  // MARK: - SSUL
  
    private func setUpUI() {
        self.backgroundColor = UIColor.app(.white)
        
        
        if let mensaje = self.message {
            if let cancel = self.cancelTitle {
                
                contentStack = UIStackView(arrangedSubviews: [titleText, messageText, buttonContinue, buttonCancel])
                contentStack.axis = .vertical
                contentStack.spacing = 48
                contentStack.setCustomSpacing(32, after: buttonContinue)
                
            }
            else
            {
                contentStack = UIStackView(arrangedSubviews: [titleText, messageText, buttonContinue])
                contentStack.axis = .vertical
                contentStack.spacing = 48
            }
        }
        else
        {
            if let cancel = self.cancelTitle {
                
                contentStack = UIStackView(arrangedSubviews: [titleText, buttonContinue, buttonCancel])
                contentStack.axis = .vertical
                contentStack.spacing = 48
                contentStack.setCustomSpacing(32, after: buttonContinue)
            }
            else
            {
                contentStack = UIStackView(arrangedSubviews: [titleText, buttonContinue])
                contentStack.axis = .vertical
                contentStack.spacing = 48
            }
        }
        
        
        
        addSubview(contentStack)
        
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
          contentStack.topAnchor.constraint(equalTo: topAnchor),
          contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
          contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
          contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        buttonContinue.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        titleText.textColor = UIColor.app(.black600)
        titleText.numberOfLines = 0
        titleText.textAlignment = .center
        titleText.text = self.title
        titleText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        if self.message != nil {
            titleText.font = UIFont.app(.primarySemiBold, size: 16)
        } else {
            titleText.font = UIFont.app(.primaryRegular, size: 16)
        }
        
        
        messageText.textColor = UIColor.app(.black500)
        messageText.numberOfLines = 0
        messageText.textAlignment = .center
        messageText.text = self.message
        messageText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        messageText.font = UIFont.app(.primaryRegular, size: 16)
        
        buttonContinue.setTitle(self.acceptTitle, for: .normal)
        buttonCancel.setTitle(self.cancelTitle, for: .normal)
    }
  
    @objc func cancelButtonPressed(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.cancelButtonPressed(id: self.id)
    }
    
    @objc func continueButtonPressed(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.continueButtonPressed(id: self.id)
    }
}
