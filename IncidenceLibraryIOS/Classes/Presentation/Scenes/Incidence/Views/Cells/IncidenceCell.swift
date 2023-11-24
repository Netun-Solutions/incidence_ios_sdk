//
//  IncidenceCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 13/5/21.
//

import UIKit

class IncidenceCell: UITableViewCell {

    static let reuseIdentifier = String(describing: IncidenceCell.self)
    static let height = CGFloat(99)
    
    let containerView = UIView()
    let titleLabel = TextLabel()
    let dateLabel = TextLabel()
    let addressLabel = TextLabel()
    let badgeView = BadgeView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        backgroundColor = .clear
        self.addSubview(containerView)
        containerView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 14, rightConstant: 24)
        containerView.backgroundColor = UIColor.app(.white)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.app(.incidence200)?.cgColor
        containerView.layer.cornerRadius = 8
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(badgeView)
        
        titleLabel.font = UIFont.app(.primarySemiBold, size: 16)
        titleLabel.textColor = UIColor.app(.black600)
        
        dateLabel.font = UIFont.app(.primaryRegular, size: 14)
        dateLabel.textColor = UIColor.app(.black500)
        
        addressLabel.font = UIFont.app(.primaryRegular, size: 14)
        addressLabel.textColor = UIColor.app(.black500)
        
        titleLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: dateLabel.leftAnchor, topConstant: 16, leftConstant: 16, rightConstant: 16)
        
        dateLabel.anchor(top: containerView.topAnchor, right: containerView.rightAnchor, topConstant: 16, rightConstant: 16)
        
        addressLabel.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, right: badgeView.leftAnchor, topConstant: 10, leftConstant: 16, rightConstant: 16)
        
        badgeView.anchor(right: containerView.rightAnchor, rightConstant: 16, heightConstant: 24)
        badgeView.centerYAnchor.constraint(equalTo: addressLabel.centerYAnchor).isActive = true
        
    }
    
    public func configure(with model: Incidence) {
        if let city = model.city {
            titleLabel.text = model.getTitle() + " " + "incidence_in".localized() + " " + city
        } else {
            titleLabel.text = model.getTitle()
        }
        
        dateLabel.text = model.dateCreated
        addressLabel.text = model.street
        
        let otherStr = model.isCanceled() ? "incidence_status_canceled".localized() : "incidence_status_active".localized()
        let otherColor = model.isCanceled() ? UIColor.app(.errorPrimary) : UIColor.app(.incidencePrimary)
        badgeView.configure(titleText: model.isClosed() ? "incidence_status_closed".localized() : otherStr, badgeColor: model.isClosed() ? UIColor.app(.success) : otherColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}
