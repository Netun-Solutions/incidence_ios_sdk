//
//  StringUtils.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 15/06/2021.
//

import UIKit

class StringUtils: NSObject {

    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String {

    func localized(withComment comment: String? = nil) -> String {
        
        if let literales = Core.shared.literales {
            if let valor = literales[self] {
                var str = valor as! String
                str = str.replacingOccurrences(of: "\\n", with: "\n")
                return str
            }
        }
        let bundle = Bundle(for: IncidenceLibraryManager.self)
        return NSLocalizedString(self, bundle: bundle, comment: comment ?? "")
    }

    func localizedVoice(withComment comment: String? = nil) -> String {
        if let literales = Core.shared.voiceLiterales {
            if let valor = literales[self] {
                var str = valor as? String ?? ""
                str = str.replacingOccurrences(of: "\\n", with: "\n")
                return str
            }
        }
        
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
