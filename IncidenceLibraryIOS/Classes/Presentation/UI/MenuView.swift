//
//  MenuView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import UIKit
import Kingfisher

protocol MenuViewSwitchDelegate: AnyObject {
    func menuView(with identifier: Any?, switchValue value: Bool)
}

protocol MenuViewRightIconDelegate: AnyObject {
    func menuView(with identifier: Any?)
}

enum MenuViewColors {
    case black
    case red
    case blue
    case white
    case defaultColor
    
    func getColor() -> UIColor? {
        switch self {
        case .black:
            return UIColor.app(.black600)
        case .red:
            return UIColor.app(.errorPrimary)
        case .blue:
            return UIColor.app(.incidencePrimary)
        case .white:
            return UIColor.app(.white)
        case .defaultColor:
            let color : UIColor? = IncidenceLibraryManager.shared.getTextColor();
            return color ?? UIColor.app(.black600) ?? .black
        }
    }
}

enum MenuViewRightIcon {
    case arrow
    case arrowUp
    case arrowDown
    case exit
    case add
    case info
    case none
}

class MenuView: UIView {
    
    private var action: (() -> Void)?
    private var identifier: Any?
    private weak var switchDelegate: MenuViewSwitchDelegate?
    private weak var rightIconDelegate: MenuViewRightIconDelegate?
    
    let separator = UIView()
    let stackView = UIStackView()
    let label = TextLabel()
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.anchor(widthConstant: 24, heightConstant: 24)
        return imageView
    }()
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.app( "Direction=Right-1")?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    lazy var customSwitch: CustomUISwitch = {
        let customSwitch = CustomUISwitch()
        return customSwitch
    }()
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app(.incidencePrimary)
        view.anchor(widthConstant: 6, heightConstant: 6)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        
        return view
    }()
    //private var easyTipView: EasyTipView
    weak var easyTipView: EasyTipView?
    //var viewOpa: UIView?
    //let viewOpa = UIView()
    lazy var viewOpa: UIView = {
        let view = UIView(frame: (parentViewController?.view.frame)!)
        //view.backgroundColor = UIColor.app(.errorPrimary);
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeTooltip))
        view.addGestureRecognizer(tap)
        return view
    }()
    var customTooltipText: String = ""
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }

    public func configure(text: String,
                          color: MenuViewColors = .defaultColor,
                          iconImage: UIImage? = nil,
                          iconImageWidth:CGFloat = 24.0,
                          iconImageHeight:CGFloat = 24.0,
                          iconImageColored: Bool = false,
                          imageUrl: String? = nil,
                          rightIcon: MenuViewRightIcon = .arrow,
                          rightIconDelegate delegateRightIcon: MenuViewRightIconDelegate? = nil,
                          switchDelegate delegate: MenuViewSwitchDelegate? = nil,
                          showIndicator: Bool = false,
                          tooltipText: String? = nil,
                          tooltipView: UIView? = nil,
                          identifier: Any? = nil) {
        
        
        label.removeFromSuperview()
        customSwitch.removeFromSuperview()
        indicatorView.removeFromSuperview()
        iconImageView.removeFromSuperview()
        
        if delegateRightIcon == nil {
            stackView.removeFromSuperview()
            self.addSubview(stackView)
            stackView.anchor(left: self.leftAnchor, right: arrowImageView.leftAnchor, leftConstant: 40, rightConstant: 14)
            stackView.anchorCenterYToSuperview(constant: -1)
        } else {
            stackView.removeFromSuperview()
            self.addSubview(stackView)
            stackView.anchor(left: self.leftAnchor, right: arrowImageView.leftAnchor, leftConstant: 14, rightConstant: 14)
            stackView.anchorCenterYToSuperview(constant: -1)
        }
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.anchor(widthConstant: iconImageWidth, heightConstant: iconImageHeight)
        iconImageView = imageView
        
        
        label.numberOfLines = 2
        label.text = text
        label.textColor = color.getColor()
        
        if delegate != nil {
            self.switchDelegate = delegate
            
            self.addSubview(customSwitch)
            customSwitch.anchorCenterYToSuperview(constant: -1)
            customSwitch.anchor(right: self.rightAnchor, rightConstant: 14)
            customSwitch.set(width: 40, height: 24)
            customSwitch.offTint = UIColor.app(.black300)
            customSwitch.onTint = UIColor.app(.incidence500)
            arrowImageView.isHidden = true
            
            customSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        }
        
        switch rightIcon {
        case .arrow:
            let image = UIImage.app( "Direction=Right-1")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.image = image
            arrowImageView.tintColor = color.getColor()
            arrowImageView.isHidden = false
        case .arrowUp:
            let image = UIImage.app( "Direction=Up-2")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.image = image
            arrowImageView.tintColor = color.getColor()
            arrowImageView.isHidden = false
        case .arrowDown:
            let image = UIImage.app( "Direction=Down-2")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.image = image
            arrowImageView.tintColor = color.getColor()
            arrowImageView.isHidden = false
        case .add:
            let image = UIImage.app( "More")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.image = image
            arrowImageView.tintColor = color.getColor()
            arrowImageView.isHidden = false
        case .info:
            let image = UIImage.app( "info_blue")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.image = image
            arrowImageView.tintColor = MenuViewColors.blue.getColor()
            arrowImageView.isHidden = false
        case .none:
            arrowImageView.image = nil
            arrowImageView.isHidden = true
            break
        default:
            let image = UIImage.app( "Logout")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.image = image
            arrowImageView.tintColor = UIColor.app(.errorPrimary)
            arrowImageView.isHidden = false
        }
        
        if delegateRightIcon != nil {
            self.rightIconDelegate = delegateRightIcon
            arrowImageView.isUserInteractionEnabled = true
            
            //arrowImageView.addTarget(self, action: #selector(rightIconClick), for: .touchUpInside)
            let tap = UITapGestureRecognizer(target: self, action: #selector(rightIconClick))
            arrowImageView.addGestureRecognizer(tap)
        } else if (tooltipText != nil) {
            arrowImageView.isUserInteractionEnabled = true
            
            customTooltipText = tooltipText!
            
            if let identifier = identifier as? Int, identifier == 1
            {
                let tap = UITapGestureRecognizer(target: self, action: #selector(showTooltipQR))
                arrowImageView.addGestureRecognizer(tap)
            } else if let identifier = identifier as? Int, identifier == 2
            {
                let tap = UITapGestureRecognizer(target: self, action: #selector(showTooltipImei))
                arrowImageView.addGestureRecognizer(tap)
            }
        }
       
        
        if iconImage != nil {
            iconImageView.image = iconImage
            stackView.addArrangedSubview(iconImageView)
            
            if (iconImageColored)
            {
                iconImageView.image = iconImage?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = color.getColor()
            }
        }
        else if (imageUrl != nil) {
            let imgURL = URL(string: imageUrl ?? "")
            iconImageView.kf.setImage(with: imgURL)
            stackView.addArrangedSubview(iconImageView)
        }
    
        if (showIndicator) {
            self.addSubview(indicatorView)
            let width = text.width(withConstrainedHeight: 0, font: label.font)
            indicatorView.anchor(top: self.topAnchor, left: self.leftAnchor, topConstant: 22, leftConstant: width+66)
        }
        /*
        if (tooltipText != nil) {
            setTooltipText(tooltipText);
        } else {
            removeTooltipText()
        }
        */
        //setTooltipText(tooltipText);
        
        stackView.addArrangedSubview(label)
        
        self.identifier = identifier
    }
    
    public func onTap(closure: @escaping ()->Void) {
        self.action = closure
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        addGestureRecognizer(tap)
    }
    
    @objc private func onTapAction() {
        guard let action = action else { return }
        action()
    }
    
    private func setUpUI() {
        self.backgroundColor = .clear
        
        self.addSubview(arrowImageView)
        arrowImageView.anchorCenterYToSuperview(constant: -1)
        arrowImageView.anchor(right: self.rightAnchor, rightConstant: 14, widthConstant: 24, heightConstant: 24)
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.anchor(left: self.leftAnchor, right: arrowImageView.leftAnchor, leftConstant: 14, rightConstant: 14)
        stackView.anchorCenterYToSuperview(constant: -1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.app(.primaryRegular, size: 16)
        
        self.addSubview(separator)
        separator.backgroundColor = UIColor.app(.black300)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 1)
        
        var preferences = EasyTipView.Preferences()
                
        preferences.drawing.backgroundColor = UIColor.app(.incidencePrimary)!
        preferences.drawing.font = UIFont.app(.primaryRegular, size: 16)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.textAlignment = NSTextAlignment.center
        preferences.drawing.arrowPosition = .top
        preferences.drawing.arrowHeight = CGFloat(6)
        preferences.drawing.arrowWidth = CGFloat(18)
        
        preferences.positioning.bubbleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30.0);
        preferences.positioning.contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        
        preferences.animating.dismissOnTap = false;
        
        EasyTipView.globalPreferences = preferences
    }
    
    @objc func switchChanged(customSwitch: UISwitch) {
        switchDelegate?.menuView(with: identifier, switchValue: customSwitch.isOn)
    }
    
    @objc func rightIconClick() {
        rightIconDelegate?.menuView(with: identifier)
    }
    
    @objc func showTooltipQR() {
        let preferences = EasyTipView.globalPreferences
        
        //preferences.animating.dismissTransform = CGAffineTransform(translationX: 100, y: 0)
        //preferences.animating.showInitialTransform = CGAffineTransform(translationX: -100, y: 0)
        //preferences.animating.showInitialAlpha = 0
        //preferences.animating.showDuration = 1
        //preferences.animating.dismissDuration = 1
        
        
//        let contentView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 82))
//                    contentView.image = UIImage.app( "easytipview")
//                    EasyTipView.show(forView: self.buttonG,
//                                     contentView: contentView,
//                                     preferences: preferences)
        
        if easyTipView != nil {
            closeTooltip()
        } else {
            let x = 30.0;
            let width = UIScreen.main.bounds.width - x - x
            let widthMargin = 16.0
            let widthCross = 24.0
            let paddingLabel = 16.0
            let widthLabel = width - widthMargin - widthMargin - widthCross - paddingLabel
            let text = customTooltipText
            let font = UIFont.app(.primaryRegular, size: 16)!
            
            let textHeight = text.height(withConstrainedWidth: widthLabel, font: font);
            let yImage = textHeight + paddingLabel + paddingLabel
            
            let containerView = UIView(frame: CGRect(x:x,y:0,width:width,height:300))
            
            let tooltipLabel = UILabel(frame: CGRect(x: paddingLabel, y: paddingLabel, width:widthLabel, height:textHeight))
            //tooltipLabel.backgroundColor = UIColor.app(.black300)
            tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
            //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
            tooltipLabel.font = font
            tooltipLabel.numberOfLines = 0
            tooltipLabel.textColor = UIColor.app(.white)
            tooltipLabel.text = text
            containerView.addSubview(tooltipLabel)
            
            let crossImageView = UIImageView(frame: CGRect(x: width - 16 - 24, y: 16, width: 24, height: 24))
            //crossImageView.backgroundColor = UIColor.app(.black)
            crossImageView.image = UIImage.app( "Cross")
            crossImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeTooltip))
            crossImageView.addGestureRecognizer(tap)
            containerView.addSubview(crossImageView)
            
            let imageView = UIImageView(frame: CGRect(x:0, y:yImage, width:0, height:0))
            //imageView.backgroundColor = UIColor.app(.errorPrimary)
            if let image = UIImage.app( "device_img") {
                let ratio = image.size.width / image.size.height
                let newHeight = stackView.frame.width / ratio
                imageView.frame.size = CGSize(width: width, height: newHeight)
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
            }
            containerView.addSubview(imageView)
            
            let newHeight = yImage + imageView.frame.size.height + paddingLabel;
            containerView.frame.size = CGSize(width: containerView.frame.size.width, height: newHeight)
            
            parentViewController?.view.addSubview(viewOpa);
            
            let tip = EasyTipView(contentView: containerView, preferences: preferences)
            tip.show(animated: false, forView: arrowImageView, withinSuperview: parentViewController?.view)
            easyTipView = tip
             
            /*
            let width = UIScreen.main.bounds.width;
            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: 200))
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.axis = .vertical
            stackView.spacing = 6
            
            //stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            //stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            //stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            //stackView.rightAnchor.constraint(equalTo: self.ri, constant: 0).isActive = true
            //stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
//            NSLayoutConstraint.activate([
//                        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
//                        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//                        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//                        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//                        contentStackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
//                        contentStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
//                        contentStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
//                        contentStackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
//                        contentStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
//                    ])
            
            let tooltipLabel = UILabel()
            tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
            //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
            tooltipLabel.font = UIFont.app(.primaryRegular, size: 16)
            tooltipLabel.numberOfLines = 0
            tooltipLabel.textColor = UIColor.app(.white)
            tooltipLabel.text = "¿Dónde encuentro el QR de mi baliza?"
            tooltipLabel.sizeToFit()
            
            stackView.addArrangedSubview(tooltipLabel)
            
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.app(.errorPrimary)
            if let image = UIImage.app( "device_img") {
                let ratio = image.size.width / image.size.height
                let newHeight = stackView.frame.width / ratio
                imageView.frame.size = CGSize(width: width, height: newHeight)
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
            }
            stackView.addArrangedSubview(imageView)
            
            let tip = EasyTipView(contentView: stackView, preferences: preferences)
            tip.show(forView: arrowImageView)
            easyTipView = tip
            
            //stackView.anchor(top: self.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 24, rightConstant: 24)
            stackView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 24, rightConstant: 24)
             */
        }
    }
    
    @objc func showTooltipImei() {
        let preferences = EasyTipView.globalPreferences
        
        //preferences.animating.dismissTransform = CGAffineTransform(translationX: 100, y: 0)
        //preferences.animating.showInitialTransform = CGAffineTransform(translationX: -100, y: 0)
        //preferences.animating.showInitialAlpha = 0
        //preferences.animating.showDuration = 1
        //preferences.animating.dismissDuration = 1
        
        
//        let contentView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 82))
//                    contentView.image = UIImage.app( "easytipview")
//                    EasyTipView.show(forView: self.buttonG,
//                                     contentView: contentView,
//                                     preferences: preferences)
        
        if easyTipView != nil {
            closeTooltip()
        } else {
            let x = 30.0;
            let width = UIScreen.main.bounds.width - x - x
            let widthMargin = 16.0
            let widthCross = 24.0
            let paddingLabel = 16.0
            let widthLabel = width - widthMargin - widthMargin - widthCross - paddingLabel
            let text = customTooltipText
            let font = UIFont.app(.primaryRegular, size: 16)!
            
            let textHeight = text.height(withConstrainedWidth: widthLabel, font: font);
            let yImage = textHeight + paddingLabel + paddingLabel
            
            let containerView = UIView(frame: CGRect(x:x,y:0,width:width,height:300))
            
            let tooltipLabel = UILabel(frame: CGRect(x: paddingLabel, y: paddingLabel, width:widthLabel, height:textHeight))
            //tooltipLabel.backgroundColor = UIColor.app(.black300)
            tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
            //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
            tooltipLabel.font = font
            tooltipLabel.numberOfLines = 0
            tooltipLabel.textColor = UIColor.app(.white)
            tooltipLabel.text = text
            containerView.addSubview(tooltipLabel)
            
            let crossImageView = UIImageView(frame: CGRect(x: width - 16 - 24, y: 16, width: 24, height: 24))
            //crossImageView.backgroundColor = UIColor.app(.black)
            crossImageView.image = UIImage.app( "Cross")
            crossImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeTooltip))
            crossImageView.addGestureRecognizer(tap)
            containerView.addSubview(crossImageView)
            
            let newHeight = yImage + paddingLabel;
            containerView.frame.size = CGSize(width: containerView.frame.size.width, height: newHeight)
            
            parentViewController?.view.addSubview(viewOpa);
            
            let tip = EasyTipView(contentView: containerView, preferences: preferences)
            tip.show(animated: false, forView: arrowImageView, withinSuperview: parentViewController?.view)
            easyTipView = tip
        }
    }
    
    @objc func closeTooltip() {
        easyTipView?.dismiss()
        viewOpa.removeFromSuperview()
    }
    
    public func setSwitchValue(_ value: Bool) {
        customSwitch.setOn(value, animated: true)
    }
    
    public func setImage(image:UIImage?) {
        iconImageView.image = image
    }
    
    public func setImageSize(size:CGFloat)
    {
     /*
        
        
        
        //iconImageView.removeFromSuperview()
        stackView.removeArrangedSubview(iconImageView)
        
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.anchor(widthConstant: size, heightConstant: size)
        iconImageView = imageView
        stackView.insertArrangedSubview(iconImageView, at: 0)
      */
 
    }
    
    public func setTitle(title:String?) {
        label.text = title
    }
    
    /*
    func setTooltipText(_ tooltipText: String? = nil)
    {
        if let text = tooltipText {
            tooltipButton.configure(text: text)
            tooltipButton.isUserInteractionEnabled = true
            self.addSubview(tooltipButton)
            //tooltipButton.anchor(left: arrowImageView.rightAnchor, leftConstant: 4, widthConstant: 24, heightConstant: 24)
            //tooltipButton.anchor(right: self.rightAnchor, rightConstant: 14, widthConstant: 24, heightConstant: 24)
            tooltipButton.centerYAnchor.constraint(equalTo: arrowImageView.centerYAnchor).isActive = true
            
            
            //tooltipButton.addTarget(self, action: #selector(tooltipButtonPressed), for: .touchUpInside)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(buttonPushed))
            //tooltipButton.addGestureRecognizer(tap)
        }
    }
     */
//    func removeTooltipText() {
//        tooltipButton.removeFromSuperview()
//    }
}
