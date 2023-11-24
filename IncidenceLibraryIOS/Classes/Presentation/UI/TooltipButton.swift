//
//  TooltipButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 7/5/21.
//

import UIKit

class TooltipButton: UIButton {
    
    private var tooltipContainer = UIView()
    private var triangleView = UIView()
    private var tooltipLabel = UILabel()
    private var tooltipButton = UIButton()
    
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
    
    public func configure(text: String) {
        tooltipLabel.text = text
        tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
    }
    
    private func setUpUI() {
        
        self.setImage(UIImage.app( "Icon"), for: .normal)
        self.setTitle(nil, for: .normal)
        
        
        tooltipContainer = UIView()
        tooltipContainer.alpha = 0
        triangleView.alpha = 0
        tooltipContainer.isHidden = true
        tooltipContainer.backgroundColor = UIColor.app(.incidencePrimary)
        tooltipContainer.layer.cornerRadius = 8
        tooltipContainer.layer.masksToBounds = true
        self.addSubview(tooltipContainer)
        
        tooltipContainer.addSubview(tooltipLabel)
        tooltipContainer.addSubview(tooltipButton)
        
        tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        tooltipLabel.anchor(top: tooltipContainer.topAnchor, left: tooltipContainer.leftAnchor, bottom: tooltipContainer.bottomAnchor, right: tooltipButton.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipLabel.font = UIFont.app(.primaryRegular, size: 16)
        tooltipLabel.numberOfLines = 0
        tooltipLabel.textColor = UIColor.app(.white)
        
        
        tooltipButton.anchor(top: tooltipContainer.topAnchor, right: tooltipContainer.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 24, heightConstant: 24)
        tooltipButton.setImage(UIImage.app( "Cross"), for: .normal)
        tooltipButton.setTitle(nil, for: .normal)

        tooltipButton.addTarget(self, action: #selector(tooltipButtonPressed), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonPushed), for: .touchUpInside)
        
        self.addSubview(triangleView)
        triangleView.frame = CGRect(x: 3, y: 16, width: 18, height: 6)
        setUpTriangle()
    }
    
    func setUpTriangle(){
        let heightWidth = triangleView.frame.size.width
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:heightWidth))
        path.addLine(to: CGPoint(x:0, y:heightWidth))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.app(.incidencePrimary)?.cgColor

        triangleView.layer.insertSublayer(shape, at: 0)
    }
    
    @objc func tooltipButtonPressed() {
        
        if (!self.tooltipContainer.isHidden)
        {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                self.tooltipContainer.alpha = 0
                self.triangleView.alpha = 0
            }, completion: { _ in
                self.tooltipContainer.isHidden = true
                self.triangleView.isHidden = true
            })

        }
    }
    
    @objc func buttonPushed() {
        self.tooltipContainer.isHidden = false
        self.triangleView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.tooltipContainer.alpha = 1
            self.triangleView.alpha = 1
        }, completion: { _ in

        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let text = tooltipLabel.text else { return }
        let widthContainer = UIScreen.main.bounds.width - 80
        let height = text.height(withConstrainedWidth: widthContainer - 56, font: UIFont.app(.primaryRegular, size: 16)!)
        tooltipContainer.frame = CGRect(x: -(self.frame.origin.x - 40), y: 34, width: widthContainer , height: height + 32)
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if self.point(inside: point, with: event) {
//            return super.hitTest(point, with: event)
//        }
        
        tooltipButtonPressed()
        return super.hitTest(point, with: event)
    }
}


class ToolTip: UILabel {
    var roundRect:CGRect!
    override func drawText(in rect: CGRect) {
        super.drawText(in: roundRect)
    }
    override func draw(_ rect: CGRect) {
        roundRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * 4 / 5)
        let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 10.0)
        let triangleBez = UIBezierPath()
        triangleBez.move(to: CGPoint(x: roundRect.minX + roundRect.width / 2.5, y:roundRect.maxY))
        triangleBez.addLine(to: CGPoint(x:rect.midX,y:rect.maxY))
        triangleBez.addLine(to: CGPoint(x: roundRect.maxX - roundRect.width / 2.5, y:roundRect.maxY))
        triangleBez.close()
        roundRectBez.append(triangleBez)
        let bez = roundRectBez
        UIColor.lightGray.setFill()
        bez.fill()
        super.draw(rect)
    }
}
