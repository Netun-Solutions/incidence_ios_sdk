//
//  CarSelectionView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/5/21.
//

import UIKit
import Kingfisher

enum CarSelectionViewType {
    case arrow
    case arrowRight
    case selected
}

class CarSelectionView: UIView {
    
    var identifier: Any?
    
    private var vehicleImageView = UIImageView()
    private var plateLabel = UILabel()
    private var nameLabel = UILabel()
    private var stackView = UIStackView()
    lazy var rightIconImageView: UIImageView = { return UIImageView() }()
    lazy var beaconImageView: UIImageView = { return UIImageView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpUI()
    }
    
    private func setUpUI() {
        addSubview(vehicleImageView)
        vehicleImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, widthConstant: 40, heightConstant: 40)
        
        addSubview(plateLabel)
        plateLabel.anchor(top: vehicleImageView.topAnchor, left: vehicleImageView.rightAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, rightConstant: 0)
        
        addSubview(stackView)
        stackView.anchor(top: plateLabel.bottomAnchor, left: vehicleImageView.rightAnchor, topConstant: 2, leftConstant: 10)
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(nameLabel)
        stackView.insertArrangedSubview(beaconImageView, at: 0)
        
        plateLabel.font = UIFont.app(.primarySemiBold, size: 14)
        plateLabel.textColor = UIColor.app(.black400)
        nameLabel.font = UIFont.app(.primarySemiBold, size: 20)
        nameLabel.textColor = UIColor.app(.black600)
    }
    
    public func configure(vehicle: Vehicle, type: CarSelectionViewType?) {
        plateLabel.text = vehicle.licensePlate
        nameLabel.text = vehicle.getName()
        
        beaconImageView.isHidden = true
        rightIconImageView.removeFromSuperview()
        
        if let urlString = vehicle.image, let imgURL = URL(string: urlString) {
            vehicleImageView.kf.setImage(with: imgURL)
        } else {
            vehicleImageView.image = nil
        }
        
        if vehicle.beacon != nil {
            beaconImageView.isHidden = false
            beaconImageView.image = UIImage.app( "Type=Yes")
            beaconImageView.anchor(widthConstant: 24, heightConstant: 24)
        }

        switch type {
        case .arrow,
             .arrowRight,
             .selected:
            rightIconImageView.image = type == .arrow ? UIImage.app( "Direction=Down-2") : UIImage.app( "CheckCircle")
            if (type == .arrowRight) {
                rightIconImageView.image = UIImage.app( "Direction=Right-1")
            }
            addSubview(rightIconImageView)
            rightIconImageView.anchor(right: rightAnchor, rightConstant: 0, widthConstant: 24, heightConstant: 24)
            rightIconImageView.anchorCenterYToSuperview()
        default:
            break
        }
    }
}
