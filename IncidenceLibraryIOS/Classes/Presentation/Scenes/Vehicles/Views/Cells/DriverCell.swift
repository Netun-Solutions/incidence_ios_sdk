//
//  DriverCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/5/21.
//

import UIKit

class DriverCell: UITableViewCell {

    static let reuseIdentifier = String(describing: DriverCell.self)
    static let height = CGFloat(78)
    
    let fieldView = FieldView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.addSubview(fieldView)
        fieldView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    public func configure(with driver: Driver, isUserPrimary: Bool)
    {
        let title = driver.isTypePrimary() ? "driver_primary".localized() : "driver_secondary".localized()
        
        
        let user = Core.shared.getUser()
        var isDriverUser = false
        if let userId = user?.id, userId == driver.id {
            isDriverUser = true
        }
        
        if (driver.isTypePrimary())
        {
            //no se edita
            fieldView.configure(titleText: title, valueText: driver.name ?? "")
        }
        else
        {
            if (isUserPrimary || isDriverUser)
            {
                fieldView.configure(titleText: title, valueText: driver.name ?? "", hasEditIcon: true)
            }
            else
            {
                fieldView.configure(titleText: title, valueText: driver.name ?? "")
            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}
