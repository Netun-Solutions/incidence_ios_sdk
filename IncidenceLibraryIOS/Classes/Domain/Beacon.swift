//
//  Beacon.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 15/06/2021.
//

import UIKit

class Beacon:Codable
{
    var id: Int?
    var beaconType:BeaconType?
    var name: String?
    var vehicle:Vehicle?
    
    var uuid: String?
    var major: Int?
    var minor: Int?
    var proximity: String?
    var rssi: Int?
    var tx: Int?
    var accuracy: Double?
    var imei: String?
    
    var iot:String?
    
    
    func getId() -> String?
    {
        if let str = iot {
            return str
        }
        else if let uu = uuid, let ma = major, let mi = minor {
            return uu + "-" + String(ma) + "-" + String(mi)
        }
        
        return nil
    }
}

