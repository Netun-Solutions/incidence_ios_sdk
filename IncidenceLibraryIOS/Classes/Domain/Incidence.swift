//
//  Incidence.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 13/5/21.
//

import UIKit
import Foundation

public class Incidence:Codable {
    
    
    var id: Int?
    public var externalIncidenceId: String?
    public var street, city, country, dateCreated: String?
    public var latitude, longitude: Double?
    public var incidenceType: IncidenceType?
    var openApp: OpenApp? = nil
    
    //0=Pending; 1=Assigned; 2=On route; 3=In destination; 4=Closed
    var status: Int?
    
    let notifications: [INotification]?
    
    var rate: Int?
    var asitur: Int?
    var reporter: Int?
    
    public init()
    {
        self.id = nil
        self.externalIncidenceId = nil
        self.street = nil
        self.city = nil
        self.country = nil
        self.dateCreated = nil
        self.latitude = nil
        self.longitude = nil
        self.incidenceType = nil
        self.openApp = nil
        self.status = nil
        self.notifications = nil
        self.rate = nil
        self.asitur = nil
        self.reporter = nil
    }
    
    func isCanceled() -> Bool
    {
        var res = false

        if (status != nil && status == 5)
        {
            res = true
        }

        return res
    }
    
    func isClosed() -> Bool
    {
        var res = false

        if (status != nil && status == 4)
        {
            res = true
        }

        return res
    }
    
    func close()
    {
        status = 4
    }
    
    func getTitle() -> String
    {
        var res = ""
        
        if (incidenceType != nil && incidenceType?.name != nil) {
            res = incidenceType?.name ?? ""
        }
        
        return res
    }
}
