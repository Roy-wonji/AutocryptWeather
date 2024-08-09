//
//  LocationManger.swift
//  Presentation
//
//  Created by 서원지 on 8/8/24.
//

import Foundation
import CoreLocation
import Foundations
import UseCase
import ComposableArchitecture

public class LocationManger: NSObject, CLLocationManagerDelegate {
    public static let shared = LocationManger()
     var manager = CLLocationManager()
     var currentLocation: CLLocationCoordinate2D?
   
    
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization() // Request permission
       
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
            currentLocation = location.coordinate


        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: Failed to get location: \(error.localizedDescription)")
    }
    
    public func getLocation() -> CLLocationCoordinate2D? {
        return currentLocation
    }

    public func checkAuthorizationStatus(completion: @escaping() -> Void, locationStatustOff: @escaping() -> Void) {

        if #available(iOS 14.0, *) {

            if manager.authorizationStatus == .authorizedAlways
                || manager.authorizationStatus == .authorizedWhenInUse {
                Log.debug("==> 위치 서비스 On 상태")
                completion()
                manager.startUpdatingLocation()
            } else if manager.authorizationStatus == .notDetermined {
                Log.debug("==> 위치 서비스 Off 상태")
                manager.requestWhenInUseAuthorization()
                locationStatustOff()
            } else if manager.authorizationStatus == .denied {
                Log.debug("==> 위치 서비스 Deny 상태")
                locationStatustOff()
            }

        } else {
            if CLLocationManager.locationServicesEnabled() {
                Log.debug("위치 서비스 On 상태")
                manager.startUpdatingLocation()
                Log.debug("LocationSerivece >> checkPermission() - \(manager.location?.coordinate)")
                completion()
            } else {
                Log.debug("위치 서비스 Off 상태")
                manager.requestWhenInUseAuthorization()
                locationStatustOff()
            }

        }
    }
    
    
    // Handle authorization status changes
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.requestAlwaysAuthorization()
            manager.requestLocation()
        case .restricted, .denied:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            manager.requestAlwaysAuthorization()
        @unknown default:
            Log.debug("DEBUG: 위치 서비스 Off 상태")
        }
    }
}
