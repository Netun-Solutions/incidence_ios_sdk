//
//  VehicleCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import UIKit

class VehicleCell: UITableViewCell {

    static let reuseIdentifier = String(describing: VehicleCell.self)
    static let height = CGFloat(59)
    
    let menuView = MenuView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.addSubview(menuView)
        menuView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
    }
    
    public func configure(with model: Vehicle?) {
        if let model = model {
            let image = model.beacon != nil ? UIImage.app( "Type=Yes") : UIImage.app( "Type=No")
            menuView.configure(text: model.getName(), iconImage: image, rightIcon: .arrow)
        } else {
            menuView.configure(text: "Añadir nuevo vehículo", color: .blue, rightIcon: .add)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}
