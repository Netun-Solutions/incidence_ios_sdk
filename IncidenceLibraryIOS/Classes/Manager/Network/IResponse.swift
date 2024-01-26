//
//  IResponse.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 10/05/2021.
//

import Foundation

struct IResponse {
    
    let json: [String: Any]?
    
    let status: String
    let action: String?
    let message: String?
    
    
    init(json:[String: Any]) {
        self.json = json
        
        self.status = json["status"] as! String
        if let val = json["action"] {
            self.action = val as! String
        } else {
            self.action = nil
        }
        if let val = json["message"] {
            self.message = val as! String
        } else {
            self.message = nil
        }
    }
    
    init() {
        self.status = "error"
        self.message = nil
        self.json = nil
        self.action = nil
    }
    
    init(error:Error) {
        self.status = "error"
        if ((error.asAFError?.isSessionTaskError) != nil)
        {
            if (error._code == 500 || error._code == 10) {
                self.message = "incidence_key_alert_error_ws".localized()
            }
            else {
                self.message = "incidence_key_alert_error_ws_connection".localized()
            }
            
        }
        else {
            var str = error.localizedDescription
            str = str.replacingOccurrences(of: "URLSessionTask failed with error: ", with: "")
            self.message = str
        }
        self.json = nil
        self.action = nil
    }
    
    func isSuccess() -> Bool {
        var res = false
        
        if (self.status == "success") {
            res = true
        }
        return res
    }
    
    func get<T: Codable>(key:String) -> T?
    {
        var res:T? = nil
        
        if (self.json != nil)
        {
            if let dictionary = self.json?[key] {
                do {
                    res = try JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: dictionary))
                } catch {
                    NSLog("--- FAIL: Error IResponse json decode: " + error.localizedDescription)
                    print(error)
                }
            }
        }
        
        return res
    }
    
    func getList<T: Codable>(key:String) -> [T]?
    {
        var res:[T]? = nil
        
        if (self.json != nil)
        {
            if let dictionary = self.json?[key] {
                do {
                    res = try JSONDecoder().decode([T].self, from: JSONSerialization.data(withJSONObject: dictionary))
                } catch {
                    NSLog("--- FAIL: Error IResponse json decode: " + error.localizedDescription)
                    print(error)
                }
            }
        }
        
        return res
    }
    
    func getJSONString() -> String?
    {
        if (self.json != nil)
        {
            let jsonData = try? JSONSerialization.data(withJSONObject: self.json!, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            
            return jsonString
        }
        
        return nil
    }
    
    func getJSONString(key:String) -> String?
    {
        if (self.json != nil)
        {
            let dictionary = self.json?[key]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary!, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            
            return jsonString
        }
        
        return nil
    }
    
    func getString(key:String) -> String?
    {
        if (self.json != nil)
        {
            if let result_number = self.json?[key] as? NSNumber
            {
              return "\(result_number)"
            }
            
            return self.json?[key] as? String
        }
        
        return nil
    }
}
