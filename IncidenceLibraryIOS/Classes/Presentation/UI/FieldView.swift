//
//  FieldView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import UIKit

class FieldView: UIView {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let separatorView = UIView()
    private var showEditIcon = false
    
    private lazy var tooltipButton: TooltipButton = {
       return TooltipButton()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }
    
    public func configure(titleText: String) {
        configure(titleText: titleText, valueText: "", tooltipText: nil)
    }
    
    public func configure(titleText: String, valueText: String) {
        configure(titleText: titleText, valueText: valueText, tooltipText: nil)
    }
    
    public func configure(titleText: String, valueText: String, tooltipText: String? = nil, hasEditIcon: Bool? = false) {
        titleLabel.text = titleText
        valueLabel.text = valueText
        setTooltipText(tooltipText)
        showEditIcon = hasEditIcon ?? false
        
        arrowImageView.isHidden = !showEditIcon
        
        if (showEditIcon)
        {
            valueLabel.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: arrowImageView.leftAnchor, topConstant: 4, leftConstant: 40, bottomConstant: 16, rightConstant: 24)
        }
        else
        {
            valueLabel.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 4, leftConstant: 40, bottomConstant: 16, rightConstant: 24)
        }
    }

    
    private func setUpUI() {
        backgroundColor = .clear
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0)
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: 24).isActive = true
        titleLabel.textColor = UIColor.app(.black500)
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.app(.primaryRegular, size: 12)
        
        self.addSubview(arrowImageView)
        arrowImageView.anchorCenterYToSuperview(constant: -1)
        arrowImageView.anchor(right: self.rightAnchor, rightConstant: 40, widthConstant: 24, heightConstant: 24)
        
        self.addSubview(valueLabel)
        valueLabel.textColor = UIColor.app(.black600)
        valueLabel.numberOfLines = 1
        valueLabel.font = UIFont.app(.primaryRegular, size: 16)
        
        
        self.addSubview(separatorView)
        separatorView.backgroundColor = UIColor.app(.black300)
        separatorView.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, leftConstant: 24, bottomConstant: 0, rightConstant: 24, heightConstant: 1)
    }
    
    func setText(_ valueText: String)
    {
        valueLabel.text = valueText
    }
    
    func setTooltipText(_ tooltipText: String? = nil)
    {
        if let text = tooltipText {
            tooltipButton.configure(text: text)
            self.addSubview(tooltipButton)
            tooltipButton.anchor(left: titleLabel.rightAnchor, leftConstant: 4, widthConstant: 24, heightConstant: 24)
            tooltipButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        }
    }
    
    func removeTooltipText() {
        tooltipButton.removeFromSuperview()
    }
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.app( "icon_edit")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
}
