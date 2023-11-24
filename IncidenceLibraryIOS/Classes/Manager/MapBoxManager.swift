//
//  MapBoxManager.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 17/06/2021.
//
/*
 import UIKit
 import MapboxSearch
 import MapboxGeocoder
 import CoreLocation
 
 
 protocol MapBoxManagerDelegate: AnyObject {
 func onReceiveAddress(address: Address?)
 
 }
 
 class MapBoxManager {
 
 static func searchAddress(location:CLLocationCoordinate2D, delegate:MapBoxManagerDelegate) {
 
 
 let accessToken = Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken")  as! String
 let geocoder = Geocoder(accessToken: accessToken)
 let options = ReverseGeocodeOptions(coordinate: location)
 
 let task = geocoder.geocode(options) { (placemarks, attribution, error) in
 guard let placemark = placemarks?.first else {
 return
 }
 
 let address = Address()
 address.postalCode = placemark.addressDictionary?["postalCode"] as? String
 address.city = placemark.addressDictionary?["city"] as? String
 address.country = placemark.addressDictionary?["country"] as? String
 address.street = placemark.addressDictionary?["street"] as? String
 address.streetNumber = placemark.addressDictionary?["subThoroughfare"] as? String
 
 delegate.onReceiveAddress(address: address)
 }
 }
 
 static func searchAddress(location:CLLocationCoordinate2D, completion: @escaping (Address) -> Void) {
 
 
 let accessToken = Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken")  as! String
 let geocoder = Geocoder(accessToken: accessToken)
 let options = ReverseGeocodeOptions(coordinate: location)
 
 let task = geocoder.geocode(options) { (placemarks, attribution, error) in
 guard let placemark = placemarks?.first else {
 return
 }
 
 let address = Address()
 address.postalCode = placemark.addressDictionary?["postalCode"] as? String
 address.city = placemark.addressDictionary?["city"] as? String
 address.country = placemark.addressDictionary?["country"] as? String
 address.street = placemark.addressDictionary?["street"] as? String
 address.streetNumber = placemark.addressDictionary?["subThoroughfare"] as? String
 
 completion(address)
 }
 }
 }
 */
