//
//  AppColors.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

enum AssetsColor: String {
    case incidencePrimary
    case incidence50
    case incidence100
    case incidence200
    case incidence300
    case incidence300b
    case incidence400
    case incidence500
    case incidence600
    case white
    case errorPrimary
    case error200
    case black
    case black200
    case black300
    case black400
    case black500
    case black600
    case netunPrimary
    case success
    case vehicleBlue
    case vehicleDarkBlue
    case vehicleGreen
    case vehicleRed
    case vehicleYellow
    case help500
    case grey300
    case grey200
}

extension UIColor {
    static func app(_ name: AssetsColor) -> UIColor? {
        let bundle = Bundle(for: IncidenceLibraryManager.self)
        let color = UIColor(named: name.rawValue, in: bundle, compatibleWith: nil)
        return color
    }
}
