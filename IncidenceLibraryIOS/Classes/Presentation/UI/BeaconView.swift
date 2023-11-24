//
//  BeaconView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import UIKit

class BeaconView: UIView {
    
    private var imageView = UIImageView()
    private var textLabel = TextLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }

    public func configure(text: String) {
        textLabel.text = text
    }
    
    private func setUpUI() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.anchor(widthConstant: 50, heightConstant: 50)
        imageView.anchorCenterXToSuperview()
        imageView.anchorCenterYToSuperview()
        let image = UIImage.app( "Type=Yes")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor.app(.help500)
        
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.anchorCenterXToSuperview()
        textLabel.anchorCenterYToSuperview(constant: 30)
        textLabel.font = UIFont.app(.primaryRegular, size: 10)
        textLabel.textColor = UIColor.app(.help500)
        
        self.backgroundColor = UIColor.app(.white)
        self.anchor(widthConstant: 86, heightConstant: 86)
        self.layer.cornerRadius = 43
        self.layer.masksToBounds = true
    }
}
