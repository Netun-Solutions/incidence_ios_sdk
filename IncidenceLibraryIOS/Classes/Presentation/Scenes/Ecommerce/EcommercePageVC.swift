//
//  EcommercePageVC.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 25/10/21.
//

import UIKit
import Kingfisher


class EcommercePageVC: UIViewController {
    
    var imageView: UIImageView?
    var cardView: UIView?
    var titleLabel: UILabel?
    var descLabel: UILabel?
    var priceLabel: UILabel?
    var priceOldLabel: UILabel?
    var priceNewLabel: UILabel?
    var priceSubLabel: UILabel?
    
    var index: Int
    var item: EcommerceItem
    
    init(index: Int, item: EcommerceItem) {
        self.index = index
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        cardView = UIView.init()
        cardView?.backgroundColor = .white
        cardView?.layer.cornerRadius = 16
        self.view.addSubview(cardView!)
        cardView?.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 85, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        
        
        imageView = UIImageView.init()
        imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(imageView!)
        if let urlString = item.image, let imgURL = URL(string: urlString) {
            imageView?.kf.setImage(with: imgURL)
        }
        imageView?.anchor(top: view.topAnchor, topConstant: 10, heightConstant: 180)
        imageView?.anchorCenterXToSuperview()
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.anchor(top: imageView?.bottomAnchor, left: cardView?.leftAnchor, bottom: cardView?.bottomAnchor, right: cardView?.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        
        let contentView = UIView()
        scrollView.addSubview(contentView)

        titleLabel = UILabel()
        titleLabel?.textColor = UIColor.app(.black600)
        titleLabel?.font = UIFont.app(.primarySemiBold, size: 24)
        titleLabel?.text = item.title
        contentView.addSubview(titleLabel!)
        titleLabel?.anchor(top: contentView.topAnchor, left: cardView?.leftAnchor, right: cardView?.rightAnchor, topConstant: 0, leftConstant: 20, rightConstant: 20)
        titleLabel?.textAlignment = .center
        
        descLabel = UILabel()
        descLabel?.textColor = UIColor.app(.black500)
        descLabel?.font = UIFont.app(.primaryRegular, size: 14)
        descLabel?.numberOfLines = 0
        //descLabel?.text = item.text
        let font =  UIFont.app(.primaryRegular, size: 14)
        if let string = item.text {
            let formattedString = string.htmlAttributedString().with(font:font!)
            formattedString.addAttribute(.foregroundColor, value: UIColor.app(.black500), range: NSRange(location: 0, length: formattedString.length))
            descLabel?.attributedText = formattedString
        }
        contentView.addSubview(descLabel!)
        descLabel?.anchor(top: titleLabel?.bottomAnchor, left: cardView?.leftAnchor, right: cardView?.rightAnchor, topConstant: 20, leftConstant: 20, rightConstant: 20)
        
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.app(.grey300)
        contentView.addSubview(lineView)
        lineView.anchor(top: descLabel?.bottomAnchor, left: cardView?.leftAnchor, right: cardView?.rightAnchor, topConstant: 20, leftConstant: 20, rightConstant: 20, heightConstant: 1)
        
        if ("0,00" != item.offer_price) {
            
            let textPrice = (item.price ?? "") + " €"
            //let text = "10 €";
            //let text = "31,45 €";
            let text = (item.offer_price ?? "") + " €"
            let c = ","
            
            let str = NSString(string: text)
            let theRange = str.range(of: c)
            
            priceNewLabel = UILabel()
            //let text = (item.offer_price ?? "") + " €"
            let fontNewRegular = UIFont.app(.primaryRegular, size: 32)!
            let fontNewSubscript = UIFont.app(.primaryRegular, size: 12)!
            //let formattedStringNew = text.htmlAttributedString().with(font:fontNew!)
            //formattedStringNew.addAttribute(NSAttributedString.Key., value: 2, range: NSRange(location: 0, length: formattedStringOld.length))
            //priceNewLabel?.attributedText = formattedStringNew
            
            if (theRange.length != 0) {
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.font: fontNewRegular])
                attString.setAttributes([.font: fontNewSubscript, .baselineOffset: 16], range: NSRange(location: theRange.location, length: text.count - theRange.location))
                priceNewLabel?.attributedText = attString
            } else {
                priceNewLabel?.text = text
                priceNewLabel?.font = fontNewRegular
            }
            
            priceNewLabel?.textColor = UIColor.app(.incidencePrimary)
            contentView.addSubview(priceNewLabel!)
            priceNewLabel?.anchor(top: lineView.bottomAnchor, right: cardView?.rightAnchor, topConstant: 30, rightConstant: 0)
            priceNewLabel?.widthAnchor.constraint(equalTo: (cardView?.widthAnchor ?? contentView.widthAnchor), multiplier: 0.48).isActive = true
            priceNewLabel?.textAlignment = .left
            //priceNewLabel?.backgroundColor = UIColor.app(.vehicleRed)
            
            
            priceOldLabel = UILabel()
            let fontOld = UIFont.app(.primaryRegular, size: 20)
            let formattedStringOld = textPrice.htmlAttributedString().with(font:fontOld!)
            //formattedStringOld.addAttribute(.foregroundColor, value: UIColor.app(.black500), range: NSRange(location: 0, length: formattedStringOld.length))
            formattedStringOld.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: formattedStringOld.length))
            priceOldLabel?.attributedText = formattedStringOld
            
            priceOldLabel?.textColor = UIColor.app(.black600)
            contentView.addSubview(priceOldLabel!)
            priceOldLabel?.anchor(top: lineView.bottomAnchor, left: cardView?.leftAnchor, topConstant: 30, leftConstant: 0)
            priceOldLabel?.widthAnchor.constraint(equalTo: (cardView?.widthAnchor ?? contentView.widthAnchor), multiplier: 0.48).isActive = true
            if let heightAnchor = priceNewLabel?.heightAnchor {
                priceOldLabel?.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            }
            priceOldLabel?.textAlignment = .right
            //priceOldLabel?.backgroundColor = UIColor.app(.vehicleYellow)
            
            priceSubLabel = UILabel()
            priceSubLabel?.textColor = UIColor.app(.black500)
            priceSubLabel?.font = UIFont.app(.primaryRegular, size: 12)
            priceSubLabel?.text = "incidence_key_ecommerce_subtitle".localized();
            contentView.addSubview(priceSubLabel!)
            priceSubLabel?.anchor(top: priceOldLabel?.bottomAnchor, left: cardView?.leftAnchor, right: cardView?.rightAnchor, topConstant: 0, leftConstant: 20, rightConstant: 20)
            priceSubLabel?.textAlignment = .right
            
            
        } else {
            priceLabel = UILabel()
            priceLabel?.textColor = UIColor.app(.black600)
            priceLabel?.font = UIFont.app(.primarySemiBold, size: 24)
            priceLabel?.text = (item.price ?? "") + " €"
            contentView.addSubview(priceLabel!)
            priceLabel?.anchor(top: lineView.bottomAnchor, left: cardView?.leftAnchor, right: cardView?.rightAnchor, topConstant: 30, leftConstant: 20, rightConstant: 20)
            priceLabel?.textAlignment = .center
            
            priceSubLabel = UILabel()
            priceSubLabel?.textColor = UIColor.app(.black500)
            priceSubLabel?.font = UIFont.app(.primaryRegular, size: 12)
            priceSubLabel?.text = "incidence_key_ecommerce_subtitle".localized();
            contentView.addSubview(priceSubLabel!)
            priceSubLabel?.anchor(top: priceLabel?.bottomAnchor, left: cardView?.leftAnchor, right: cardView?.rightAnchor, topConstant: 0, leftConstant: 20, rightConstant: 20)
            priceSubLabel?.textAlignment = .right
        }
        
        
        contentView.anchor(top: scrollView.topAnchor, left: cardView?.leftAnchor, bottom: priceLabel?.bottomAnchor, right: cardView?.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20)
        contentView.layoutIfNeeded()
        scrollView.contentSize = contentView.frame.size
    }
}
