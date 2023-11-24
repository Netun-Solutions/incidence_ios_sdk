//
//  PrimaryButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

class PrimaryButton: UIButton {
    
    @IBInspectable var invertedColors: Bool = false {
        didSet {
            setUpBackground()
        }
    }

    open override var isEnabled: Bool{
        didSet {
            setUpBackground()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpUI()
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        setUpUI()
    }
    
    
    private func setUpUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = AppAppearance.BUTTON_RADIUS
        setUpBackground()
        self.titleLabel?.font = UIFont.app(.primarySemiBold, size: 16)
        
    }
    
    private func setUpBackground() {
        if isEnabled {
            self.backgroundColor = invertedColors ? UIColor.app(.white) : UIColor.app(.incidencePrimary)
            self.tintColor = invertedColors ? UIColor.app(.incidencePrimary) : UIColor.app(.white)
            self.setTitleColor(invertedColors ? UIColor.app(.incidencePrimary) : UIColor.app(.white), for: .normal)
        } else {
            self.backgroundColor = UIColor.app(.black200)
            self.tintColor = UIColor.app(.black400)
            self.setTitleColor(UIColor.app(.black400), for: .normal)
        }
    }
}
