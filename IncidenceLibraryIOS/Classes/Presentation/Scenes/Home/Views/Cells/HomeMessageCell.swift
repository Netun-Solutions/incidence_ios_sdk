//
//  HomeMessageCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/5/21.
//

import UIKit

protocol HomeMessageCellDelegate: AnyObject {
    func deletePressed(identifier: Any?)
}

class HomeMessageCell: UITableViewCell {

    static let reuseIdentifier = String(describing: HomeMessageCell.self)
    static let height = CGFloat(100)
    
    var identifier: Any?
    weak var delegate: HomeMessageCellDelegate?
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let iconImageView = UIImageView()
    let containerView = UIView()
    
    let deleteContainerView = UIView()
    
    var containerLeftConstraint: NSLayoutConstraint?
    var containerRightConstraint: NSLayoutConstraint?
    var deleteLeftConstraint: NSLayoutConstraint?
    
    let deleteButton = UIButton()
    
    var swipeLeft = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(deleteContainerView)
        contentView.addSubview(containerView)
        containerView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, topConstant: 0, bottomConstant: 24)
        containerLeftConstraint = containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24)
        containerLeftConstraint?.isActive = true
        containerRightConstraint = containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24)
        containerRightConstraint?.isActive = true
        
        containerView.backgroundColor = UIColor.app(.white)
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.app(.incidence200)?.cgColor
        
        containerView.addSubview(iconImageView)
        iconImageView.anchor(top: containerView.topAnchor, right: containerView.rightAnchor, topConstant: 24, rightConstant: 16, widthConstant: 24, heightConstant: 24)
        iconImageView.image = UIImage.app( "Direction=Right-1")
        
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: iconImageView.leftAnchor, topConstant: 16, leftConstant: 16, rightConstant: 16)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.app(.black600)
        titleLabel.font = UIFont.app(.primarySemiBold, size: 14)
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: iconImageView.leftAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.app(.black600)
        descriptionLabel.font = UIFont.app(.primaryRegular, size: 14)
        
        
        deleteContainerView.backgroundColor = UIColor.app(.errorPrimary)
        deleteContainerView.anchor(top: contentView.topAnchor, bottom: containerView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        deleteLeftConstraint = deleteContainerView.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0)
        deleteLeftConstraint?.isActive = true
        deleteContainerView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        
        deleteContainerView.addSubview(deleteButton)
        deleteButton.anchorCenterXToSuperview()
        deleteButton.anchorCenterYToSuperview()
        deleteButton.setTitle("Eliminar", for: .normal)
        deleteButton.setImage(UIImage.app( "Delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteButton.tintColor = UIColor.app(.white)
        deleteButton.titleLabel?.font = UIFont.app(.primaryRegular, size: 14)
        deleteButton.isMultipleTouchEnabled = true
        deleteButton.isUserInteractionEnabled = false
        deleteButton.alpha = 0
        
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showSwipe))
        swipeLeft.direction = .left
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(hideSwipe))
        swipeRight.direction = .right
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapDelete))
        deleteContainerView.addGestureRecognizer(tap)

    }
    
    public func configure(notification: INotification, identifier: Any?, delegate: HomeMessageCellDelegate?) {
        titleLabel.text = notification.title ?? ""
        descriptionLabel.text = notification.text
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        self.identifier = identifier
        self.delegate = delegate
        
        
        self.contentView.removeGestureRecognizer(swipeLeft)
        self.contentView.removeGestureRecognizer(swipeRight)
        
        if (notification.themeStatus == 1) // "themeStatus": 0=Default; 1=It can not be eliminated,
        { 
        }
        else
        {
            self.contentView.addGestureRecognizer(swipeLeft)
            self.contentView.addGestureRecognizer(swipeRight)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    @objc func showSwipe() {
        containerLeftConstraint?.constant = -124
        containerRightConstraint?.constant = -124
        deleteLeftConstraint?.constant = -132
        UIView.animate(withDuration: 0.3) { [self] in
            self.layoutIfNeeded()
            self.deleteButton.alpha = 1
        }
    }
    
    @objc func hideSwipe() {
        containerLeftConstraint?.constant = 24
        containerRightConstraint?.constant = -24
        deleteLeftConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.deleteButton.alpha = 0
        }
    }
    
    @objc func onTapDelete() {
        delegate?.deletePressed(identifier: identifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSwipe()
    }
}
