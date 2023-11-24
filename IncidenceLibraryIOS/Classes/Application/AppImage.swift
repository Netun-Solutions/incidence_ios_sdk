//
//  AppImage.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 4/9/23.
//

extension UIImage {
    static func app(_ named : String) -> UIImage? {
        let bundle = Bundle(for: IncidenceLibraryManager.self)
        return UIImage(named: named, in: bundle, with: nil)
    }
}
