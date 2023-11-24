//
//  DriverCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/5/21.
//

import UIKit

class DriverEditCell: UITableViewCell {

    static let reuseIdentifier = String(describing: DriverCell.self)
    static let height = CGFloat(88)
    
    let textView = TextFieldView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.addSubview(textView)
        textView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 24, rightConstant: 24)
    }
    
    public func configure(with name: String, editable: Bool) {
        textView.title = ""
        textView.value = name
        textView.isUserInteractionEnabled = false
        textView.isMultipleTouchEnabled = false
        textView.disablePadding()
        
        
        if (editable)
        {
            textView.showDelete = true
            textView.setDeleteImage(image: UIImage.init(named: "Direction=Down-2"), tintColor: UIColor.app(.black600) ?? .black)
            textView.setContainerBackgroundColor(color: .white)
            textView.setTextFieldColor(color: UIColor.app(.black600) ?? .black)
        }
        else
        {
            textView.showDelete = false
            textView.setContainerBackgroundColor(color: UIColor.app(.grey200) ?? .black)
            textView.setTextFieldColor(color: UIColor.app(.black400) ?? .black)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}
