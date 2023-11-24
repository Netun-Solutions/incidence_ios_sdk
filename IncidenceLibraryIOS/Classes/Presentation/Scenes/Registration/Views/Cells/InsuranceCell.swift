//
//  InsuranceCell.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit
import Kingfisher

class InsuranceCell: UITableViewCell {

    static let reuseIdentifier = String(describing: InsuranceCell.self)
    static let height = CGFloat(181)
    
    @IBOutlet weak var insuraceImageView: UIImageView!
    @IBOutlet weak var titleLabel: TextLabel!
    
    public func configure(with model: Insurance, boldText: String? = nil) {
        //insuraceImageView.image = model.image
        titleLabel.attributedText = nil
        titleLabel.text = model.name
        
        if let boldText = boldText {
            let attrs = [NSAttributedString.Key.font : UIFont.app(.primarySemiBold, size: 16)]
            let attributedString = NSMutableAttributedString(string:String(model.name.prefix(boldText.count)), attributes:attrs as [NSAttributedString.Key : Any])

            let normalText = model.name.dropFirst(boldText.count)
            let normalString = NSMutableAttributedString(string:String(normalText))

            attributedString.append(normalString)
            titleLabel.attributedText = attributedString
        }
        
        if let urlString = model.image, let imgURL = URL(string: urlString) {
            insuraceImageView.kf.setImage(with: imgURL)
        } else {
            insuraceImageView.image = nil
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}
