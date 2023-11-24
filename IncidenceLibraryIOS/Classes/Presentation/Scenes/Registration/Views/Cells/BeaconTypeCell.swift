//
//  BeaconTypeCell.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 5/5/22.
//

import UIKit

class BeaconTypeCell: UITableViewCell {

    static let reuseIdentifier = String(describing: BeaconTypeCell.self)
    static let height = CGFloat(59)
    
    let menuView = MenuView()
    
    private weak var delegate: RegistrationBeaconSelectTypeViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        self.accessoryType = .none
        contentView.addSubview(menuView)
        menuView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
        
        let image = UIImage.app( "beacon")
        menuView.configure(text: "", iconImage: image, rightIcon: .none)
    }
    
    public func configure(with image: String?, title: String, identifier: Any?, delegate: RegistrationBeaconSelectTypeViewController?, rightIcon: MenuViewRightIcon, tooltipText: String?) {
        
        var img:UIImage? = nil
        if let imgStr = image {
            img = UIImage.app( imgStr)
        }
        menuView.configure(text: title, iconImage: img, rightIcon: rightIcon, rightIconDelegate: delegate != nil ? self : nil, tooltipText: tooltipText, identifier: identifier)
        self.delegate = delegate;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}


extension BeaconTypeCell: MenuViewRightIconDelegate {
    func menuView(with identifier: Any?) {
        self.delegate?.continueButtonPressed(identifier: identifier);
    }
    
    
}

