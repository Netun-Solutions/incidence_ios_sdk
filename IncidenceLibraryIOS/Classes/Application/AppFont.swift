//
//  AppFont.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

enum AssetsFont: String {
    case primaryRegular = "Silka-Regular"
    case primaryThin = "Silka-Thin"
    case primaryBold = "Silka-Bold"
    case primaryMedium = "Silka-Medium"
    case primarySemiBold = "Silka-SemiBold"
}

extension UIFont {
    static func app(_ name: AssetsFont, size: CGFloat) -> UIFont? {
        return UIFont(name: name.rawValue, size: size)
    }
}
