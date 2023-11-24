//
//  DevicesCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import UIKit

class DevicesCell: UITableViewCell {

    static let reuseIdentifier = String(describing: DevicesCell.self)
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
        
        let image = UIImage.app("beacon")
        menuView.configure(text: "", iconImage: image, rightIcon: .arrow)
    }
    
    public func configure(with model: Beacon?) {
        if let model = model {
            if model.id! > 0 {
                let image = model.beaconType?.id == 1 ? UIImage.app( "beacon_smart") : UIImage.app( "beacon")
                menuView.configure(text: model.name ?? "", iconImage: image, rightIcon: .arrow)
            } else {
                menuView.configure(text: "add_new_device".localized(), color: .blue, rightIcon: .add)
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
