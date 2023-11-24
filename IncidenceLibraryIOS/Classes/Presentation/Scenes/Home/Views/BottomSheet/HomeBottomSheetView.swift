//
//  HomeBottomSheetView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/5/21.
//

import UIKit

final class HomeBottomSheetView: UIView {
  
    private weak var delegate: ButtonsBottomSheetDelegate?
    
    // MARK: - UI Elements
    let titleText = TextLabel()
    let descriptionText = TextLabel()
    let firstButton = MenuView()
    let secondButton = MenuView()
    public var viewController: BottomSheetViewController?
    var identifier: Any?
  
    lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleText, descriptionText, firstButton, secondButton])
        stack.axis = .vertical
        stack.spacing = 48
        stack.setCustomSpacing(0, after: firstButton)
        stack.setCustomSpacing(10, after: titleText)
        return stack
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpUI()
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        setUpUI()
    }
    
    public func configure(delegate: ButtonsBottomSheetDelegate, title: String, description: String, firstButtonText: String, firstButtonTextColor: MenuViewColors? = nil, secondButtonText: String, secondButtonTextColor: MenuViewColors? = nil, identifier: Any?) {
        self.delegate = delegate
        titleText.text = title
        
        let newDesc = description.replacingOccurrences(of: "\n", with: "<br />")
        descriptionText.attributedText = newDesc.htmlAttributed(using: UIFont.app(.primaryRegular, size: 16)!)
        descriptionText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        
        if let color = firstButtonTextColor {
            firstButton.configure(text: firstButtonText, color: color)
        } else {
            firstButton.configure(text: firstButtonText)
        }
        if let color = secondButtonTextColor {
            secondButton.configure(text: secondButtonText, color: color)
        } else {
            secondButton.configure(text: secondButtonText)
        }
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
            if let vc = self?.viewController {
                vc.dismiss(animated: true, completion: nil)
            }
            self?.delegate?.firstButtonPressed(identifier: self?.identifier)
        }
        secondButton.heightAnchor.constraint(equalToConstant: 59).isActive = true
        secondButton.onTap { [weak self] in
            if let vc = self?.viewController {
                vc.dismiss(animated: true, completion: nil)
            }
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
        descriptionText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        descriptionText.font = UIFont.app(.primaryRegular, size: 16)
    }

}
