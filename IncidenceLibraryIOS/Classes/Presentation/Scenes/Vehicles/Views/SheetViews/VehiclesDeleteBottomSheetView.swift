//
//  VehiclesDeleteBottomSheetView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import UIKit

final class VehiclesDeleteBottomSheetView: UIView {
  
    private weak var delegate: ButtonsBottomSheetDelegate?
    
    // MARK: - UI Elements
    let titleText = TextLabel()
    let firstButton = MenuView()
    let secondButton = MenuView()
    
    var identifier: Any?
  
    lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleText, firstButton, secondButton])
        stack.axis = .vertical
        stack.spacing = 48
        stack.setCustomSpacing(0, after: firstButton)
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
    
    public func configure(delegate: ButtonsBottomSheetDelegate, title: String, firstButtonText: String, secondButtonText: String, identifier: Any?) {
        self.delegate = delegate
        titleText.attributedText = title.htmlAttributed(using: UIFont.app(.primaryRegular, size: 16)!)
        titleText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
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
        titleText.font = UIFont.app(.primaryRegular, size: 16)
    }

}
