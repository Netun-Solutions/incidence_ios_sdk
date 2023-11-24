//
//  LocationManager.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 20/10/21.
//

import UIKit
import CoreLocation
import CoreBluetooth

protocol BeaconsDelegate: AnyObject {
    func onDetectBeacons(beacons: [Beacon])
}

final class LocationManager: NSObject, CLLocationManagerDelegate
{
    static let shared = LocationManager()
    var currentLocation:CLLocation!
    weak var beaconsDelegate: BeaconsDelegate?
    
    //Lo pasamos al AppDelegate ya que es donde mejor se comporta.
    //var locationManager: CLLocationManager!
    
    override init()
    {
        super.init()
        //locationManager = CLLocationManager()
        //locationManager.delegate = self
        //locationManager.distanceFilter = kCLDistanceFilterNone
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.allowsBackgroundLocationUpdates = true
    }
}

extension LocationManager
{
    ////////////////////////////////////////////////////
    //INIT Location beacons.
    func isBluetoothAuthorized() -> Bool {
            if #available(iOS 13.0, *) {
                return CBCentralManager().authorization == .allowedAlways
            }
            return CBPeripheralManager.authorizationStatus() == .authorized
        }
    
    func isLocationEnabled() -> Bool
    {
        var res = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        //print("No access")
                        res = false
                    case .authorizedAlways, .authorizedWhenInUse:
                        //print("Access")
                        res = true
                    @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
            res = false
        }
        
        return res
    }
    
    func isLocationEnabledAlways() -> Bool
    {
        var res = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
                        //print("No access")
                        res = false
                    case .authorizedAlways:
                        //print("Access")
                        res = true
                    @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
            res = false
        }
        
        return res
    }
    
    func isLocationDenied() -> Bool
    {
        var res = false
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied {
                res = true
            }
        } else {
            print("Location services are not enabled")
            res = false
        }
        
        return res
    }
    
    func requestLocation()
    {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysLocation()
    {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.locationManager.requestAlwaysAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation?
    {
        return currentLocation
    }
    
    func startUpdatingLocation()
    {
        if (isLocationEnabled())
        {
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.locationManager.startUpdatingLocation()
        }
    }
    
    
    //Beacons
    
    func getRegionIdentifier() -> String
    {
        return "AllBeaconsRegion"
    }
    
    func getBeaconRegion1() -> CLBeaconRegion
    {
        let uuid = UUID(uuidString: "75631298-a7eb-407c-8c0e-ba6b8920edad")!
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 27036, identifier: getRegionIdentifier())
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: getRegionIdentifier())
        //return beaconRegion
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "AllBeaconsRegion1")
        return beaconRegion
    }
    
    func getBeaconRegion2() -> CLBeaconRegion
    {
        let uuid = UUID(uuidString: "ba9a3092-a4b6-4ef7-aeb3-ea118ee5ee5d")!
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 27036, identifier: getRegionIdentifier())
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: getRegionIdentifier())
        //return beaconRegion
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "AllBeaconsRegion2")
        return beaconRegion
    }
    
    func startScanningBeacons(delegate:BeaconsDelegate)
    {
        /*
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            if CLLocationManager.isRangingAvailable() {
                
                beaconsDelegate = delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
                let beaconRegion = getBeaconRegion1()
                appDelegate.locationManager.startRangingBeacons(in: beaconRegion)
                
                let beaconRegion2 = getBeaconRegion2()
                appDelegate.locationManager.startRangingBeacons(in: beaconRegion2)
            }
        }
        */
    }
    
    func startMonitoring()
    {
        /*
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let list = Core.shared.getVehicles()
            var addeds = [String]()
            for vehicle in list {
                if let beacon = vehicle.beacon, let beaconKey = beacon.getId(), let uuid = beacon.uuid, let major = beacon.major, let minor = beacon.minor {
                    if (!addeds.contains(beaconKey)) {
                        let proximityUUID = UUID(uuidString: uuid)
                        let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID!, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: beaconKey)
                        appDelegate.locationManager.startMonitoring(for: beaconRegion)
                        addeds.append(beaconKey)
                    }
                }
            }
        }
        */
    }
    
    func stopMonitoring()
    {
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let beaconRegion = getBeaconRegion1()
        appDelegate.locationManager.stopMonitoring(for: beaconRegion)
        
        let beaconRegion2 = getBeaconRegion2()
        appDelegate.locationManager.stopMonitoring(for: beaconRegion2)
        
        let monitoredRegions = appDelegate.locationManager.monitoredRegions
        for region in monitoredRegions{
            appDelegate.locationManager.stopMonitoring(for: region)
        }
        */
    }
    
    func notificate(beaconKey: String) {
        print("notificate")
        /*
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date(timeIntervalSinceNow: 1)
        localNotification.alertTitle = "¿Has activado tu baliza?"
        localNotification.alertBody = "Haz click aquí para acceder directamente a la aplicación y reportar una incidencia"
        localNotification.timeZone = NSTimeZone.default
        UIApplication.shared.scheduleLocalNotification(localNotification)
        */
        /*
        let content = UNMutableNotificationContent()
        content.title = "ask_beacon_activated".localized()
        content.body = "ask_beacon_activated_desc".localized()
        content.sound = .default
        content.userInfo[AppDelegate.NOTIFICATION_BEACON_KEY] = beaconKey
        
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: AppDelegate.NOTIFICATION_BEACON_ID, content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.add(request) { (error) in
            print(error ?? "should have been added")
        }
        */
    }
    
    func proximityAsString(_ proximity: CLProximity) -> String? {
        let dict = [
            NSNumber(value: CLProximity.near.rawValue): "ProximityNear",
            NSNumber(value: CLProximity.far.rawValue): "ProximityFar",
            NSNumber(value: CLProximity.immediate.rawValue): "ProximityImmediate",
            NSNumber(value: CLProximity.unknown.rawValue): "ProximityUnknown"
        ]
        return dict[NSNumber(value: proximity.rawValue)]
    }
    
    func isLocationOutSpain(completion: @escaping (Bool) -> Void)
    {
        if (Core.shared.manualAddressCoordinate != nil)
        {
            if let manual = Core.shared.manualAddressCoordinate {
                let location = CLLocation(latitude: manual.latitude, longitude: manual.longitude)
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    
                    if let currentLocPlacemark = placemarks?.first {
                        if let countryCode = currentLocPlacemark.isoCountryCode, countryCode.uppercased() != "ES" {
                            completion(true)
                        }
                        else
                        {
                            completion(false)
                        }
                    }
                    else
                    {
                        completion(false)
                    }
                }
            }
            else {
                completion(false)
            }
        }
        else if (isLocationEnabled())
        {
            if let location = getCurrentLocation() {
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    
                    if let currentLocPlacemark = placemarks?.first {
                        if let countryCode = currentLocPlacemark.isoCountryCode, countryCode.uppercased() != "ES" {
                            completion(true)
                        }
                        else
                        {
                            completion(false)
                        }
                    }
                    else
                    {
                        completion(false)
                    }
                }
            }
            else
            {
                completion(false)
            }
        }
        else
        {
            completion(false)
        }
    }
}
