//
//  VehicleCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 28/5/21.
//

import UIKit

class VehicleSelectionCell: UITableViewCell {

    static let reuseIdentifier = String(describing: VehicleSelectionCell.self)
    static let height = CGFloat(96)
    
    var identifier: Any?
    
    let carView = CarSelectionView()
    let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.addSubview(carView)
        contentView.addSubview(separatorView)
        carView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 24, rightConstant: 24)
        separatorView.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, leftConstant: 24, bottomConstant: 0, rightConstant: 24, heightConstant: 1)
        
        separatorView.backgroundColor = UIColor.app(.black300)
    }
    
    public func configure(vehicle: Vehicle, isSelected selected: Bool) {
        carView.configure(vehicle: vehicle, type: selected ? .selected : nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
}
