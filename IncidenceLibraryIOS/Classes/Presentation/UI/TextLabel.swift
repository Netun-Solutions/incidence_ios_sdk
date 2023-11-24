//
//  TextLabel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 23/4/21.
//

import UIKit

class TextLabel: UILabel {
    
    @IBInspectable var isBold: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    private func setUpUI() {
        let size = self.font.pointSize
        self.font =  isBold ? UIFont.app(.primarySemiBold, size: size) : UIFont.app(.primaryRegular, size: size)
    }
}
