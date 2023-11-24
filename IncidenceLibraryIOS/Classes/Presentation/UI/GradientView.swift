//
//  GradientView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 1/6/21.
//

import UIKit

@IBDesignable
public class GradientView: UIView {
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    private var gradient: CAGradientLayer?

    @IBInspectable
    public var color1: UIColor? {
        didSet {
            updateColors()
        }
    }

    @IBInspectable
    public var color2: UIColor? {
        didSet {
            updateColors()
        }
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        gradient = createGradient()
        updateColors()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        gradient = createGradient()
        updateColors()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradient?.frame = bounds
    }

    private func updateColors() {
        guard
            let color1 = color1,
            let color2 = color2
        else {
            return
        }

        gradient?.colors = [color1.cgColor, color2.cgColor]
    }
}
