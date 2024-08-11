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
    
    public static var currentLocation: CLLocationCoordinate2D?
   
    private var authorizationCheckTimer: Timer?
    
    override public init() {
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
            LocationManger.currentLocation = location.coordinate


        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: Failed to get location: \(error.localizedDescription)")
    }
    
    public func getLocation() -> CLLocationCoordinate2D? {
        return LocationManger.currentLocation
    }

    public func checkAuthorizationStatus() {
            if #available(iOS 14.0, *) {
                switch manager.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    Log.debug("==> 위치 서비스 On 상태")
                    manager.startUpdatingLocation()
                    stopAuthorizationCheckTimer()

                case .notDetermined:
                    Log.debug("==> 위치 서비스 Off 상태")
                    manager.requestWhenInUseAuthorization()
                    startAuthorizationCheckTimer()

                case .denied:
                    Log.debug("==> 위치 서비스 Deny 상태")
                    stopAuthorizationCheckTimer()

                default:
                    Log.debug("==> 위치 서비스 상태 확인 필요")
                    startAuthorizationCheckTimer()
                }
            } else {
                if CLLocationManager.locationServicesEnabled() {
                    Log.debug("위치 서비스 On 상태")
                    manager.startUpdatingLocation()
                    stopAuthorizationCheckTimer()
                } else {
                    Log.debug("위치 서비스 Off 상태")
                    manager.requestWhenInUseAuthorization()
                    startAuthorizationCheckTimer()
                }
            }
        }

        private func startAuthorizationCheckTimer() {
            stopAuthorizationCheckTimer() // Ensure no existing timer is running
            authorizationCheckTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
                self?.manager.requestWhenInUseAuthorization()
                self?.manager.requestLocation()
                
            }
        }

        private func stopAuthorizationCheckTimer() {
            authorizationCheckTimer?.invalidate()
            authorizationCheckTimer = nil
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
