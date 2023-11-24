//
//  SlidingButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 1/6/21.
//


import UIKit

protocol SlideButtonDelegate{
    func buttonStatus(status:String, sender: SlidingButton)
}

@IBDesignable class SlidingButton: UIView{
    
    var delegate: SlideButtonDelegate?
    
    @IBInspectable var dragPointWidth: CGFloat = 70 {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var dragPointColor: UIColor = UIColor.darkGray {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonColor: UIColor = UIColor.gray {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonText: String = "UNLOCK" {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var imageName: UIImage = UIImage() {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }

    
    @IBInspectable var buttonUnlockedTextColor: UIColor = UIColor.white {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = 30 {
        didSet{
            setStyle()
        }
    }
    
    @IBInspectable var buttonUnlockedText: String   = "UNLOCKED"
    @IBInspectable var buttonUnlockedColor: UIColor = UIColor.black

    
    
    var dragPoint            = UIView()
    var buttonLabel          = UILabel()
    var imageView            = UIImageView()
    var unlocked             = false
    var layoutSet            = false
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func layoutSubviews() {
        if !layoutSet{
            self.setUpButton()
            self.layoutSet = true
        }
    }
    
    func setStyle(){
        self.buttonLabel.text               = self.buttonText
        self.dragPoint.frame.size.width     = self.dragPointWidth
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.imageView.image                = imageName
        self.buttonLabel.textColor          = self.buttonTextColor
        
        self.dragPoint.layer.cornerRadius   = 28
        self.layer.cornerRadius             = buttonCornerRadius
    }
    
    func setUpButton(){
        
        setHorizontalGradientColor(view: self)
        self.dragPoint                    = UIView(frame: CGRect(x: 4, y: 4, width: 56, height: 56))
        self.dragPoint.layer.cornerRadius = 28
        self.dragPoint.layer.masksToBounds = true
        self.dragPoint.backgroundColor    = dragPointColor
        self.addSubview(self.dragPoint)
        
        if !self.buttonText.isEmpty{
            
            self.buttonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.buttonLabel.textAlignment = .center
            self.buttonLabel.text          = buttonText
            self.buttonLabel.textColor     = UIColor.white
            self.buttonLabel.font          = UIFont.app(.primaryRegular, size: 14)
            self.buttonLabel.textColor     = self.buttonTextColor
            self.addSubview(self.buttonLabel)
        }
        self.bringSubviewToFront(self.dragPoint)
        
        if self.imageName != UIImage(){
            self.imageView = UIImageView()
            self.dragPoint.addSubview(self.imageView)
            self.imageView.anchor(top: dragPoint.topAnchor, left: dragPoint.leftAnchor, bottom: dragPoint.bottomAnchor, right: dragPoint.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 16, heightConstant: 16)
            self.imageView.contentMode = .center
            self.imageView.image = self.imageName.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = UIColor(red: 0.87, green: 0.33, blue: 0.46, alpha: 1.00)
            
        }
        
        self.layer.masksToBounds = true
        
        // start detecting pan gesture
        let panGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panDetected(sender: UIPanGestureRecognizer){
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)
        sender.view?.frame.origin.x = dragPointWidth + translatedPoint.x
        if sender.state == .ended || translatedPoint.x > (self.frame.size.width - 54){
            
            let velocityX = sender.velocity(in: self).x
            var finalX    = translatedPoint.x + velocityX
            if finalX < 0{
                finalX = 0
            }else if finalX + self.dragPointWidth  >  (self.frame.size.width - 156){
                unlocked = true
                self.unlock()
            }
            
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIView.AnimationOptions.curveEaseOut, animations: {
                }, completion: { (Status) in
                    if Status{
                        self.animationFinished()
                    }
            })
        }
    }
    
    func animationFinished(){
        if !unlocked{
            self.reset()
        }
    }
    
    //lock button animation (SUCCESS)
    func unlock(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width - 4, y: 4, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
                self.delegate?.buttonStatus(status: "Unlocked", sender: self)
            }
        }
    }
    
    //reset button animation (RESET)
    func reset(){
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: 4, y: 4, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
                self.unlocked                       = false
                //self.delegate?.buttonStatus("Locked")
            }
        }
    }
    
    func setHorizontalGradientColor(view: UIView) {
        self.insertHorizontalGradient(UIColor(red: 0.98, green: 0.47, blue: 0.60, alpha: 1.00), UIColor(red: 0.87, green: 0.33, blue: 0.46, alpha: 1.00))
    }
}
