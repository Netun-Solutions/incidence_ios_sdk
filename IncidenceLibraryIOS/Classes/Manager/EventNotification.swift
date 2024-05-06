//
//  EventNotification.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 18/06/2021.
//

import UIKit

enum EventCode: String {
    case VEHICLE_ADDED
    case VEHICLE_UPDATED
    case VEHICLE_DELETED
    case VEHICLE_DRIVER_UPDATED
    case BEACON_ADDED
    case BEACON_UPDATED
    case BEACON_DELETED
    case USER_UPDATED
    case USER_LOCATION_UPDATED
    case INCIDENCE_REPORTED
    
    case LOCATION_RECEIVED
    
    case APP_DID_BECOME_ACTIVE
    
    case INCIDENCE_TIMER_CHANGE
    case INCICENDE_TIME_STOP
    case INCICENDE_TIME_STOP_REPEAT
    case INCICENDE_ALERT_DGT
    case INCICENDE_ALERT_TIME_UPDATED
}


class EventNotification
{
    static func post(code:EventCode)
    {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(code.rawValue), object: nil)
    }
    
    static func post(code:EventCode, object: Any?)
    {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(code.rawValue), object: object)
    }
    
    static func addObserver(_ observer: Any, code:EventCode, selector: Selector)
    {
        let nc = NotificationCenter.default
        nc.addObserver(observer, selector:selector, name: Notification.Name(code.rawValue), object: nil)
    }
}
