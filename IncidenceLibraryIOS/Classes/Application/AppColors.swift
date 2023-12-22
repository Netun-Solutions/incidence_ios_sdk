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
    
    static func appWithHex2(hex: String) -> UIColor? {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    let color = UIColor.init(red: r, green: g, blue: b, alpha: a)
                    return color
                }
            }
        }

        return nil
    }
    
    static func appWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor? {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        let color = UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}
