//
//  BadgeView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 13/5/21.
//

import UIKit

class BadgeView: UIView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }
    
    public func configure(titleText: String, badgeColor: UIColor?) {
        titleLabel.text = titleText
        self.backgroundColor = badgeColor
    }
    
    private func setUpUI() {
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 14)
        titleLabel.textColor = UIColor.app(.white)
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.app(.primarySemiBold, size: 12)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
    }
}
