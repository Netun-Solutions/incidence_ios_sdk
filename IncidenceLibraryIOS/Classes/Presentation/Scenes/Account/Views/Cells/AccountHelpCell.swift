//
//  AccountHelpCell.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 20/5/22.
//

import UIKit

class AccountHelpCell: UITableViewCell {

    static let reuseIdentifier = String(describing: AccountHelpCell.self)
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
        
        let image = UIImage.app( "flag_spanish")
        menuView.iconImageView.contentMode = .scaleAspectFit
        menuView.configure(text: "", color: .white, iconImage: image, iconImageColored: true, rightIcon: .none)
    }
    
    public func configure(with model: String, leftIcon: String?, leftImageUrl: String?, rightIcon:MenuViewRightIcon, showLine:Bool) {
        
        
        let image = (leftIcon != nil) ? UIImage.app( leftIcon!) : nil
        
        
        var iconImageWidth = 24.0
        var iconImageHeight = 24.0
        if let url = leftImageUrl {
            iconImageWidth = 50.0
            iconImageHeight = 40
        }
        
        menuView.configure(text: model, color: .white, iconImage: image, iconImageWidth: iconImageWidth, iconImageHeight: iconImageHeight, iconImageColored: true, imageUrl: leftImageUrl, rightIcon: rightIcon)
        menuView.separator.isHidden = !showLine
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}
