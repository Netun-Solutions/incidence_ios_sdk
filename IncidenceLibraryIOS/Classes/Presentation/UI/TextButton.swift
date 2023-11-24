//
//  TextButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 23/4/21.
//

import UIKit

class TextButton: UIButton {
    
    @IBInspectable var invertedColors: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpUI()
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        setUpUI()
    }
    
    private func setUpUI() {
        self.titleLabel?.font = UIFont.app(.primarySemiBold, size: 16)
        
        setTitleColor(UIColor.app(.incidencePrimary), for: .normal)
    }
}
