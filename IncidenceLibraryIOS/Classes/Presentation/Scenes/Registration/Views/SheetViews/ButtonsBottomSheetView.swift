//
//  ButtonsBottomSheetView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import UIKit

enum AccountButtonsSheet {
    case deleteAccount
    case closeSession
    case notifications
}

protocol ButtonsBottomSheetDelegate: AnyObject {
    func firstButtonPressed(identifier: Any?)
    func secondButtonPressed(identifier: Any?)
}

final class ButtonsBottomSheetView: UIView {
  
    private weak var delegate: ButtonsBottomSheetDelegate?
    
    // MARK: - UI Elements
    let titleText = TextLabel()
    let descriptionText = TextLabel()
    let firstButton = MenuView()
    let secondButton = MenuView()
    
    var identifier: Any?
    
    private var onlyDescription = true
    required init(_ onlyDescription:Bool) {
        self.onlyDescription = onlyDescription
        super.init(frame: .zero)
        setUpUI()
    }
    
  
    lazy var contentStack: UIStackView = {
        
        if (onlyDescription)
        {
            let stack = UIStackView(arrangedSubviews: [descriptionText, firstButton, secondButton])
            stack.axis = .vertical
            stack.spacing = 48
            stack.setCustomSpacing(0, after: firstButton)
            return stack
        }
        else
        {
            let stack = UIStackView(arrangedSubviews: [titleText, descriptionText, firstButton, secondButton])
            stack.axis = .vertical
            stack.spacing = 48
            stack.spacing = 48
            stack.setCustomSpacing(0, after: firstButton)
            stack.setCustomSpacing(10, after: titleText)
            return stack
        }
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpUI()
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        setUpUI()
    }
    
    public func configure(delegate: ButtonsBottomSheetDelegate, title: String?, desc:String?, firstButtonText: String, secondButtonText: String, identifier: Any?) {
        self.delegate = delegate
        titleText.text = title
        descriptionText.text = desc
        firstButton.configure(text: firstButtonText)
        secondButton.configure(text: secondButtonText, color: .red)
        self.identifier = identifier
    }
  
    private func setUpUI() {
        self.backgroundColor = UIColor.app(.white)
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          contentStack.topAnchor.constraint(equalTo: topAnchor),
          contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
          contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
          contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        firstButton.heightAnchor.constraint(equalToConstant: 59).isActive = true
        firstButton.onTap { [weak self] in
            self?.delegate?.firstButtonPressed(identifier: self?.identifier)
        }
        secondButton.heightAnchor.constraint(equalToConstant: 59).isActive = true
        secondButton.onTap { [weak self] in
            self?.delegate?.secondButtonPressed(identifier: self?.identifier)
        }
        
        titleText.textColor = UIColor.app(.black600)
        titleText.numberOfLines = 0
        titleText.textAlignment = .center
        titleText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        titleText.font = UIFont.app(.primarySemiBold, size: 16)
        
        descriptionText.textColor = UIColor.app(.black600)
        descriptionText.numberOfLines = 0
        descriptionText.textAlignment = .center
        descriptionText.text = ""
        descriptionText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        descriptionText.font = UIFont.app(.primaryRegular, size: 16)
    }

}
