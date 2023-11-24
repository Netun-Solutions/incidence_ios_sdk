//
//  CallBottomSheetView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 1/6/21.
//

import UIKit

final class CallBottomSheetView: UIView {
  
    private weak var delegate: ButtonsBottomSheetDelegate?
    private var identifier: Any?
    
    // MARK: - UI Elements
    let titleText = TextLabel()
    let descriptionText = TextLabel() 
    let firstButton = UIButton()
    let secondButton = SlidingButton()
    
    private var onlyTitle = false
    
    required init(_ onlyTitle:Bool) {
        self.onlyTitle = onlyTitle
        super.init(frame: .zero)
        setUpUI()
    }

    lazy var contentStack: UIStackView = {
        
        if (onlyTitle)
        {
            let stack = UIStackView(arrangedSubviews: [titleText])
            stack.axis = .vertical
            stack.spacing = 48
            stack.setCustomSpacing(10, after: titleText)
            return stack
        }
        else
        {
            let stack = UIStackView(arrangedSubviews: [titleText, descriptionText, firstButton, secondButton])
            stack.axis = .vertical
            stack.spacing = 48
            stack.setCustomSpacing(10, after: firstButton)
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
    
    public func configure(delegate: ButtonsBottomSheetDelegate, title: String, identifier: Any?) {
        self.delegate = delegate
        titleText.text = title
        
        self.identifier = identifier
    }
    
    public func configure(delegate: ButtonsBottomSheetDelegate, title: String, description: String, firstButtonText: String, secondButtonText: String, identifier: Any?) {
        self.delegate = delegate
        titleText.text = title
        descriptionText.attributedText = description.htmlAttributed(using: UIFont.app(.primaryRegular, size: 16)!)
        descriptionText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        descriptionText.textColor = UIColor.app(.black500)
        
        firstButton.backgroundColor = UIColor.app(.incidence100)
        firstButton.anchor(heightConstant: 64)
        firstButton.layer.cornerRadius = 32
        firstButton.layer.masksToBounds = true
        firstButton.setTitle(firstButtonText, for: .normal)
        firstButton.setTitleColor(UIColor.app(.incidence500), for: .normal)
        firstButton.titleLabel?.font = UIFont.app(.primaryRegular, size: 14)
        firstButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        firstButton.setImage(UIImage.app( "Phone-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        firstButton.tintColor = UIColor.app(.incidence500)
        
        secondButton.anchor(heightConstant: 64)
        secondButton.buttonCornerRadius = 32
        secondButton.buttonText = secondButtonText
        secondButton.dragPointColor = UIColor.app(.white)!
        secondButton.imageName = UIImage.app( "Direction=Right")!
        secondButton.delegate = self
        
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
        
        titleText.textColor = UIColor.app(.black600)
        titleText.numberOfLines = 0
        titleText.textAlignment = .center
        titleText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        titleText.font = UIFont.app(.primarySemiBold, size: 16)
        
        if (!onlyTitle)
        {
            descriptionText.textColor = UIColor.app(.black600)
            descriptionText.numberOfLines = 0
            descriptionText.textAlignment = .center
            descriptionText.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
            descriptionText.font = UIFont.app(.primaryRegular, size: 16)
            
            firstButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(firstButtonPressed))
            firstButton.addGestureRecognizer(tap)
        }
    }
    
    @objc func firstButtonPressed() {
        self.delegate?.firstButtonPressed(identifier: self.identifier)
    }
}

extension CallBottomSheetView: SlideButtonDelegate {
    func buttonStatus(status: String, sender: SlidingButton) {
        delegate?.secondButtonPressed(identifier: identifier)
    }
}
