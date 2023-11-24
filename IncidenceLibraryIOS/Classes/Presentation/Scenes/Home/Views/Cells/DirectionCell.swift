//
//  DirectionCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 8/6/21.
//

import UIKit

class DirectionCell: UITableViewCell {

    static let reuseIdentifier = String(describing: DirectionCell.self)
    static let height = CGFloat(40)
    
    var identifier: Any?
    
    let label = TextLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.addSubview(label)
        contentView.backgroundColor = .clear
        label.textColor = UIColor.app(.black600)
        label.font = UIFont.app(.primaryRegular, size: 14)
        label.anchorCenterYToSuperview()
        label.anchor(left: contentView.leftAnchor, right: contentView.rightAnchor, leftConstant: 0, rightConstant: 0)
        label.numberOfLines = 0
        
    }
    
    public func configure(text: String) {
        label.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
}
