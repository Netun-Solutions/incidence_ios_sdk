//
//  CustomSlider.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 2/6/21.
//

import UIKit

@IBDesignable
class CustomSlider: UISlider {

    @IBInspectable
    var interval: Int = 1
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .white
        
        return thumb
    }()
    
    private lazy var stateImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: -20, y: -75, width: 60, height: 80))
        imageView.image = UIImage.app( "state-neutral")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var shadowImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.image = UIImage.app( "thumb")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var leftContraint: NSLayoutConstraint?
    var stateLeftContraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSlider()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSlider()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: 40)
        setThumbImage(thumb, for: .normal)
        
        addSubview(stateImageView)
        addSubview(shadowImageView)
        shadowImageView.anchor(widthConstant: 60, heightConstant: 60)
        shadowImageView.anchorCenterYToSuperview()
        leftContraint = shadowImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        leftContraint?.isActive = true
        
        stateImageView.anchor(widthConstant: 60, heightConstant: 80)
        stateImageView.anchorCenterYToSuperview(constant: -50)
        stateLeftContraint = stateImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        stateLeftContraint?.isActive = true
        handleValueChange()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        handleValueChange()
    }

    private func setUpSlider() {
        addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
    }

    @objc func handleValueChange() {
        let newValue =  (self.value / Float(interval)).rounded() * Float(interval)
        setValue(Float(newValue), animated: false)
        
        leftContraint?.constant = (CGFloat(newValue) * (self.frame.size.width + 30) / 5) - 15
        stateLeftContraint?.constant = (CGFloat(newValue) * (self.frame.size.width + 30) / 5) - 15

        switch newValue {
        case 0:
            stateImageView.image = UIImage.app( "valoration_face_very_bad")
        case 1:
            stateImageView.image = UIImage.app( "valoration_face_bad")
        case 2:
            stateImageView.image = UIImage.app( "valoration_face_neutral")
        case 3:
            stateImageView.image = UIImage.app( "valoration_face_good")
        case 4:
            stateImageView.image = UIImage.app( "valoration_face_very_good")
        default:
            break
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = 2
        
        return newRect
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
      
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
}
