//
//  DateUtils.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 16/06/2021.
//

import UIKit

class DateUtils {

    static func dateStringFormat(_ dateStr: String?, fromFormat:String, toFormat:String) -> String
    {
        var res = ""
        
        if let text = dateStr, text.count > 0 {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = fromFormat
            
            let showDate = inputFormatter.date(from: text)
            inputFormatter.dateFormat = toFormat
            res = inputFormatter.string(from: showDate!)
        }
        
        return res
    }
    
    static func dateStringInternationalToSpanish(_ dateStr: String?) -> String
    {
        return dateStringFormat(dateStr, fromFormat: "yyyy-MM-dd", toFormat: "dd/MM/yyyy")
    }
    
    static func dateStringSpanishToInternational(_ dateStr: String?) -> String
    {
        return dateStringFormat(dateStr, fromFormat: "dd/MM/yyyy", toFormat: "yyyy-MM-dd")
    }
}
