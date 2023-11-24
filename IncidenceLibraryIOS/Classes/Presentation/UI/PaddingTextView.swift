//
//  PaddingTextView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 23/4/21.
//

import UIKit

class PaddingTextView: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpUI()
    }
    
    private func setUpUI() {
        self.font = UIFont.app(.primaryRegular, size: 16)
    }

    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 36);
    var paddingTop = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 36);
    var paddingDisabled = false
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if (paddingDisabled)
        {
            return bounds.inset(by: padding)
        }
        return text?.count ?? 0 > 0 ? bounds.inset(by: paddingTop) : bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if (paddingDisabled)
        {
            return bounds.inset(by: padding)
        }
        return text?.count ?? 0 > 0 ? bounds.inset(by: paddingTop) : bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if (paddingDisabled)
        {
            return bounds.inset(by: padding)
        }
        return text?.count ?? 0 > 0 ? bounds.inset(by: paddingTop) : bounds.inset(by: padding)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)

        return originalRect.offsetBy(dx: -8, dy: 0)
    }
    
    public func disablePadding()
    {
        paddingDisabled = true
    }
}
