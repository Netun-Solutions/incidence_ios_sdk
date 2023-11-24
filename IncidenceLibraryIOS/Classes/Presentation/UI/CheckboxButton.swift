//
//  CheckboxButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import UIKit

public class CheckboxButton: UIButton {
    public override var isSelected: Bool {
        didSet {
            updateCheckbox()
        }
    }
    
    override init(frame: CGRect) {
        
         super.init(frame: frame)
     }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
        
    }
    
    public func configure() {
        setUpUI()
    }
    
    func updateCheckbox() {
        let imageName = isSelected ? "checkbox_on" : "checkbox_off"
        let image = UIImage.app( imageName)
        setImage(image, for: .normal)
    }
    
    private func setUpUI() {
        isSelected = false
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        updateCheckbox()
    }
    
    @objc func buttonPressed(_ sender:UIButton) {
        isSelected = !isSelected
    }
}
