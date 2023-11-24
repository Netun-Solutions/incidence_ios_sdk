//
//  CustomUISwitch.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import UIKit

class CustomUISwitch: UISwitch {
    
    @IBInspectable var offTint: UIColor? {
        didSet {
            self.tintColor = offTint
            self.layer.cornerRadius = self.frame.height / CGFloat(sqrt(Double(transform.a * transform.a + transform.c * transform.c))) / 2
            self.backgroundColor = offTint
        }
    }
    
    @IBInspectable var onTint: UIColor? {
        didSet {
            self.onTintColor = onTint
        }
    }
    
    func set(width: CGFloat, height: CGFloat) {
        
        let heightRatio = height / self.frame.height
        let widthRatio = width / self.frame.width

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
    }
}
