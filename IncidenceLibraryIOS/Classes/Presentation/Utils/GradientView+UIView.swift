//
//  GradientView+UIView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 1/6/21.
//

import UIKit

extension UIView {
    func insertHorizontalGradient(_ color1: UIColor, _ color2: UIColor) -> GradientView {
        let gradientView = GradientView(frame: bounds)
        gradientView.color1 = color1
        gradientView.color2 = color2
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.insertSubview(gradientView, at: 0)
        return gradientView
    }
}
