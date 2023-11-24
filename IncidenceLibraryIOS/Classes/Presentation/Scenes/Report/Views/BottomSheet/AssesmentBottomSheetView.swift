//
//  AssesmentBottomSheetView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 1/6/21.
//

import UIKit

final class AssesmentBottomSheetView: UIView {
  
    private weak var delegate: ButtonsBottomSheetDelegate?
    
    // MARK: - UI Elements
    let titleText = TextLabel()
    let descriptionText = UILabel()
    let firstButton = PrimaryButton()
    let secondButton = TextButton()
    
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
    
    public func configure(delegate: ButtonsBottomSheetDelegate, title: String, description: String, firstButtonText: String, secondButtonText: String, identifier: Any?) {
        self.delegate = delegate
        titleText.text = title
        descriptionText.text = description
        descriptionText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        firstButton.setTitle(firstButtonText, for: .normal)
        secondButton.setTitle(secondButtonText, for: .normal)
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
        
        firstButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(firstButtonPressed))
        firstButton.addGestureRecognizer(tap)
  
        secondButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(secondButtonPressed))
        secondButton.addGestureRecognizer(tap1)
  
        
        titleText.textColor = UIColor.app(.black600)
        titleText.numberOfLines = 0
        titleText.textAlignment = .center
        titleText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        titleText.font = UIFont.app(.primarySemiBold, size: 16)
        
        descriptionText.textColor = UIColor.app(.black500)
        descriptionText.numberOfLines = 0
        descriptionText.textAlignment = .center
        descriptionText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        descriptionText.font = UIFont.app(.primaryRegular, size: 16)
    }

    @objc func firstButtonPressed() {
        self.delegate?.firstButtonPressed(identifier: self.identifier)
    }
    
    @objc func secondButtonPressed() {
        self.delegate?.secondButtonPressed(identifier: self.identifier)
    }
}
