//
//  BatteryExpirationView.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 27/10/22.
//

import UIKit

class BatteryExpirationView: UIView {
    
    private let titleLabel = UILabel()
    private let valueProgress = UIProgressView()
    private let separatorView = UIView()
    private let infoButton = UIButton()
    //private var showEditIcon = false
    private let subTitleLabel = UILabel()
    private let subTitleImage = UIImageView()
    //private var completion = (()  -> Void).self;
    private var completion:()->Void={}
    
    private lazy var tooltipButton: TooltipButton = {
       return TooltipButton()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }
    
    public func configure(titleText: String, progress: Float, completion: @escaping () -> Void) {
        titleLabel.text = titleText
        self.completion = completion
        //setTooltipText(tooltipText)
        //showEditIcon = hasEditIcon ?? false
        
        valueProgress.progress = progress / 100
        subTitleLabel.text = String(progress) + "%"
        
        if (progress < 20) {
            valueProgress.progressTintColor = UIColor.red
            infoButton.tintColor = UIColor.red
        }
    }

    
    private func setUpUI() {
        backgroundColor = .clear
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, topConstant: 16, leftConstant: 40, rightConstant: 40, heightConstant: 24)
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: 24).isActive = true
        titleLabel.textColor = UIColor.app(.black500)
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.app(.primaryRegular, size: 12)
        //titleLabel.backgroundColor = UIColor.app(.vehicleBlue)
        
        self.addSubview(infoButton)
        infoButton.anchor(left: titleLabel.rightAnchor, leftConstant: 4, widthConstant: 24, heightConstant: 24)
        infoButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        infoButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        infoButton.setImage(UIImage.app( "info_blue")?.withRenderingMode(.alwaysTemplate), for: .normal)
        infoButton.setTitle(nil, for: .normal)
        infoButton.addTarget(self, action: #selector(tooltipButtonPressed), for: .touchUpInside)
        
        self.addSubview(valueProgress)
        valueProgress.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 40, rightConstant: 24)
        valueProgress.progressTintColor = UIColor.blue
        valueProgress.progressViewStyle = .default
        //valueLabel.backgroundColor = UIColor.app(.vehicleRed)
        //valueLabel.progressViewStyle = .bar
        
        self.addSubview(subTitleLabel)
        subTitleLabel.anchor(top: valueProgress.bottomAnchor, left: self.leftAnchor, topConstant: 10, leftConstant: 40, heightConstant: 24)
        subTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: 24).isActive = true
        subTitleLabel.textColor = UIColor.app(.black500)
        subTitleLabel.numberOfLines = 1
        subTitleLabel.font = UIFont.app(.primaryRegular, size: 12)
        subTitleLabel.text = "90%"
        //subTitleLabel.backgroundColor = UIColor.app(.vehicleGreen)
        
        self.addSubview(subTitleImage)
        //subTitleImage.anchor(top: valueLabel.bottomAnchor, right: self.rightAnchor, topConstant: 10, rightConstant: 24, heightConstant: 24)
        subTitleImage.anchor(top: valueProgress.bottomAnchor, left: subTitleLabel.rightAnchor, topConstant: 10, leftConstant: 4, widthConstant: 20, heightConstant: 20)
        subTitleImage.image = UIImage.app( "battery")?.withRenderingMode(.alwaysTemplate)
        subTitleImage.tintColor = UIColor.app(.black400)
        
        self.addSubview(separatorView)
        separatorView.backgroundColor = UIColor.app(.black300)
        separatorView.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, leftConstant: 24, bottomConstant: 0, rightConstant: 24, heightConstant: 1)
    }
    
    @objc func tooltipButtonPressed() {
        self.completion()
    }
}
