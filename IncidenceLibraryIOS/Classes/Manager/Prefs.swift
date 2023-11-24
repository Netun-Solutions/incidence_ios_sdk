//
//  Prefs.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 04/06/2021.
//

import UIKit

struct Prefs {

    static func saveString(key: String, value:String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func saveInt(key: String, value:Int)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func loadString(key: String) -> String?
    {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) as? String
    }
    
    static func loadInt(key: String) -> Int?
    {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) as? Int
    }
    
    static func removeData(key: String)
    {
        let defaults = UserDefaults.standard
        return defaults.removeObject(forKey: key)
    }
}
